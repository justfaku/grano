# Grano — instrucciones para agentes

Grano es un rice personal para Arch Linux, Hyprland y aplicaciones Wayland.

## Objetivo

Mantener una configuracion propia, simple, versionable, reproducible y facil de entender.

## Reglas

- Analizar primero la configuracion efectiva del sistema.
- Diferenciar configuracion activa, disponible, generada y no utilizada.
- Preferir configuracion declarativa y explicita.
- No copiar frameworks, scripts o archivos generados sin justificar su necesidad.
- No modificar archivos externos al repositorio como solucion permanente.
- Mantener cambios pequenos y conceptuales.
- Validar cada etapa antes de continuar.
- No iniciar procesos de escritorio duplicados durante las pruebas.
- No introducir dependencias sin documentarlas.
- No hacer commits automaticamente salvo peticion expresa.

## Flujo de trabajo

1. Identificar el archivo o componente que controla el comportamiento.
2. Explicar su origen, uso y dependencias.
3. Crear una implementacion propia en el repositorio.
4. Validar sintaxis y comportamiento aislado.
5. Actualizar `.github/AI-HANDOFF.md` y `docs/dependencies.md`.
6. Proponer un commit conceptual.
