# AGENTS.md

## Project Overview

This repository holds a personal collection of **dot‑files**, helper scripts, and a handful of pre‑downloaded application binaries.
- Configuration files (e.g., `~/.config/*`, `~/.bashrc`, etc.) are stored in a directory‑tree that matches the home‑directory layout.
- **GNU Stow** is used to symlink the files into the user’s `$HOME`.
- A small set of utility scripts lives under `bin/` to automate common tasks (backup, app launch, audio switching, etc.).
- The `apps/` folder contains portable AppImage / binary releases of a few GUI tools (Etcher, HTTPie, TablePlus, …).

**Key technologies**:
- POSIX / Bash shell scripting
- GNU Stow (dot‑file management)
- AppImage (self‑contained binaries)

---

## Setup Commands

| Goal | Command | Description |
|------|---------|-------------|
| **Clone the repo** | `git clone https://<your-repo>.git ~/dot-files && cd ~/dot-files` | Creates a local copy in `~/dot-files`. |
| **Install prerequisites** | `sudo apt-get install stow` *(or the equivalent for your distro)* | GNU Stow is required for linking files. |
| **Apply the dot‑files** | `./update.sh` | Runs `stow -R -v -t ~ --dotfiles .` – recursively creates/updates symlinks in `$HOME`. |
| **Re‑apply after changes** | `./update.sh` | Re‑run anytime you modify files in the repo. |
| **Add a new dot‑file** | `stow -R -v -t ~ <relative-path>` | Example: `stow -R -v -t ~ .config/nvim` creates a link for the *nvim* config only. |
| **Remove all links** | `stow -D -v -t ~ --dotfiles .` | Deletes the managed symlinks without touching source files. |

> **Note for agents:** All commands above are safe to execute on a fresh system; they only manipulate symlinks under the user’s home directory.

---

## Development Workflow

1. **Edit files** – modify any file under the repository (e.g., `~/.bashrc`, `~/.config/…`).
2. **Run the update script** – `./update.sh` to propagate changes to the live environment.
3. **Test locally** – open a new terminal / reload the affected service (e.g., `source ~/.bashrc`).
4. **Commit** – `git add <changed-paths>` → `git commit -m "desc"` → `git push`.
5. **Pull‑request** – open a PR against the `main` branch (see PR guidelines below).

All scripts in `bin/` are POSIX‑compatible Bash files. They can be executed directly (`./bin/<script>.sh`) or via the `launch_app.sh` helper for GUI binaries.

---

## Testing Instructions

There is **no automated test suite** for this repository. Agents can verify correctness by:

```bash
# 1. Apply the dot‑files
./update.sh

# 2. Check that a known symlink points to the source file
[[ $(readlink -f ~/.bashrc) == "$(pwd)/.bashrc" ]] && echo "✓ bashrc linked"
```

If a script fails, run it with `set -x` (e.g., `sh -x bin/backup-gitlab.sh`) to debug.

---

## Code Style Guidelines

| Area | Guidelines |
|------|-------------|
| **Shell scripts** | • Use `#!/usr/bin/env sh` (POSIX sh).<br>• Prefer `set -euo pipefail` for safety (where applicable).<br>• Keep lines ≤ 120 chars.<br>• Run `shellcheck` locally for linting. |
| **File layout** | • One top‑level directory per logical component (`bin/`, `apps/`, `docs/`, `nixos/`).<br>• Keep the repo root tidy – only dot‑files, scripts, and docs. |
| **Naming** | • Scripts in `bin/` are lowercase, dash‑separated (`switch-audio-output.sh`).<br>• AppImage binaries stay under `apps/` with their original names. |
| **Formatting** | • Use two spaces for indentation in shell scripts.
| | • Markdown files follow standard GitHub rendering rules. |

---

## Build & Deployment

- **No build step** is required; the repository consists of static files.
- **Deployment** consists of running `./update.sh` on the target machine.
- For **remote machines** (e.g., a new laptop), clone the repo and run the same script.

**CI/CD (optional)** – a minimal GitHub Action could run `shellcheck` on all `*.sh` files:

```yaml
# .github/workflows/shellcheck.yml (example)
name: ShellCheck
on: [push, pull_request]
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Install ShellCheck
        run: sudo apt-get install -y shellcheck
      - name: Run ShellCheck
        run: shellcheck bin/*.sh
```

---

## Optional – Security Considerations

- No secret keys or passwords are stored in the repo.
- Scripts that interact with Docker or system files (`backup-gitlab.sh`, `reset-ide.sh`) should be reviewed before execution.
- When adding new scripts, avoid hard‑coding credentials; prefer environment variables or secret‑management tools.

---

## Pull Request Guidelines

| Requirement | Description |
|-------------|-------------|
| **Title format** | `feat: <short description>` or `fix: <short description>` |
| **Description** | Briefly explain *what* changed and *why*. Include any new dependencies (e.g., a new AppImage). |
| **Checks** | Run `./update.sh` locally to ensure the repository still applies cleanly. |
| **Review** | At least one maintainer must approve before merging. |
| **Commit style** | Follow the Conventional Commits spec (https://www.conventionalcommits.org). |

---

## Debugging & Troubleshooting

- **Broken symlink** – run `./update.sh` again; if it persists, delete the stray link manually and re‑run.
- **Script failures** – prepend `set -x` or invoke with `sh -x <script>` to see the command trace.
- **Permission errors** – ensure scripts are executable (`chmod +x bin/*.sh`).
- **AppImage not launching** – verify the file has execute permission and the required libraries are present (`ldd <AppImage>`).

---

## Additional Notes

- The `Pictures/` folder is purely cosmetic and not required for the dot‑files to function.

---

*This AGENTS.md file follows the public guidance at https://agents.md/ and provides coding agents with all actionable context needed to work efficiently on the `dot-files` repository.*
