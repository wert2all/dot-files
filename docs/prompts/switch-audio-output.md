# Switch Audio Output Device

This script provides an interactive way to switch the default audio output device. It lists all available sound outputs, allows the user to select one, and then sets the chosen device as the default for all current and future audio streams.

## How it works:

1.  **List Devices**: It uses `pactl list sinks` to get a list of all available audio output devices (sinks).
2.  **Interactive Selection**: It pipes this list into `fzf` to create a fuzzy-searchable, interactive menu.
3.  **Set Default**: Once a device is selected, `pactl set-default-sink` sets it as the system's default output.
4.  **Move Active Streams**: The script also iterates through all currently active audio streams (`sink-inputs`) and moves them to the newly selected output device using `pactl move-sink-input`.

## Dependencies:

*   `pulseaudio-utils`: Provides the `pactl` command.
*   `fzf`: For the interactive selection menu.

## Usage:

Run the script from your terminal:
```bash
./bin/switch-audio-output.sh
```
A menu will appear, allowing you to select the desired audio output.
