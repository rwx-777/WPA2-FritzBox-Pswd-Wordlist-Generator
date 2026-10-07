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

### Python (EMPFOHLEN)
```bash
# Generiere alle Passwörter in wlist/fritz*.txt
python3 WordlistGenerator.py

# Mit Ausgabe:
# [100,000] 1000030000000000
# [200,000] 1000060000000000
# ...
# ✓ Fertig! 3,695,000,000 Passwörter generiert.
```

**Laufzeit**: ~2-3 Stunden (je nach Hardware)  
**Speicherbedarf**: ~60 GB (nach Filterung)

### Perl (veraltet)
```bash
# ⚠️ Nur zu Referenzzwecken – Python-Version ist 10x schneller
perl WordlistGenerator.perl > output.txt
```

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
