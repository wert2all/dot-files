#!/usr/bin/env sh

wallPath="${XDG_CONFIG_HOME:-$HOME/.config}/swww"

swww query
if [ $? -eq 1 ]; then
  swww-daemon
fi

#Get a list of all image files in the wallpapers directory
wallpapers=("$wallPath"/*)

# Check if the wallpapers array is empty
if [ ${#wallpapers[@]} -eq 0 ]; then
    # If the array is empty, refill it with the image files
    wallpapers=("$wallPath"/*)
fi

# Select a random wallpaper from the array
wallpaperIndex=$(( RANDOM % ${#wallpapers[@]} ))
selectedWallpaper="${wallpapers[$wallpaperIndex]}"

# Update the wallpaper using the swww img command
swww img "$selectedWallpaper" --transition-type "wipe" --transition-duration 2

