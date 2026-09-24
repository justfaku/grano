# Grano: auditoria de configuracion actual

Estado: investigacion inicial
Fecha: 2026-09-24

Este documento registra lo observado en la sesion actual. No es una configuracion de Grano y no debe usarse como destino para archivos de HyDE.

## Resumen

La sesion actual usa HyDE como framework de arranque y configuracion sobre Hyprland. El repositorio de Grano todavia no contiene una configuracion propia equivalente.

La cadena efectiva observada es:

```text
UWSM -> HyDE activation -> Hyprland -> ~/.local/share/hypr/hyde.lua
     -> modulos Lua de HyDE -> estado generado -> configuracion efectiva
```

El archivo `~/.config/hypr/hyprland.conf` no representa la configuracion completa de la sesion actual.

## Punto de entrada efectivo

Variables confirmadas en la sesion:

- `HYDE_ACTIVATED=1`
- `HYDE_MODE=lua`
- `HYDE_FEATURE_LUA=1`
- `HYPRLAND_CONFIG=~/.local/share/hypr/hyde.lua`

`hyde.lua` carga estos modulos principales:

- `variables`
- `defaults`
- `window_rules`
- `layer_rules`
- `env`
- `key_binds`
- `dynamic`
- `events`
- `start_up`
- `monitors`, si existe
- `hyprland`, si existe
- `lua_state.workflows`

## Configuracion visual efectiva

El estado generado por HyDE se encuentra en `~/.local/state/hyde/lua_state/`.

Valores confirmados mediante `hyprctl` y `hypr_theme.lua`:

- Layout: `dwindle`
- Rounding: `10`
- Gaps internos: `3`
- Gaps externos: `8`
- Borde: `2`
- Opacidad activa: `0.90`
- Opacidad inactiva: `0.75`
- Blur: activo
- Blur size: `5`
- Blur passes: `4`
- Blur ignora opacidad: activo
- Sombras: desactivadas
- Resize sobre bordes: activo
- VRR: `0`
- `dwindle.preserve_split`: activo
- `master.new_status`: `master`

No se observaron errores con `hyprctl configerrors`.

## Animacion y tema

Animacion seleccionada:

```text
~/.local/share/hypr/lua/animations/macos.lua
```

El estado generado la selecciona desde `lua_state/animations.lua`.

Caracteristicas principales del perfil:

- curvas spring para abrir y cerrar ventanas;
- ventanas con estilo `popin 90%`;
- movimiento de ventanas con `slide`;
- transiciones de workspace con `slidefade 20%`;
- fades, bordes y cambios de workspace activos.

Tema seleccionado:

- HyDE: `Decay Green`
- GTK: `Decay-Green`
- Iconos: `Tela-circle-green`
- Esquema: `prefer-dark`
- Wallbash: modo `theme`
- Shader: `disable`

Los colores de los bordes provienen de `~/.local/state/hyde/lua_state/colors.lua`, generado por Wallbash.

En `hypr/hyprland.conf` se agrego un snapshot estatico de los cuatro colores usados por los bordes. Esto conserva la apariencia actual sin hacer que Grano dependa de `colors.lua` o de Wallbash para iniciar Hyprland.

Esta paleta estatica es temporal. La idea futura es usar Wallbash, o una implementacion propia compatible, para regenerar los colores a partir del wallpaper seleccionado desde `assets/wallpapers/`. Esa integracion no forma parte de esta etapa.

## Componentes activos de la sesion

Confirmados por procesos o servicios de usuario:

- Hyprland
- Waybar
- Hypridle
- Hyprsunset
- wallpaper de HyDE
- watcher de configuracion de HyDE
- Pypr
- Cava para Waybar
- Wallbash/Swaync client
- `wl-clip-persist`
- `wl-paste` para texto e imagenes
- Udiskie
- Kitty

`hyprpaper` esta instalado y tiene configuracion, pero no se observo un proceso activo. El wallpaper actual lo gestiona el servicio de HyDE:

```text
~/.local/lib/hyde/wallpaper.sh --start --global
```

La configuracion existente de Hyprpaper apunta a `~/Pictures/wallpaper.png`, pero ese archivo no existe. El backend observado en la sesion es `awww`, iniciado y administrado por HyDE. Grano usara Hyprpaper como backend propio, pero todavia falta definir con `install.sh` la ruta instalada del asset antes de activarlo.

