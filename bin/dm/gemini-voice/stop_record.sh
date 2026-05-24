#!/bin/bash

AUDIO_FILE="/tmp/gemini-voice.wav"
PID_FILE="/tmp/gemini-voice.pid"
TRANSCRIBED_FILE="/tmp/gemini-voice.txt"

if [ ! -f "$PID_FILE" ]; then
    exit 0
fi

kill $(cat "$PID_FILE") 2>/dev/null
rm -f "$PID_FILE"

sleep 0.3

if [ ! -f "$AUDIO_FILE" ] || [ ! -s "$AUDIO_FILE" ]; then
    dunstify "t2" -a "Recording cancelled" -r 91191 -t 1000
    exit 0
fi

dunstify "t2" -a "⏳ Transcribing..." -r 91191 -t 2000

python3 ~/.config/hypr/scripts/gemini-voice/transcribe.py

if [ ! -s "$TRANSCRIBED_FILE" ]; then
    dunstify "t2" -a "❌ Transcription failed" -r 91191 -t 2000
    rm -f "$AUDIO_FILE" "$TRANSCRIBED_FILE"
    exit 1
fi

if [ -f "$TRANSCRIBED_FILE" ]; then
    TEXT=$(cat "$TRANSCRIBED_FILE")
    if [ -n "$TEXT" ]; then
        echo -n "$TEXT" | wl-copy 2>/dev/null

        dunstify "t2" -a "Text ready - click input & Ctrl+V" -r 91191 -t 3000

        # xdg-open "https://gemini.google.com/app"
    fi
fi

rm -f "$AUDIO_FILE" "$TRANSCRIBED_FILE"
