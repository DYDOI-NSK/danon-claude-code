---
type: regex
pattern: '^\W*\[HIGH\][^\n]*src/types/any\.ts[^\n]*(\bany\b)'
flags: im
match: contains
target: last_message
---
HIGH finding expected: any without justification.
