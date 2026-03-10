#!/bin/bash

PID_FILE="/tmp/gemini-voice.pid"

if [ -f "$PID_FILE" ]; then
    echo '{"text": "󰏤", "tooltip": "Recording..."}'
else
    echo '{"text": ""}'
fi
