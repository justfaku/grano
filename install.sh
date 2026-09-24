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
install -d "$grano_config/waybar"
install -m 644 "$repo_dir/waybar/config.jsonc" \
    "$grano_config/waybar/config.jsonc"
install -m 644 "$repo_dir/waybar/style.css" \
    "$grano_config/waybar/style.css"

printf '%s\n' "Installed Grano wallpaper, Hyprpaper, and Waybar files in $grano_config"
