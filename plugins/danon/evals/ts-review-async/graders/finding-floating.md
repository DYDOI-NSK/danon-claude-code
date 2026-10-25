---
type: regex
pattern: '^\W*\[HIGH\][^\n]*src/async/floating\.ts[^\n]*(floating|constructor|unhandled|promise|catch|fire)'
flags: im
match: contains
target: last_message
---
HIGH finding expected: floating promise in constructor.
