#!/bin/sh
set -eu

printf '%s\n' \
'  ____                              ' \
' / ___|_ __ __ _ _ __  ____         ' \
'| |  _| __/ _` | _ \ /  _  \        ' \
'| |_| | || (_| | | | | (_| /        ' \
' \____|\__\__,_|_| |_|\___/         ' \
'                                    ' \
' +--------------------------------+ ' \
' |  GRANO // INSERT COIN         | ' \
' |  ARCH LINUX RICE INSTALLER    | ' \
' +--------------------------------+ '

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
config_home=${XDG_CONFIG_HOME:-$HOME/.config}
grano_config="$config_home/grano"

install -d "$grano_config"
install -m 644 "$repo_dir/hypr/hyprland.conf" \
    "$grano_config/hyprland.conf"
install -d "$grano_config/wallpapers"
install -m 644 "$repo_dir/assets/wallpapers/wallpaper.webp" \
    "$grano_config/wallpapers/wallpaper.webp"
install -m 644 "$repo_dir/hypr/colors.conf" "$grano_config/colors.conf"
install -m 755 "$repo_dir/scripts/generate-colors.sh" \
    "$grano_config/generate-colors.sh"
install -m 644 "$repo_dir/hypr/hyprpaper.conf" \
    "$grano_config/hyprpaper.conf"
install -d "$grano_config/waybar"
install -m 644 "$repo_dir/waybar/config.jsonc" \
    "$grano_config/waybar/config.jsonc"
install -m 644 "$repo_dir/waybar/style.css" \
    "$grano_config/waybar/style.css"
install -m 644 "$repo_dir/waybar/theme.css" \
    "$grano_config/waybar/theme.css"
install -d "$grano_config/kitty" "$grano_config/rofi"
install -m 644 "$repo_dir/kitty/kitty.conf" "$grano_config/kitty/kitty.conf"
install -m 644 "$repo_dir/kitty/theme.conf" "$grano_config/kitty/theme.conf"
install -m 644 "$repo_dir/rofi/theme.rasi" "$grano_config/rofi/theme.rasi"
install -d "$grano_config/hyprlock" "$grano_config/hypridle"
install -m 644 "$repo_dir/hyprlock/hyprlock.conf" \
    "$grano_config/hyprlock.conf"
install -m 644 "$repo_dir/hypridle/hypridle.conf" \
    "$grano_config/hypridle.conf"
install -m 644 "$repo_dir/pypr/config.toml" "$grano_config/pypr.toml"
install -d "$grano_config/uwsm/env-hyprland.d"
install -m 755 "$repo_dir/uwsm/env-hyprland.d/00-grano.sh" \
    "$grano_config/uwsm/env-hyprland.d/00-grano.sh"

if command -v magick >/dev/null 2>&1; then
    "$grano_config/generate-colors.sh" \
        "$grano_config/wallpapers/wallpaper.webp" \
    "$grano_config/colors.conf" || printf '%s\n' 'Color generation failed; keeping fallback colors.' >&2
fi

printf '%s\n' "Installed Grano wallpaper, Hyprpaper, and Waybar files in $grano_config"
