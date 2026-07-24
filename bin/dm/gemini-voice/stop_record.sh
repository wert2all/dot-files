#!/bin/bash

LOG="/tmp/gemini-voice.err"
AUDIO_FILE="/tmp/gemini-voice.wav"
PID_FILE="/tmp/gemini-voice.pid"
TRANSCRIBED_FILE="/tmp/gemini-voice.txt"

exec 2>>"$LOG"

echo "" >> "$LOG"
echo "[$(date '+%H:%M:%S')] ===== stop_record.sh: початок =====" >> "$LOG"

if [ ! -f "$PID_FILE" ]; then
    echo "[$(date '+%H:%M:%S')] stop_record.sh: немає PID-файлу, вихід" >> "$LOG"
    exit 0
fi

FFPID=$(cat "$PID_FILE")
echo "[$(date '+%H:%M:%S')] stop_record.sh: вбиваю ffmpeg PID=$FFPID" >> "$LOG"

kill "$FFPID" 2>&1
rm -f "$PID_FILE"

sleep 0.3

if [ ! -f "$AUDIO_FILE" ]; then
    echo "[$(date '+%H:%M:%S')] stop_record.sh: аудіофайл не знайдено" >> "$LOG"
    dunstify "t2" -a "Recording cancelled" -r 91191 -t 1000
    exit 0
fi

FILE_SIZE=$(stat -c%s "$AUDIO_FILE" 2>&1)
echo "[$(date '+%H:%M:%S')] stop_record.sh: аудіофайл ${AUDIO_FILE}, розмір=$FILE_SIZE байт" >> "$LOG"

if [ "$FILE_SIZE" -le 44 ]; then
    echo "[$(date '+%H:%M:%S')] stop_record.sh: аудіофайл занадто малий (порожній WAV)" >> "$LOG"
    dunstify "t2" -a "Recording cancelled" -r 91191 -t 1000
    rm -f "$AUDIO_FILE"
    exit 0
fi

dunstify "t2" -a "⏳ Transcribing..." -r 91191 -t 2000

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "[$(date '+%H:%M:%S')] stop_record.sh: запускаю transcribe.py (dir=$SCRIPT_DIR)" >> "$LOG"

python3 "$SCRIPT_DIR/transcribe.py" 2>>"$LOG"
PY_EXIT=$?
echo "[$(date '+%H:%M:%S')] stop_record.sh: transcribe.py завершився з кодом $PY_EXIT" >> "$LOG"

if [ ! -s "$TRANSCRIBED_FILE" ]; then
    echo "[$(date '+%H:%M:%S')] stop_record.sh: файл транскрипції порожній або відсутній" >> "$LOG"
    dunstify "t2" -a "❌ Transcription failed" -r 91191 -t 2000
    rm -f "$AUDIO_FILE" "$TRANSCRIBED_FILE"
    exit 1
fi

TEXT=$(cat "$TRANSCRIBED_FILE")
if [ -n "$TEXT" ]; then
    echo "[$(date '+%H:%M:%S')] stop_record.sh: транскрипція успішна (${#TEXT} символів)" >> "$LOG"
    echo -n "$TEXT" | wl-copy 2>&1
    dunstify "t2" -a "Text ready - click input & Ctrl+V" -r 91191 -t 3000
else
    echo "[$(date '+%H:%M:%S')] stop_record.sh: транскрипція порожня" >> "$LOG"
fi

rm -f "$AUDIO_FILE" "$TRANSCRIBED_FILE"
echo "[$(date '+%H:%M:%S')] stop_record.sh: готово" >> "$LOG"