El recurso `wallpaper.webp` esta en `assets/wallpapers/wallpaper.webp`. Es un WebP de 1080x675 y coincide con la copia que estaba en `~/Downloads/wallpaper.webp`. Se eligio Hyprpaper como backend de Grano por ser estatico, simple y ya estar instalado. La convencion de instalacion sera `~/.config/grano/wallpapers/wallpaper.webp`, y `hypr/hyprpaper.conf` ya apunta a esa ruta. Todavia no se activa desde `hyprland.conf`: falta implementar el instalador y el arranque propio.

## Dependencias directas de HyDE

### Hyprland

- UWSM activa el entorno HyDE.
- `HYPRLAND_CONFIG` apunta a `hyde.lua`.
- Los modulos Lua de `~/.local/share/hypr/lua/` definen gran parte del comportamiento.
- Los valores finales de tema y animacion se generan en `~/.local/state/hyde/lua_state/`.

### Waybar

Configuracion del usuario:

- `~/.config/waybar/config.jsonc`
- `~/.config/waybar/includes/includes.json`
- `~/.config/waybar/style.css`
- `~/.config/waybar/theme.css`
- `~/.config/waybar/user-style.css`

Dependencias observadas:

- modulos en `~/.local/share/waybar/modules/`;
- estilos en `~/.local/share/waybar/styles/`;
- colores en `~/.cache/hyde/wallbash/gtk.css`;
- modulos como `custom/hyde-menu`;
- script `~/.local/lib/hyde/cava.py`.

Solo debe existir una instancia de Waybar. Durante la auditoria se inicio una instancia temporal de diagnostico y fue cerrada; la verificacion final mostro una sola instancia administrada por HyDE.

La barra visible usa actualmente estos grupos y modulos: workspaces, Cava, idle inhibitor, clock, backlight, pulseaudio, microfono, tray, battery, keybind hint, cliphist, hyprsunset, menu de HyDE y power. `includes.json` carga muchos modulos adicionales disponibles, pero no todos forman parte de la barra visible.

Se creo una configuracion propia en `waybar/config.jsonc` y `waybar/style.css` con los modulos funcionales que no necesitan HyDE. Todavia no reemplaza la barra activa: se instala de forma aislada bajo `~/.config/grano/waybar/` y debe conectarse al arranque propio de Grano despues de completar los modulos dependientes.

Los modulos que quedaron fuera por ahora son Cava, keybind hint, cliphist avanzado, hyprsunset con menu, power menu y menu de HyDE.

### Kitty

`~/.config/kitty/kitty.conf` incluye `hyde.conf`, que a su vez incluye `theme.conf`.

### Hypridle

`~/.config/hypr/hypridle.conf` depende de `hyde-shell` para lockscreen y unlock.

### Hyprlock

`~/.config/hypr/hyprlock.conf` carga configuracion desde `~/.local/share/hypr/` y selecciona el layout `~/.config/hypr/hyprlock/HyDE.conf`.

## Archivos disponibles que no deben asumirse activos

La existencia de un archivo no demuestra que se cargue. Esto aplica especialmente a:

- `~/.config/hypr/hyprland.conf`
- `~/.config/hypr/animations.conf`
- `~/.config/hypr/userprefs.conf`
- `~/.config/hypr/monitors.conf`
- workflows alternativos como `gaming`, `powersaver`, `snappy` y `editing`
- perfiles alternativos de animacion.

## Pendientes

- [x] Documentar el orden exacto de precedencia entre `defaults`, `dynamic`, estado generado y workflows.
- [x] Documentar reglas de ventanas y reglas de capas efectivamente cargadas.
- [x] Auditar keybinds efectivos y separar comandos HyDE de comandos reemplazables.
- [x] Auditar monitores y convertir el monitor actualmente usado a configuracion propia.
- [x] Extraer la decoracion efectiva a una configuracion explicita de Grano.
- [x] Extraer las animaciones de `macos.lua` sin copiar la infraestructura Lua de HyDE.
- [x] Determinar el flujo real de wallpaper, Wallbash y colores.
- [x] Crear la configuracion propia de Hyprpaper y definir la ruta instalada de los assets.
- [x] Implementar `install.sh` para instalar el wallpaper en `~/.config/grano/wallpapers/`.
- [x] Conectar Hyprpaper al arranque propio de Grano sin iniciar una segunda instancia de wallpaper.
- [ ] Reemplazar la paleta estatica temporal por colores generados desde el wallpaper de `assets/wallpapers/` mediante Wallbash o una integracion propia.
- [x] Separar modulos funcionales de Waybar de modulos propios de HyDE.
- [ ] Conectar la configuracion propia de Waybar al arranque de Grano.
- [ ] Reemplazar los modulos de Waybar que todavia dependen de HyDE.
- [ ] Separar configuracion de Kitty y Rofi de sus temas generados.
- [ ] Migrar Hyprlock y Hypridle eliminando `hyde-shell`.
- [ ] Auditar servicios de arranque y decidir cuales necesita Grano.
- [ ] Definir una estrategia de instalacion reproducible para una instalacion limpia de Arch Linux.

