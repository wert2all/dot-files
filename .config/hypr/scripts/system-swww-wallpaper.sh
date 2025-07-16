#!/usr/bin/env bash

# Set the path to the wallpapers directory.
# Uses XDG_CONFIG_HOME if set, otherwise defaults to ~/.config.
wallPath="${XDG_CONFIG_HOME:-$HOME/.config}/swww/"

# Check if the wallpaper directory exists.
if [ ! -d "$wallPath" ]; then
  echo "Error: Wallpaper directory not found at $wallPath" >&2
  exit 1
fi

# Start the swww daemon if it's not already running.
if ! swww query >/dev/null 2>&1; then
  swww-daemon
fi

# Create an array of all image files in the directory.
# This handles filenames with spaces and filters for common image types.
mapfile -d '' wallpapers < <(find "$wallPath" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" -o -iname "*.bmp" \) -print0)

# Exit if no wallpapers are found.
if [ ${#wallpapers[@]} -eq 0 ]; then
  echo "Error: No image files found in $wallPath" >&2
  exit 1
fi

# Select a random wallpaper from the array.
selectedWallpaper="${wallpapers[RANDOM % ${#wallpapers[@]}]}"

# Set the new wallpaper with a transition effect.
swww img "$selectedWallpaper" --transition-type "wipe" --transition-duration 2
