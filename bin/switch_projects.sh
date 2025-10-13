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

PROJECTS=" ${NVIM_ENTRY}\n${DOT_ENTRY}\n${OBSIDIAN_ENTRY}\n"

SELECTED=$(echo -en $PROJECTS | ${LAUNCHER})

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
esac
