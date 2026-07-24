#!/bin/bash

LOG="/tmp/gemini-voice.err"
AUDIO_FILE="/tmp/gemini-voice.wav"
PID_FILE="/tmp/gemini-voice.pid"

exec 2>>"$LOG"

# keybinding з repeating=true — скрипт викликається багато разів,
# але ffmpeg запускаємо лише раз
if [ -f "$PID_FILE" ]; then
    exit 0
fi

echo "[$(date '+%H:%M:%S')] start_record.sh: початок запису" >> "$LOG"

dunstify "t2" -a "🎙️ Recording..." -r 91191 -t 1000

nohup ffmpeg -f pulse -i default -ac 1 -ar 16000 "$AUDIO_FILE" -y -loglevel error 2>>"$LOG" >/dev/null &
FFPID=$!
echo $FFPID > "$PID_FILE"

echo "[$(date '+%H:%M:%S')] start_record.sh: ffmpeg запущено, PID=$FFPID" >> "$LOG"