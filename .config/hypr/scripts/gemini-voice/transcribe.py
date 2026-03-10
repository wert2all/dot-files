#!/usr/bin/env python3

import sys
import os

AUDIO_FILE = "/tmp/gemini-voice.wav"
OUTPUT_FILE = "/tmp/gemini-voice.txt"


def transcribe():
    try:
        from faster_whisper import WhisperModel
    except ImportError:
        print("ERROR: faster-whisper not installed", file=sys.stderr)
        sys.exit(1)

    if not os.path.exists(AUDIO_FILE) or os.path.getsize(AUDIO_FILE) == 0:
        print("ERROR: Audio file is empty or does not exist", file=sys.stderr)
        sys.exit(1)

    model = WhisperModel("base", device="auto", compute_type="int8")
    segments, info = model.transcribe(AUDIO_FILE, language="uk")

    text = " ".join([segment.text for segment in segments]).strip()

    with open(OUTPUT_FILE, "w") as f:
        f.write(text)

    print(text)


if __name__ == "__main__":
    transcribe()
