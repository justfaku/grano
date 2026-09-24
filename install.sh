#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
config_home=${XDG_CONFIG_HOME:-$HOME/.config}
grano_config="$config_home/grano"

install -d "$grano_config/wallpapers"
install -m 644 "$repo_dir/assets/wallpapers/wallpaper.webp" \
    "$grano_config/wallpapers/wallpaper.webp"
install -m 644 "$repo_dir/hypr/hyprpaper.conf" \
    "$grano_config/hyprpaper.conf"

printf '%s\n' "Installed Grano wallpaper and Hyprpaper configuration in $grano_config"
