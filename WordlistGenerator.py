#!/usr/bin/env python3
"""
WPA2-FritzBox Passwort-Wortlisten-Generator
Generiert 16-stellige numerische Passwörter ohne 3+ aufeinanderfolgende Ziffern.
"""

import re
from pathlib import Path
from typing import Generator

CHUNK_SIZE = 100000
START = 1000000000000
END = 9999000000000000
OUTPUT_DIR = Path("wlist")

# Regex: Filtert Passwörter mit 3+ aufeinanderfolgenden identischen Ziffern (0-9)
INVALID_PATTERN = re.compile(r"(\d)\1{2,}")


def get_last_line() -> int:
    """Resume: Findet die letzte Zahl in den bestehenden Dateien."""
    if not OUTPUT_DIR.exists():
        return START

    files = sorted(OUTPUT_DIR.glob("fritz*.txt"))
    if not files:
        return START

    try:
        last_file = files[-1]
        with open(last_file, "r") as f:
            lines = f.readlines()
            for line in reversed(lines):
                line = line.strip()
                if line.isdigit():
                    return int(line)
    except (OSError, ValueError, IndexError):
        pass

    return START


def generate_passwords() -> Generator[str, None, None]:
    """Generiert 16-stellige Passwörter ohne 3+ aufeinanderfolgende Ziffern."""
    start = get_last_line()
    for i in range(start, END):
        num = f"{i:016d}"
        if not INVALID_PATTERN.search(num):
            yield num


def main() -> None:
    OUTPUT_DIR.mkdir(exist_ok=True)

    filename = ""
    f = None
    buffer = []
    count = 0

    try:
        for password in generate_passwords():
            chunk_id = int(password) // CHUNK_SIZE
            new_filename = f"wlist/fritz{chunk_id}.txt"

            # Neue Datei?
            if new_filename != filename:
                if f:
                    f.write("\n".join(buffer) + "\n")
                    f.close()
                filename = new_filename
                f = open(filename, "a")
                buffer = []

            buffer.append(password)
            count += 1

            # Buffer flushen (alle 10k Zeilen)
            if len(buffer) >= 10000:
                f.write("\n".join(buffer) + "\n")
                buffer = []

            # Progress (alle 100k)
            if count % 100000 == 0:
                print(f"[{count:,}] {password}", flush=True)

        # Finale Zeilen schreiben
        if f and buffer:
            f.write("\n".join(buffer) + "\n")

        print(f"\n✓ Fertig! {count:,} Passwörter generiert.", flush=True)

    finally:
        if f:
            f.close()


if __name__ == "__main__":
    main()

