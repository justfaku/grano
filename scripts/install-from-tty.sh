#!/bin/sh
set -eu

usage() {
    cat <<'EOF'
Usage: scripts/install-from-tty.sh

Install Grano from a real TTY without installing packages. Existing HyDE
configuration is backed up, never removed. The current graphical session is
terminated after confirmation and Grano is started through UWSM.
EOF
}

if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
    usage
    exit 0
fi

if [ "$#" -ne 0 ]; then
    printf '%s\n' 'Error: no options are accepted.' >&2
    usage >&2
    exit 2
fi

if ! tty -s </dev/tty 2>/dev/null; then
    printf '%s\n' 'Error: this script must be run from a real TTY.' >&2
    exit 1
fi

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
config_home=${XDG_CONFIG_HOME:-"$HOME/.config"}
grano_config="$config_home/grano"
backup_root="$config_home/grano-backups"
backup_dir="$backup_root/$(date +%Y%m%d-%H%M%S)"

required_commands='Hyprland hyprpaper waybar hypridle hyprlock kitty rofi wlogout brightnessctl wl-clip-persist wl-paste cliphist udiskie wpctl jq uwsm'
required_commands="$required_commands loginctl"
missing_commands=''

printf '%s\n' 'Grano TTY migration'
printf '%s\n' 'No packages will be installed.'

for command_name in $required_commands; do
    if ! command -v "$command_name" >/dev/null 2>&1; then
        missing_commands="$missing_commands $command_name"
    fi
done

if [ -n "$missing_commands" ]; then
    printf '%s\n' 'Missing required commands:' >&2
    for command_name in $missing_commands; do
        printf '  - %s\n' "$command_name" >&2
    done
    printf '%s\n' 'Install these packages separately, then run this script again.' >&2
    exit 1
fi

printf '%s\n' \
    '' \
    'The installer will terminate your current graphical session and' \
    'start Grano through UWSM. Unsaved graphical work will be lost.' \
    "Type GRANO to continue, or press Ctrl-C to cancel:"
IFS= read -r confirmation
if [ "$confirmation" != "GRANO" ]; then
    printf '%s\n' 'Migration cancelled before changing the system.' >&2
    exit 1
fi

backup_paths='hypr waybar kitty rofi hyprlock hypridle pypr uwsm'
backup_created=0
for path in $backup_paths; do
    source_path="$config_home/$path"
    if [ -e "$source_path" ]; then
        if [ "$backup_created" -eq 0 ]; then
            install -d "$backup_dir"
            backup_created=1
        fi
        cp -a "$source_path" "$backup_dir/"
    fi
done

if [ "$backup_created" -eq 1 ]; then
    printf 'Backed up existing configuration to %s\n' "$backup_dir"
else
    printf '%s\n' 'No existing desktop configuration needed a backup.'
fi

"$repo_dir/install.sh"

if command -v magick >/dev/null 2>&1; then
    printf '%s\n' 'Dynamic colors were generated during installation.'
else
    printf '%s\n' 'ImageMagick is not installed; Grano will use fallback colors.'
fi

printf '%s\n' 'Installing the Grano UWSM environment template.'
install -Dm755 "$grano_config/uwsm/env-hyprland.d/00-grano.sh" \
    "$config_home/uwsm/env-hyprland.d/00-grano.sh"

graphical_sessions=''
while read -r session_id _; do
    [ -n "$session_id" ] || continue
    session_user=$(loginctl show-session "$session_id" -p User --value 2>/dev/null || true)
    session_type=$(loginctl show-session "$session_id" -p Type --value 2>/dev/null || true)
    session_class=$(loginctl show-session "$session_id" -p Class --value 2>/dev/null || true)
    if [ "$session_user" = "$(id -u)" ] &&
        [ "$session_type" = "wayland" ] &&
        [ "$session_class" = "user" ]; then
        graphical_sessions="$graphical_sessions $session_id"
    fi
done <<EOF
$(loginctl list-sessions --no-legend)
EOF

for session_id in $graphical_sessions; do
    printf 'Terminating graphical session %s...\n' "$session_id"
    loginctl terminate-session "$session_id"
done

if [ -n "$graphical_sessions" ]; then
    attempts=0
    while [ "$attempts" -lt 20 ]; do
        still_active=0
        for session_id in $graphical_sessions; do
            if loginctl show-session "$session_id" >/dev/null 2>&1; then
                still_active=1
                break
            fi
        done
        [ "$still_active" -eq 0 ] && break
        attempts=$((attempts + 1))
        sleep 1
    done
    if [ "$still_active" -ne 0 ]; then
        printf '%s\n' 'Error: graphical session did not terminate in time.' >&2
        exit 1
    fi
fi

printf '%s\n' 'Starting Grano through UWSM.'
exec uwsm start -e -D Hyprland hyprland.desktop
