#!/usr/bin/env bash

LAUNCHER="rofi"
TERMINAL="kitty"

NVIM_ENTRY=" nvim"
DOT_ENTRY="󰇘 dot-files"
OBSIDIAN_ENTRY="󰠮 obsidian"

PROJECTS=" ${NVIM_ENTRY}\n${DOT_ENTRY}\n${OBSIDIAN_ENTRY}\n"

SELECTED=$(echo -en $PROJECTS | ${LAUNCHER} -dmenu)

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
