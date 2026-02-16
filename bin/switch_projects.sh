#!/usr/bin/env bash

# Default launcher
LAUNCHER="rofi -dmenu"

# Check for command-line arguments
if [ "$1" = "--rofi" ]; then
  LAUNCHER="rofi -dmenu"
elif [ "$1" = "--tofi" ]; then
  LAUNCHER="tofi"
elif [ -n "$1" ]; then
  echo "Error: Unknown option '$1'. Use '--tofi' or '--rofi'." >&2
  exit 1
fi

TERMINAL="kitty"

NVIM_ENTRY=" nvim"
DOT_ENTRY="󰇘 dot-files"
OBSIDIAN_ENTRY="󰠮 obsidian"

PROJECT_ANSIBLE=" ansible"
PROJECT_BOOTSTRAP="󰣪 bootstrap.sh"
PROJECT_ANGULAR_HOUSEHOLD=" angular-household"
PROJECT_ANGULAR_DESK_LAN=" angular-desk-lan"
PROJECT_ANGULAR_DEVFORGE="󰣪 angular-dev-forge"
PROJECT_LARAVEL_DEVFORGE="󰣪 laravel-dev-forge"

PROJECTS_ARRAY=(
  "${NVIM_ENTRY}"
  "${DOT_ENTRY}"
  "${OBSIDIAN_ENTRY}"
  "${PROJECT_ANGULAR_DEVFORGE}"
  "${PROJECT_LARAVEL_DEVFORGE}"
  "${PROJECT_ANGULAR_HOUSEHOLD}"
  "${PROJECT_ANGULAR_DESK_LAN}"
  "${PROJECT_ANSIBLE}"
  "${PROJECT_BOOTSTRAP}"
)
IFS=$'\n'
PROJECTS="${PROJECTS_ARRAY[*]}"
unset IFS

SELECTED=$(echo -en "$PROJECTS" | ${LAUNCHER})

start_session() {
  local PROJECT="$1"
  local FOLDER="$2"

  if [ -z "$PROJECT" ]; then
    echo "Error: No project selected."
    exit 1
  fi

  local command="$TERMINAL -e tmux new-session -As $PROJECT"
  if [ ! -z "$FOLDER" ]; then
    command="$command -c $FOLDER"
  fi
  exec $command
}

case "$SELECTED" in
$NVIM_ENTRY)
  start_session "nvim" "${HOME}/.config/nvim/"
  ;;
$DOT_ENTRY)
  start_session "dot-files" "${HOME}/work/dot-files/"
  ;;
$OBSIDIAN_ENTRY)
  start_session "obsidian" "${HOME}/Documents/obsidian/"
  ;;
$PROJECT_ANSIBLE)
  start_session "ansible" "${HOME}/work/infra/projects-ansible-config/"
  ;;
$PROJECT_ANGULAR_HOUSEHOLD)
  start_session "angular-household" "${HOME}/work/angular-household/"
  ;;
$PROJECT_ANGULAR_DESK_LAN)
  start_session "angular-desk-lan" "${HOME}/work/angular-home-page/"
  ;;
$PROJECT_ANGULAR_DEVFORGE)
  start_session "angular-dev-forge" "${HOME}/work/angular-dev-forge/"
  ;;
$PROJECT_LARAVEL_DEVFORGE)
  start_session "laravel-dev-forge" "${HOME}/work/laravel-dev-forge/"
  ;;
$PROJECT_BOOTSTRAP)
  start_session "bootstrap.sh" "${HOME}/work/bootstrap.sh/"
  ;;
*)
  echo "Error: Unknown project '$SELECTED'."
  exit 1
  ;;
esac
