#!/bin/sh

# Default launcher
LAUNCHER="tofi"

# Check for command-line arguments
if [ "$1" = "--rofi" ]; then
    LAUNCHER="rofi -dmenu"
elif [ "$1" = "--tofi" ]; then
    LAUNCHER="tofi"
elif [ -n "$1" ]; then
    echo "Error: Unknown option '$1'. Use '--tofi' or '--rofi'." >&2
    exit 1
fi

# Check if the determined launcher is actually installed
if ! command -v "$(echo "$LAUNCHER" | cut -d' ' -f1)" >/dev/null 2>&1; then
    echo "Error: The selected launcher ('$LAUNCHER') is not installed." >&2
    exit 1
fi

session=$(tmux list-sessions -F '#{session_name}' | $LAUNCHER)

if [ -n "$session" ]; then
    kitty tmux attach-session -t "$session"
fi
