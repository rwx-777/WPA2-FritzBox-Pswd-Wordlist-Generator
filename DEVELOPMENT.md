# Entwicklung

## Architektur

### WordlistGenerator.py

**Hauptkomponenten:**

```python
START = 1000000000000           # Erste Zahl (12 Stellen + 4 Nullen)
END = 9999000000000000          # Letzte Zahl
CHUNK_SIZE = 100000             # Passwörter pro Datei
INVALID_PATTERN = r"(\d)\1{2,}" # Regex: 3+ identische Ziffern
```

**Flow:**
1. `get_last_line()` → Resume: Findet die letzte generierten Zahl
2. `generate_passwords()` → Generator-Funktion (memory-efficient)
3. `main()` → Schreibt mit Buffer in Dateien

### Performance-Charakteristiken

| Betrieb | Zeit | RAM |
|---------|------|-----|
| Generierung (volle ~3,7B) | ~2-3 Std | <100 MB |
| Schreiben auf SSD | Dominant | Puffering |
| Regex-Evaluierung | ~30% CPU-Zeit | - |

### Optimierungspotenziale

1. **Regex compilieren** ✅ (bereits done)
2. **Generator statt Liste** ✅ (bereits done)
3. **Buffering** ✅ (bereits done)
4. **Parallelisierung** (noch möglich)
   ```python
   # Zukünftig: multiprocessing.Pool
   # Chunk Ranges aufteilen → 4 Worker → merge
   ```
5. **NumPy/Numba** (für Regex-Loop)

## Testing

### Unit Tests (zu implementieren)

```bash
# Test-Framework
python3 -m pytest tests/

# Besondere Tests:
# - Regex-Filter korrekt? (0-9 alle Ziffern)
# - Resume-Logik? (letzte Zeile lesen)
# - Datei-Splits korrekt? (fritz0.txt, fritz1.txt, ...)
# - Keine Duplikate?
```

### Integrationstests

```bash
# Kleine Generierung testen (1 Million Zahlen)
python3 -c "
import WordlistGenerator
# Überschreib START/END für schnellen Test
# Verifiziere Output
"
```

## Debugging

### Performance-Profiling

```bash
# Zeitliche Analyse
time python3 WordlistGenerator.py 2>&1 | tail -20

# Mit Profiler
python3 -m cProfile -s cumtime WordlistGenerator.py | head -30
```

### Regex-Test

```python
import re
pattern = re.compile(r"(\d)\1{2,}")

test_cases = [
    ("0001000000000000", False),  # 3+ Nullen → invalid
    ("0000000000000000", False),  # Alle Nullen → invalid
    ("1234567890123456", True),   # Keine Wiederholungen → valid
    ("1111111111111111", False),  # 3+ Einsen → invalid
    ("0101010101010101", True),   # Max. 2x Wiederholung → valid
]

for num, should_be_valid in test_cases:
    is_valid = pattern.search(num) is None
    status = "✓" if is_valid == should_be_valid else "✗"
    print(f"{status} {num} → valid={is_valid}")
```

## Zukünftige Features

- [ ] Kompression (gzip, xz)
- [ ] Parallelisierung (4 Worker)
- [ ] Alternative Filter (z.B. Länge, Muster)
- [ ] Datenbank-Export (SQLite)
- [ ] Streaming-Support (read ein Stück, nicht ganz)
- [ ] Vergleich mit anderen Generatoren

## Bekannte Einschränkungen

1. **Speicher**: 60 GB benötigt für finale Dateien
2. **Zeit**: 2-3 Stunden Laufzeit
3. **I/O**: Bottleneck ist Festplatte, nicht CPU
4. **Regex**: `(\d)\1{2,}` ist sequenziell (nicht parallel)

## Code-Stil

Siehe `/opt/apps/CLAUDE.md`:
- Python 3.9+
- `ruff check --fix`
- Type hints
- f-strings
- Docstrings (max 1-2 Zeilen für public APIs)

## Beitrag

1. Fork/Branch
2. Teste lokal
3. Commit mit Nachricht:
   ```
   git commit -m "feat: parallelize password generation
   
   Adds multiprocessing.Pool for 4-worker parallelization.
   Speedup: ~3.5x on 8-core CPU.
   
   Co-Authored-By: Claude Haiku 4.5 <noreply@anthropic.com>"
   ```
4. PR gegen `main`
