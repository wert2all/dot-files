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

# Fallback to rofi if tofi is the default and not installed
if [ "$LAUNCHER" = "tofi" ] && ! command -v tofi >/dev/null 2>&1; then
    echo "Warning: 'tofi' not found. Falling back to 'rofi'." >&2
    if command -v rofi >/dev/null 2>&1; then
        LAUNCHER="rofi -dmenu"
    else
        echo "Error: Neither 'tofi' nor 'rofi' could be found." >&2
        exit 1
    fi
fi

# Fallback to tofi if rofi is the default and not installed
if [ "$LAUNCHER" = "rofi -dmenu" ] && ! command -v rofi >/dev/null 2>&1; then
    echo "Warning: 'rofi' not found. Falling back to 'tofi'." >&2
    if command -v tofi >/dev/null 2>&1; then
        LAUNCHER="tofi"
    else
        echo "Error: Neither 'rofi' nor 'tofi' could be found." >&2
        exit 1
    fi
fi

# Check if the determined launcher is actually installed
if ! command -v "$(echo "$LAUNCHER" | cut -d' ' -f1)" >/dev/null 2>&1; then
    echo "Error: The selected launcher ('$LAUNCHER') is not installed." >&2
    exit 1
fi

session=$(tmux list-sessions -F '#{session_name}' | $LAUNCHER)

if [ -n "$session" ]; then
    tmux attach-session -t "$session"
fi
