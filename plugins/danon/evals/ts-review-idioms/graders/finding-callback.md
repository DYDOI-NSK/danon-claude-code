---
type: regex
pattern: '^\W*\[HIGH\][^\n]*src/idioms/callback\.ts[^\n]*(callback|promise|async|mix|standardi)'
flags: im
match: contains
target: last_message
---
HIGH finding expected: callback mixed with async/await.
