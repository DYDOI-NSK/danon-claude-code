---
type: regex
pattern: '^\W*\[HIGH\][^\n]*src/types/nonnull\.ts[^\n]*(non-null|assertion|\bnull\b|undefined|!)'
flags: im
match: contains
target: last_message
---
HIGH finding expected: non-null assertion without guard.
