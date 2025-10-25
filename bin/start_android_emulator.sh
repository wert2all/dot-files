#!/bin/bash

# Script to start Android emulator
# Assumes Android SDK is installed and AVD name is set or passed as argument
# Usage: ./start_android_emulator.sh [avd_name]

AVD_NAME="Pixel_6a" # Default to 'Pixel' or set your AVD name

# Check if emulator command is available
if ! command -v emulator &>/dev/null; then
    echo "Error: Android emulator not found. Ensure Android SDK is installed and in PATH."
    exit 1
fi

# Start the emulator
echo "Starting Android emulator: $AVD_NAME"
emulator -avd "$AVD_NAME" -no-audio -no-snapshot -no-boot-anim -gpu off &

# Optional: Wait a bit and check if it's running
sleep 5
if pgrep -f "emulator.*$AVD_NAME" >/dev/null; then
    echo "Emulator started successfully."
else
    echo "Failed to start emulator."
fi