La migracion de animaciones ya fue realizada en `hypr/hyprland.conf`. El perfil no conserva el nombre `macos`: ahora forma parte de la configuracion propia de Grano. Las curvas `spring` de la API Lua fueron reemplazadas por aproximaciones Bezier declarativas, porque `hyprland.conf` no expone la API de curvas spring. La configuracion fue validada con `Hyprland --verify-config`.

## Orden de migracion propuesto

1. Decoracion de Hyprland.
2. Animaciones y layout.
3. Monitores.
4. Keybinds, reglas y scripts usados.
5. Wallpaper, Wallbash y paleta.
6. Waybar.
7. Kitty y Rofi.
8. Hyprlock e Hypridle.
9. Servicios de arranque y eliminacion progresiva de HyDE.

Cada etapa debe producir un cambio pequeno, verificable y separado de los demas. No modificar archivos internos de HyDE como solucion permanente.

## Primer paso de migracion

Se creo `hypr/hyprland.conf` como configuracion propia y aislada de Grano. Todavia no esta conectada a la sesion actual.

Incluye la parte declarativa que Hyprland puede resolver directamente:

- monitor actual;
- teclado e input;
- decoracion, blur, opacidad y sombras;
- gaps, bordes y colores;
- layout `dwindle`;
- opciones de `dwindle`, `master`, `misc`, `xwayland` y `snap`;
- activacion general de animaciones.

La configuracion fue validada con `Hyprland --verify-config` y devolvio `config ok`.

## Keybinds migrados

`hypr/hyprland.conf` contiene ahora los keybinds nativos de Hyprland para:

- cerrar, forzar el cierre, salir, hacer floating y pseudo-tile;
- fullscreen y cambio de split;
- mover el foco;
- redimensionar y mover ventanas;
- mover ventanas con el raton;
- navegar y mover ventanas entre los workspaces 1 a 10.

Se dejaron fuera los binds que llaman `hyde-shell`, menus de Rofi, wallpaper, lockscreen, volumen, brillo, capturas y seleccion de temas. Esos comandos requieren una migracion separada de sus scripts y dependencias.

## Reglas migradas

`hypr/hyprland.conf` contiene ahora reglas declarativas para:

- ventanas de dialogo, portales, gestores de archivos y utilidades flotantes;
- ventanas Picture-in-Picture, con pin, posicion y tamano;
- dialogos de autenticacion y seleccion de archivos;
- `xwaylandvideobridge`, con sus restricciones de foco, animacion, blur, tamano y workspace;
- capas de Rofi, notificaciones, Swaync, Waybar y logout;
- capa `selection`, sin animacion.

Estas reglas provienen de `window_rules.lua` y `layer_rules.lua`. Durante la auditoria, las capas observadas en ejecucion fueron `waybar` y `awww-daemon`; el resto de reglas corresponde a componentes disponibles que no estaban abiertos en ese momento.

### Que puede vivir en hyprland.conf

La mayor parte de la configuracion del compositor puede mantenerse en un unico archivo legible: monitores, input, decoracion, layouts, animaciones, reglas, keybinds, variables y comandos `exec-once`.

### Que no conviene forzar dentro de hyprland.conf

Estos componentes siguen siendo procesos o logica externa y deben mantenerse separados:

- Waybar y sus modulos CSS/JSON;
- Hypridle y Hyprlock;
- wallpaper y seleccion de wallpapers;
- Wallbash y generacion de colores;
- scripts de menu, clipboard y utilidades;
- Kitty, Rofi y otras aplicaciones.

La arquitectura objetivo puede ser un `hyprland.conf` principal con `source` puntuales para bloques grandes, pero no debe convertir servicios externos en configuracion falsa del compositor.
