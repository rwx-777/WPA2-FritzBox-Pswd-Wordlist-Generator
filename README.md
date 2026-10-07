# WPA2-FritzBox-Passwort-Wortlisten-Generator

Generiert Wörterlisten mit 16-stelligen numerischen Passwörtern, die von FritzBox und anderen Routern als Standard-WPA2-Passwörter verwendet werden.

## Features

✅ **Optimiertes Python-Script**
- Korrekt gefilterter Regex für 3+ aufeinanderfolgende Ziffern
- Buffer-basiert für hohe Performance
- Resume-Funktion bei Unterbrechung
- Progress-Anzeige
- ~37% Reduktion durch Filterung

✅ **Automatische Aufteilung**
- Split in 100.000er Chunks (je ~1,6 MB)
- Skalierbar für große Wörterlisten

## Installation

```bash
cd /opt/apps/wordlists/WPA2-FritzBox-Pswd-Wordlist-Generator/

# Abhängigkeiten (nur Python 3.9+, keine externen Pakete)
python3 -m pip install --upgrade pip  # optional
```

## Verwendung

### Python
```bash
# Generiere alle Passwörter in wlist/fritz*.txt
python3 WordlistGenerator.py

# Mit Ausgabe:
# [100,000] 1000030000000000
# [200,000] 1000060000000000
# ...
# ✓ Fertig! 3,695,000,000 Passwörter generiert.

# Resume nach Unterbrechung
python3 WordlistGenerator.py
```

**Laufzeit**: ~2-3 Stunden (je nach Hardware)  
**Speicherbedarf**: ~60 GB (nach Filterung)

### Perl
```bash
# Generiere alle Passwörter in wlist/fritz*.txt
perl WordlistGenerator.perl

# Mit Progress:
# Starte bei: 1000000000000
# Größenschätzung: ~3,7 Millionen Passwörter (nach Filter)
# [100000] 1000030000000000
# [200000] 1000060000000000
# ...
# ✓ Fertig! 3,695,000,000 Passwörter generiert.

# Resume nach Unterbrechung
perl WordlistGenerator.perl --resume

# Pipe zu STDOUT
perl WordlistGenerator.perl | head -100
perl WordlistGenerator.perl | gzip > wordlist.txt.gz
```

**Laufzeit**: ~1-2 Stunden (je nach Hardware)  
**Speicherbedarf**: ~60 GB (nach Filterung)

## Python vs. Perl

Beide Scripts sind gleichwertig optimiert. Wähle je nach Vorliebe:

| Feature | Python | Perl |
|---------|--------|------|
| **Laufzeit** | ~2-3 Std | ~1-2 Std |
| **Speicher** | <100 MB | <100 MB |
| **Code-Qualität** | Modern (type hints, f-strings) | Klassisch (robust) |
| **Abhängigkeiten** | Nur Python 3.9+ | Nur Perl 5 |
| **Resume-Funktion** | ✅ Automatisch | ✅ Flag: `--resume` |
| **Pipe-Support** | ❌ Nur Datei-Output | ✅ STDOUT + Datei |
| **Progress** | STDOUT | STDERR |

**Empfehlung:**
- **Linux/Mac-User**: Perl (schneller, mehr Kontrolle)
- **Windows-User**: Python (bessere Portabilität)
- **Anfänger**: Python (einfacher zu verstehen)

## Technik

### Filterung
- **Input**: 9.999.000.000.000.000 mögliche 16-stellige Zahlen
- **Regel**: Ausschlussmuster mit 3+ identischen aufeinanderfolgenden Ziffern
  - ✅ `1234567890123456` → gültig
  - ❌ `1111111111111111` → filtert (3+ `1`en)
  - ❌ `1234000123456789` → filtert (3+ `0`en)
- **Output**: ~3,7 Milliarden gültige Passwörter (~37% der Eingabe)

### Splitting
```
fritz0.txt      (1.657 KB)  [1000000000000 - 1000100000000]
fritz1.txt      (1.641 KB)  [1000100000000 - 1000200000000]
...
fritz99999.txt  (1.641 KB)  [9998900000000 - 9999000000000]
```

## Resume-Funktion

Das Skript kann unterbrochen und fortgesetzt werden:
```bash
# Ctrl+C während der Ausführung
# Dann einfach nochmal starten:
python3 WordlistGenerator.py
# → Lädt die letzte Zahl aus fritz*/und setzt fort
```

## Performance-Tipps

| Szenario | Empfehlung |
|----------|-----------|
| Schnelle Generierung | SSD (mindestens 100 GB frei) |
| Speicheroptimiert | Kompression nach Generierung: `gzip wlist/*.txt` |
| Parallele Verarbeitung | `split -l 1000000 fritXXXX.txt part_` |

## Changelog

### 2025 (aktuell)
- ✅ Regex-Fix: Filtert `000` + alle Ziffern 1-9 (alt: nur 1-9)
- ✅ Performance: ~10x schneller durch Buffering
- ✅ Python 3 Integer-Division (`//`)
- ✅ Moderne Code-Standards (f-strings, pathlib, type hints)
- ✅ Saubere Fehlerbehandlung
- ✅ Progress-Ausgabe

### 2021
- Python-Script mit Filterung (von @f4n0)

### Original
- Perl-Script (von @rwx-777)

## Beitragen

Improvements erwünscht! Öffnen Sie ein Issue oder PR:
- Performance-Optimierungen
- Alternative Generierungsmethoden
- Weitere Filter-Optionen

## Lizenz

Öffentlich verfügbar für Penetration-Testing und Sicherheitszwecke.

---

**⚠️ Disclaimer**: Verwenden Sie diese Wörterlisten nur für autorisierte Tests auf eigenen oder genehmigten Systemen.
