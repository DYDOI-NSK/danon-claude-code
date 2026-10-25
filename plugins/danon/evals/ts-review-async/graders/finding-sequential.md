---
type: regex
pattern: '^\W*\[HIGH\][^\n]*src/async/sequential\.ts[^\n]*(sequential|parallel|Promise\.all|loop|independent)'
flags: im
match: contains
target: last_message
---
HIGH finding expected: sequential awaits for independent work.
