#!/bin/bash

# Get the list of sinks and format them for fzf
# We extract the sink number and its description
sinks=$(pactl list sinks | grep -E 'Sink #|Description:' | sed 's/^[[:space:]]*//' | paste - - | sed 's/Sink #//' | sed 's/Description: / /')

# Let the user choose a sink using fzf, but only show the description
chosen_sink_desc=$(echo "$sinks" | cut -d' ' -f2- | fzf --prompt="Select an audio output device: " --height=20% --border)

# If the user made a choice (i.e., didn't cancel fzf)
if [ -n "$chosen_sink_desc" ]; then
    # Find the original line corresponding to the chosen description
    chosen_sink=$(echo "$sinks" | grep "$chosen_sink_desc")
    # Extract the sink number from the chosen line
    sink_id=$(echo "$chosen_sink" | awk '{print $1}')

    # Set the chosen sink as the default
    pactl set-default-sink "$sink_id"
    echo "Default audio output set to: $chosen_sink_desc"

    # Move all existing audio streams to the new sink
    pactl list short sink-inputs | awk '{print $1}' | while read -r input_id; do
        pactl move-sink-input "$input_id" "$sink_id"
    done
    echo "All active audio streams moved to the new output."
else
    echo "No device selected. Audio output remains unchanged."
fi
