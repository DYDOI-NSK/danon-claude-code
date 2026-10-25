---
type: regex
pattern: '^\W*\[HIGH\][^\n]*src/errors/parse\.ts[^\n]*(JSON\.parse|try|catch|invalid)'
flags: im
match: contains
target: last_message
---
HIGH finding expected: JSON.parse without try/catch.
