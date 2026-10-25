---
type: regex
pattern: '^\W*\[HIGH\][^\n]*src/idioms/eq\.ts[^\n]*(==|strict equality|loose)'
flags: im
match: contains
target: last_message
---
HIGH finding expected: == instead of ===.
