# Dependencias de Grano

Esta lista describe los comandos usados por la configuracion propia.

## Base

- Hyprland
- hyprpaper
- waybar
- hypridle
- hyprlock
- kitty
- rofi
- wlogout
- brightnessctl
- wl-clip-persist
- wl-paste
- cliphist
- udiskie
- wpctl
- loginctl
- systemctl
- hyprctl
- ImageMagick (`magick`) para colores dinamicos

## Opcionales

- Pypr para scratchpads. Es opcional y no se inicia automaticamente.
- pavucontrol-qt para el panel grafico de audio.
- Cava si se implementa el modulo de visualizacion de audio.
- Wallbash como backend alternativo de colores. No es obligatorio.

## Arch Linux

El migrador actual verifica estos comandos, pero no instala paquetes:

- `Hyprland`, `hyprpaper`, `waybar`, `hypridle`, `hyprlock`
- `kitty`, `rofi`, `wlogout`, `brightnessctl`
- `wl-clip-persist`, `wl-paste`, `cliphist`, `udiskie`
- `wpctl`, `jq`, `uwsm`

Los nombres exactos de paquetes deben verificarse con `pacman -Ss` en la
instalacion destino. En el futuro se puede anadir un manifiesto Arch y una
opcion explicita para instalar los paquetes faltantes. La migracion actual no
instala paquetes.
