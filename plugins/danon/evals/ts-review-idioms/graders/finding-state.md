---
type: regex
pattern: '^\W*\[HIGH\][^\n]*src/idioms/state\.ts[^\n]*(mutable|shared state|module-level|global|counter)'
flags: im
match: contains
target: last_message
---
HIGH finding expected: module-level mutable shared state.
