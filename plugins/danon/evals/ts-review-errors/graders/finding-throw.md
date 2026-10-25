---
type: regex
pattern: '^\W*\[HIGH\][^\n]*src/errors/throw\.ts[^\n]*(throw|Error|string|non-Error)'
flags: im
match: contains
target: last_message
---
HIGH finding expected: throwing a string instead of Error.
