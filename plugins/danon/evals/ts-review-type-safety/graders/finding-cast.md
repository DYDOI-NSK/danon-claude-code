---
type: regex
pattern: '^\W*\[HIGH\][^\n]*src/types/cast\.ts[^\n]*(cast|as unknown|\bas\b)'
flags: im
match: contains
target: last_message
---
HIGH finding expected: as unknown as T cast bypassing checks.
