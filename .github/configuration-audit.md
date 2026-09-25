# Auditoria de Grano

Estado: migracion incremental en curso
Fecha: 2026-09-25

Este documento describe el estado de la configuracion propia del repositorio. No representa automaticamente la sesion activa del sistema.

## Estado implementado

- `hypr/hyprland.conf`: monitor, input, decoracion, blur, layout, animaciones, reglas, keybinds y arranque propio.
- `hypr/colors.conf`: fallback de colores.
- `scripts/generate-colors.sh`: generador propio basado en ImageMagick.
- `hypr/hyprpaper.conf`: wallpaper estatico.
- `waybar/`: barra propia, con temas generables y fallback.
- `kitty/`: configuracion y tema propios.
- `rofi/`: tema propio.
- `hyprlock/`: lockscreen propio.
- `hypridle/`: idle manager propio.
- `pypr/`: scratchpad opcional.
- `uwsm/env-hyprland.d/00-grano.sh`: plantilla de entorno, aun no activada.
- `install.sh`: instalacion aislada bajo `~/.config/grano/`.

## Arquitectura

```text
wallpaper
  -> scripts/generate-colors.sh
  -> ~/.config/grano/colors.conf
  -> Hyprland / Waybar / Kitty / Rofi / Hyprlock
```

La paleta versionada funciona como fallback cuando ImageMagick no esta disponible.

## Estado de sesion

La sesion del sistema todavia usa una configuracion externa y sus servicios propios. Grano no debe activarse encima de ella porque produciria backends duplicados para wallpaper, barra o idle.

La activacion de `uwsm/env-hyprland.d/00-grano.sh` es el ultimo paso de la migracion.

## Pendientes

- [ ] Completar modulos restantes de Waybar: Cava, keybind hint, control de temperatura y menu principal.
- [ ] Conectar Kitty y Rofi propios a los lanzadores de Grano.
- [ ] Retirar servicios externos de wallpaper, barra, idle y configuracion cuando Grano sea la sesion activa.
- [ ] Decidir si Pypr se instala como opcion o se elimina del arranque.
- [ ] Verificar nombres de paquetes Arch en una instalacion limpia.
- [ ] Activar y probar la plantilla UWSM de Grano como ultimo paso.

## Decisiones

- Hyprland usa `hyprland.conf`, no Lua, para mantener la configuracion legible y nativa.
- Hyprpaper es el unico backend de wallpaper de Grano.
- La generacion de colores es propia y usa ImageMagick; no depende de herramientas externas del sistema anterior.
- Los fallbacks de color permanecen versionados.
- No se instalan ni se activan servicios de escritorio automaticamente durante la migracion.

## Validaciones

```sh
/usr/bin/Hyprland --verify-config --config hypr/hyprland.conf
/usr/bin/sh -n install.sh
/usr/bin/bash -n scripts/generate-colors.sh
/usr/bin/jq empty waybar/config.jsonc
/usr/bin/git diff --check
```
