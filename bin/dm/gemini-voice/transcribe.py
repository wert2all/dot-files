#!/usr/bin/env python3

import sys
import os
import subprocess
import time
import struct

AUDIO_FILE = "/tmp/gemini-voice.wav"
OUTPUT_FILE = "/tmp/gemini-voice.txt"
LOG_FILE = "/tmp/gemini-voice.err"


def log(msg):
    ts = time.strftime("%H:%M:%S")
    with open(LOG_FILE, "a") as f:
        f.write(f"[{ts}] transcribe.py: {msg}\n")
    print(msg, file=sys.stderr)


def notify(msg):
    subprocess.run(["notify-send", "-u", "critical", "Transcribe", msg])


def is_valid_wav(path):
    """Quick check if the WAV header looks sane"""
    try:
        with open(path, "rb") as f:
            hdr = f.read(44)
        if len(hdr) < 44:
            return False, "header too short"
        riff, size, wave = struct.unpack("<4sI4s", hdr[:12])
        if riff != b"RIFF" or wave != b"WAVE":
            return False, f"not a WAV (RIFF={riff}, WAVE={wave})"
        fmt = struct.unpack("<4sI", hdr[12:20])
        if fmt[0] != b"fmt ":
            return False, "no fmt chunk"
        channels = struct.unpack("<H", hdr[22:24])[0]
        sample_rate = struct.unpack("<I", hdr[24:28])[0]
        log(f"WAV: {channels}ch, {sample_rate}Hz, size={size}b")
        return True, f"{channels}ch/{sample_rate}Hz"
    except Exception as e:
        return False, str(e)


def transcribe():
    log("початок транскрипції")

    # перевірка залежностей
    try:
        from faster_whisper import WhisperModel
        log("faster-whisper імпортовано успішно")
    except ImportError as e:
        log(f"faster-whisper не встановлено: {e}")
        notify("faster-whisper не встановлено")
        sys.exit(1)

    # перевірка аудіофайлу
    if not os.path.exists(AUDIO_FILE):
        log(f"аудіофайл не існує: {AUDIO_FILE}")
        notify("Audio file does not exist")
        sys.exit(1)

    fsize = os.path.getsize(AUDIO_FILE)
    log(f"розмір файлу: {fsize} байт")

    if fsize == 0:
        log("аудіофайл порожній")
        notify("Audio file is empty")
        sys.exit(1)

    valid, msg = is_valid_wav(AUDIO_FILE)
    if not valid:
        log(f"WAV невалідний: {msg}")
        notify(f"Invalid WAV: {msg}")
        sys.exit(1)

    log(f"WAV валідний: {msg}")

    # транскрипція
    log("завантажую модель WhisperModel('base')...")
    try:
        model = WhisperModel("base", device="auto", compute_type="int8")
        log("модель завантажено, починаю транскрипцію (uk)...")
        segments, info = model.transcribe(AUDIO_FILE, language="en")
        log(f"детектовано мову: {info.language}, ймовірність: {info.language_probability:.2f}")
    except Exception as e:
        log(f"помилка під час транскрипції: {e}")
        notify(f"Transcription error: {e}")
        sys.exit(1)

    text = " ".join([segment.text for segment in segments]).strip()
    log(f"розпізнано тексту: {len(text)} символів")

    if not text:
        log("текст порожній")
        notify("No speech detected")
        sys.exit(1)

    with open(OUTPUT_FILE, "w") as f:
        f.write(text)

    log(f"транскрипцію збережено в {OUTPUT_FILE}")
    print(text)


if __name__ == "__main__":
    transcribe()
