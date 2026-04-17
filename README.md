# dot-files

A curated collection of personal configuration files, helper scripts, and a few portable applications. Designed for effortless setup across Linux systems using GNU Stow.

## 📦 Repository Overview

- **dotfiles** – Files mirroring the structure of `$HOME` (e.g., `.bashrc`, `.config/nvim/`, `.zshrc`).
- **bin/** – Small POSIX‑compatible Bash utilities for backups, audio switching, Bluetooth reconnection, shell bar management, and more.
- **apps/** – Portable AppImage binaries (Etcher, HTTPie, TablePlus, …) managed by `launch_app.sh`.
- **docs/** – Documentation and prompts for some utilities.

## 🚀 Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/wert2all/dot-files.git ~/dot-files
cd ~/dot-files

# 2. Install prerequisites
sudo apt-get install stow  # or your distro's equivalent

# 3. Apply the dot‑files
./update.sh
```

> **Tip** – Run `./update.sh` again anytime you modify a file in the repository to refresh the symlinks.

## 🔧 Managing dot‑files with GNU Stow

| Action | Command |
|--------|---------|
| **Apply all dot‑files** | `./update.sh` |
| **Add a new dot‑file** | `stow -R -v -t ~ <relative‑path>` |
| **Remove all managed links** | `stow -D -v -t ~ --dotfiles .` |
| **Refresh after changes** | `./update.sh` |

> **Note** – All Stow operations only create or delete symlinks under `$HOME`; source files stay untouched.

## 🛠️ Utility Scripts

| Script | Description | Usage |
|--------|-------------|-------|
| `backup-gitlab.sh` | Creates a compressed backup of a Docker‑based GitLab instance. | `./bin/backup-gitlab.sh` |
| `launch_app.sh` | Simple launcher for the AppImages in `apps/`. | `./bin/launch_app.sh <app>` |
| `switch-audio-output.sh` | Interactive selector (fzf) to change the default PulseAudio sink. | `./bin/switch-audio-output.sh` |
| `re-connect-handphones.sh` | Re‑connects Bose Bluetooth headphones automatically. | `./bin/re-connect-handphones.sh` |
| `switch_projects.sh` | Rofi/Tofi based project switcher that opens a tmux session. | `./bin/switch_projects.sh` |
| `start_android_emulator.sh` | Starts an Android emulator (requires Android SDK). | `./bin/start_android_emulator.sh [AVD]` |
| `system-toggle-keyboard-brightness.sh` | Toggles the laptop keyboard backlight. | `./bin/system-toggle-keyboard-brightness.sh` |
| `waybar-wg-status.sh` | Shows WireGuard status for Waybar. | Used as a Waybar custom module |
| `re-launch-polybar.sh` | Restarts polybar (useful in window manager startup scripts). | `./bin/re-launch-polybar.sh` |
| `re-launch-waybar.sh` | Restarts waybar (Wayland compositor bar). | `./bin/re-launch-waybar.sh` |
| `git_remove_branges.sh` | Deletes all local branches except `main`/`master`. | `./bin/git_remove_branges.sh` |
| `init_api_keys.sh` | Loads various API keys from `pass` into the environment. | `source ./bin/init_api_keys.sh` |

All scripts are executable (`chmod +x bin/*.sh`) and can be run directly or via `launch_app.sh` where appropriate.

> **Note** – `_functions.sh` is an internal helper library; not meant to be executed directly.

## 📄 License

This repository is licensed under the MIT License. See [LICENSE](./LICENSE) for details.

Automated PR test added at 2026-04-17T08:13:33Z
