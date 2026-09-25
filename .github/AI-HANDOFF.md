# Grano: handoff para la proxima IA

Fecha de referencia: 2026-09-24

Lee primero:

1. `.github/copilot-instructions.md`
2. `.github/configuration-audit.md`
3. este archivo

Este documento resume el estado operativo del proyecto para continuar la migracion sin volver a investigar lo ya confirmado.

## Objetivo

Grano es un rice personal para Arch Linux con Hyprland. La referencia visual y funcional actual es una sesion que usa HyDE, pero el resultado final debe ser propio, entendible, reproducible y sin depender de HyDE.

La estrategia es:

```text
HyDE actual -> auditoria -> extraccion -> simplificacion -> Grano independiente
```

No copiar archivos internos de HyDE sin demostrar que estan activos. No modificar `~/.local/share/hypr/` como solucion permanente.

## Estado actual de la sesion

La sesion activa sigue usando HyDE:

- `HYDE_MODE=lua`
- `HYDE_ACTIVATED=1`
- `HYPRLAND_CONFIG=~/.local/share/hypr/hyde.lua`
- Hyprland activo mediante UWSM.
- Waybar, Hypridle, Hyprsunset, Pypr, Awww y servicios `hyde-*` siguen siendo la sesion actual.

La configuracion de Grano aun no reemplaza la sesion activa. No iniciar la configuracion de Grano encima de HyDE sin planificar el cambio de backend y evitar duplicados.

## Lo que ya esta en Grano

### Hyprland

`hypr/hyprland.conf` contiene una configuracion propia y validada con `Hyprland --verify-config`:

- monitor `DP-1`, 1920x1080 a 200 Hz;
- input `us, es`;
- gaps 3/8;
- borde 2;
- rounding 10;
- opacidad 0.90/0.75;
- blur activo, size 5, passes 4;
- sombras desactivadas;
- layout `dwindle`;
- animaciones propias basadas en el perfil activo de HyDE;
- keybinds nativos para ventanas y workspaces 1-10;
- reglas de ventanas y capas extraidas de HyDE;
- `exec-once` para Hyprpaper cuando esta configuracion sea la activa;
- `source = ./colors.conf` para la paleta.

Las curvas `spring` del perfil Lua fueron aproximadas con Bezier porque `hyprland.conf` no expone esa API Lua.

### Wallpaper y colores

- Recurso: `assets/wallpapers/wallpaper.webp`.
- Instalacion prevista: `~/.config/grano/wallpapers/wallpaper.webp`.
- Backend elegido para Grano: Hyprpaper.
- Configuracion: `hypr/hyprpaper.conf`.
- Fallback: `hypr/colors.conf`.
- Generador: `scripts/generate-colors.sh`.
- El generador usa `~/.local/lib/hyde/wallbash.sh` solo si Wallbash ya existe y ImageMagick esta instalado.
- Wallbash no se instala en una instalacion limpia.
- Si Wallbash no existe, se conserva el fallback estatico.

La sesion actual usa Awww administrado por HyDE, no el Hyprpaper de Grano. No cambiar eso durante una auditoria.

### Instalador

`install.sh` instala en `~/.config/grano/`:

- `wallpapers/wallpaper.webp`;
- `colors.conf`;
- `generate-colors.sh`;
- `hyprpaper.conf`;
- `waybar/config.jsonc`;
- `waybar/style.css`.
- `kitty/kitty.conf`;
- `kitty/theme.conf`;
- `rofi/theme.rasi`.

`scripts/generate-colors.sh` regenera tambien `waybar/theme.css`, `kitty/theme.conf` y `rofi/theme.rasi` desde la misma salida de Wallbash. Los archivos versionados siguen siendo fallbacks.

Si Wallbash e ImageMagick existen, genera colores dinamicos durante la instalacion. La prueba aislada del instalador ya paso.

### Waybar

Configuracion propia aislada:

- `waybar/config.jsonc`;
- `waybar/style.css`.

Modulos propios ya cubiertos:

- workspaces;
- idle inhibitor;
- clock;
- backlight con `brightnessctl`;
- audio y microfono con `wpctl`;
- tray;
- battery;
- clipboard basico con `cliphist`, `rofi` y `wl-copy`;
- power menu con `wlogout`.

La configuracion se instala en `~/.config/grano/waybar/`. `hypr/hyprland.conf` la inicia con rutas explicitas cuando Grano sea la configuracion activa. Esto no reemplaza la Waybar activa mientras la sesion siga usando HyDE.

`style.css` usa deliberadamente `@define-color`, que es sintaxis GTK/Waybar valida. El parser CSS generico de VS Code puede marcar falsos positivos.

## Lo que falta

Orden recomendado:

1. Completar Waybar sin copiar HyDE:
   - decidir si Cava tendra implementacion propia;
   - reemplazar keybind hint;
   - decidir un control seguro para Hyprsunset, sin lanzar procesos duplicados;
   - crear un menu propio si se necesita el menu de HyDE.
2. Retirar la Waybar de HyDE cuando Grano sea la sesion activa.
3. Conectar Kitty y Rofi propios al arranque/configuracion activa de Grano.
4. Conectar Hyprlock e Hypridle propios al arranque de Grano.
5. Reemplazar servicios de arranque `hyde-*` por mecanismos propios.
7. Decidir el futuro de Wallbash:
   - dependencia independiente;
   - algoritmo extraido;
   - generador propio.
8. Completar `install.sh` para una instalacion limpia de Arch y documentar paquetes requeridos.
9. Conectar Grano como sesion activa solo cuando las dependencias anteriores esten resueltas.

## Bloqueos y decisiones

- No instalar Wallbash automaticamente: hoy proviene de HyDE y eso contradice la independencia final.
- No migrar Hyprsunset desde `hyde-shell` sin un mecanismo de control seguro.
- No ejecutar Waybar de diagnostico en la sesion: puede crear una segunda instancia.
- No usar rutas del checkout dentro de la configuracion instalada.
- No reemplazar Awww por Hyprpaper en la sesion actual durante la investigacion.
- La paleta dinamica debe tener siempre fallback estatico.

## Validaciones conocidas

Usar estas comprobaciones despues de cambios relevantes:

```sh
Hyprland --verify-config --config "$PWD/hypr/hyprland.conf"
sh -n install.sh
bash -n scripts/generate-colors.sh
jq empty waybar/config.jsonc
git diff --check
```

No hay un modo seguro de validar Waybar que no inicie otra instancia. Validar JSON con `jq` y no lanzar Waybar salvo que sea estrictamente necesario.

## Estado Git al crear este handoff

Ultimo commit conocido:

```text
19d42fd add Wallbash color generation (without installation) with fallback
```

Hay cambios posteriores sin commit en:

- `.github/configuration-audit.md`;
- `waybar/config.jsonc`.

No incluir en commits de migracion:

- `.github/copilot-instructions.md`;
- `.vscode/`.

## Regla de continuidad

Cada etapa debe ser pequena, conceptual y validable. Antes de editar, explicar que controla el componente, de donde viene, si esta activo y que dependencia tiene. Despues de editar, validar inmediatamente. No hacer una migracion masiva ni crear dependencias innecesarias.
