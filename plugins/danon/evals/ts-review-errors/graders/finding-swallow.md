---
type: regex
pattern: '^\W*\[HIGH\][^\n]*src/errors/swallow\.ts[^\n]*(empty|swallow|catch|ignor)'
flags: im
match: contains
target: last_message
---
HIGH finding expected: empty catch block.
