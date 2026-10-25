---
type: regex
pattern: '^\W*\[HIGH\][^\n]*src/async/unhandled\.ts[^\n]*(unhandled|reject|await|catch|promise|floating)'
flags: im
match: contains
target: last_message
---
HIGH finding expected: async function called without await/catch.
