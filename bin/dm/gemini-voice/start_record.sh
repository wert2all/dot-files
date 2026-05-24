#!/bin/bash

AUDIO_FILE="/tmp/gemini-voice.wav"
PID_FILE="/tmp/gemini-voice.pid"

if [ -f "$PID_FILE" ]; then
    exit 0
fi

dunstify "t2" -a "🎙️ Recording..." -r 91191 -t 1000

ffmpeg -f pulse -i default -ac 1 -ar 16000 "$AUDIO_FILE" -y > /dev/null 2>&1 &
echo $! > "$PID_FILE"
