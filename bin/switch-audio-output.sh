#!/bin/bash

# Switch Audio Output Device Script
# Provides an interactive way to switch the default audio output device
# Dependencies: pulseaudio-utils, fzf

set -euo pipefail

# Get list of audio sinks with friendly names
get_audio_sinks() {
    pactl list sinks | grep -E "(Sink #|Description:|Name:)" | \
    awk '
        /Sink #/ { sink_id = $2; gsub(/#/, "", sink_id) }
        /Name:/ { name = $2 }
        /Description:/ { 
            desc = $0; 
            gsub(/^[[:space:]]*Description:[[:space:]]*/, "", desc);
            print sink_id ":" name ":" desc
        }
    '
}

# Move all active audio streams to the selected sink
move_active_streams() {
    local target_sink="$1"
    
    # Get all active sink inputs and move them to the new default sink
    pactl list sink-inputs short | while read -r input_id _; do
        if [ -n "$input_id" ]; then
            pactl move-sink-input "$input_id" "$target_sink" 2>/dev/null || true
        fi
    done
}

# Main function
main() {
    echo "🔊 Audio Output Device Switcher"
    echo "================================"
    
    # Get current default sink
    current_sink=$(pactl get-default-sink 2>/dev/null || echo "unknown")
    echo "Current default: $current_sink"
    echo ""
    
    # Get available sinks
    sinks=$(get_audio_sinks)
    
    if [ -z "$sinks" ]; then
        echo "No audio output devices found!"
        exit 1
    fi
    
    # Create user-friendly list for fzf
    sink_list=""
    while IFS=':' read -r sink_id sink_name description; do
        # Mark current default with an indicator
        indicator=""
        if [ "$sink_name" = "$current_sink" ]; then
            indicator=" [CURRENT]"
        fi
        sink_list+="$sink_id:$sink_name:$description$indicator"$'\n'
    done <<< "$sinks"
    
    # Use fzf to select audio device
    echo "Select audio output device:"
    selected=$(echo "$sink_list" | fzf \
        --prompt="🎵 Select audio device: " \
        --header="Use arrow keys to navigate, Enter to select, Esc to cancel" \
        --height=40% \
        --reverse \
        --border \
        --preview-window=hidden \
        --delimiter=':' \
        --with-nth=3.. \
        --no-multi
    ) || {
        echo "Selection cancelled."
        exit 0
    }
    
    # Extract sink name from selection
    selected_sink=$(echo "$selected" | cut -d':' -f2)
    selected_desc=$(echo "$selected" | cut -d':' -f3 | sed 's/ \[CURRENT\]$//')
    
    if [ -z "$selected_sink" ]; then
        echo "Invalid selection!"
        exit 1
    fi
    
    # Set as default sink
    echo ""
    echo "Setting default audio output to: $selected_desc"
    pactl set-default-sink "$selected_sink"
    
    # Move all active streams to the new sink
    echo "Moving active audio streams..."
    move_active_streams "$selected_sink"
    
    echo "✅ Audio output switched successfully!"
    
    # Show confirmation
    new_default=$(pactl get-default-sink)
    if [ "$new_default" = "$selected_sink" ]; then
        echo "New default: $selected_desc"
    else
        echo "⚠️  Warning: Default sink may not have been set correctly"
    fi
}

# Run main function
main "$@"
