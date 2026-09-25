# Handoff de Grano

Lee primero:

1. `.github/copilot-instructions.md`
2. `.github/configuration-audit.md`
3. `docs/dependencies.md`

## Objetivo

Construir un rice propio para Arch Linux y Hyprland, reproducible y facil de mantener.

## Estado

La configuracion propia ya existe en el repositorio y se instala de forma aislada en `~/.config/grano/`. La sesion actual todavia no usa esa configuracion. No iniciar Grano encima de la sesion actual: puede duplicar wallpaper, barra o idle manager.

## Archivos principales

- `hypr/hyprland.conf`: configuracion declarativa principal.
- `hypr/colors.conf`: fallback de color.
- `scripts/generate-colors.sh`: colores dinamicos propios mediante ImageMagick.
- `hypr/hyprpaper.conf`: wallpaper.
- `waybar/`: barra y estilos.
- `kitty/`, `rofi/`: terminal y launcher.
- `hyprlock/`, `hypridle/`: bloqueo e idle.
- `pypr/`: scratchpad opcional.
- `uwsm/env-hyprland.d/00-grano.sh`: entorno preparado, no activado.
- `install.sh`: instalador aislado.

## Lo que ya funciona en el repositorio

- Decoracion, layout, animaciones, reglas y keybinds declarativos.
- Wallpaper versionado en `assets/wallpapers/`.
- Fallback de colores.
- Temas compartidos para Hyprland, Waybar, Kitty y Rofi.
- Waybar propia con workspaces, reloj, audio, bateria, clipboard y power menu.
- Hyprlock e Hypridle propios.
- Clipboard persistente, almacenamiento de cliphist y Udiskie en el arranque propio.
- Generador y pruebas aisladas del instalador.

## Pendientes

1. Completar los modulos restantes de Waybar.
2. Conectar Kitty y Rofi a los lanzadores propios.
3. Revisar si Pypr debe ser opcional o instalarse como dependencia.
4. Verificar paquetes Arch en una instalacion limpia.
5. Activar UWSM de Grano como ultimo paso.
6. Retirar la configuracion externa y servicios duplicados solo despues de validar Grano.

## Reglas de seguridad

- No iniciar Waybar, Hyprpaper, Hypridle o Hyprlock para pruebas si ya existe una instancia activa.
- No modificar configuraciones fuera del repositorio como solucion definitiva.
- No activar la plantilla UWSM antes de terminar la migracion.
- No instalar dependencias automaticamente sin documentarlas.

## Validacion

```sh
/usr/bin/Hyprland --verify-config --config hypr/hyprland.conf
/usr/bin/sh -n install.sh
/usr/bin/bash -n scripts/generate-colors.sh
/usr/bin/jq empty waybar/config.jsonc
/usr/bin/git diff --check
```
