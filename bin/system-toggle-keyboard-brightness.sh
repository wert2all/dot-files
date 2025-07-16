#!/usr/bin/env bash

# Function to find the keyboard backlight device
find_backlight_device() {
  local devices
  devices=$(brightnessctl --list | awk '{print $2}')

  for device in $devices; do
    if [[ "$device" =~ "kbd_backlight" ]]; then
      echo "${device//\'/}" # Strip quotes"
      return 0
    fi
  done

  echo "Keyboard backlight device not found." >&2
  return 1
}

# Find the device
device=$(find_backlight_device)
# Check if device was found
if [[ $? -eq 0 ]]; then
  # Get current brightness
  brightness=$(brightnessctl --device "${device}" get)
  # Toggle brightness (0 to 1 or vice versa)
  brightness=$((1 - $brightness))

  # Set new brightness
  brightnessctl --device "${device//\//}" set "$brightness"
else
  echo "Could not toggle keyboard backlight." >&2
fi
