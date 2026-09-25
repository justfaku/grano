# Grano

Personal Arch Linux rice for Hyprland, inspired by HyDE.

Grano is being rebuilt as an independent, readable and reproducible desktop configuration. The repository contains the configuration that Grano owns; it does not copy generated system state or hidden framework internals.

## Current Status

Work in progress. The repository has an isolated Grano configuration tree, while the current desktop session remains unchanged.

## Install

Run the installer from the repository root:

```sh
./install.sh
```

The installer copies Grano files to `~/.config/grano/` and generates application colors from the bundled wallpaper when ImageMagick is available. Wallbash may be used as an optional color backend when already installed. A versioned static palette is always kept as fallback.

The installer does not:

- install Arch packages;
- activate the UWSM session template;
- replace the current desktop session;
- stop existing desktop services;
- start duplicate wallpaper, bar or idle processes.

## Layout

```text
assets/                 Versioned visual assets
hypr/                   Hyprland and Hyprpaper configuration
hypridle/               Idle manager configuration
hyprlock/               Lock screen configuration
kitty/                  Terminal configuration and theme
rofi/                   Launcher theme
scripts/                Small project utilities
uwsm/                   Environment template for the final activation step
waybar/                 Bar configuration and theme
docs/                   Dependency and maintenance notes
.github/                Project rules, audit and handoff notes
install.sh              Isolated installer
```

## Design Principles

- Keep configuration explicit and close to the native format of each tool.
- Separate versioned source files from generated runtime files.
- Keep static fallbacks for generated colors.
- Prefer small, replaceable components over a large framework.
- Audit the active system before copying behavior.
- Validate each migration block independently.
- Never modify external configuration as the permanent solution.

## Activation

Grano is currently installed as an isolated tree under `~/.config/grano/`. The UWSM environment template in `uwsm/env-hyprland.d/00-grano.sh` is intentionally not active yet.

Activating it is the final migration step, after the remaining session services and application integrations have been resolved. Do not activate it on top of another running desktop configuration.

The final activation is intentionally manual. After logging out of the current session, install the environment template into the user's UWSM environment directory, then start a fresh Hyprland session through UWSM. Do not perform this step while another Hyprland session is running.

```sh
install -Dm755 ~/.config/grano/uwsm/env-hyprland.d/00-grano.sh \\
	~/.config/uwsm/env-hyprland.d/00-grano.sh
```

## Documentation

- [Project handoff](.github/AI-HANDOFF.md): current state, decisions, validations and next steps.
- [Configuration audit](.github/configuration-audit.md): effective settings and migration history.
- [Dependencies](docs/dependencies.md): required and optional commands.

## Validation

```sh
/usr/bin/Hyprland --verify-config --config hypr/hyprland.conf
/usr/bin/sh -n install.sh
/usr/bin/bash -n scripts/generate-colors.sh
/usr/bin/jq empty waybar/config.jsonc
/usr/bin/git diff --check
```
