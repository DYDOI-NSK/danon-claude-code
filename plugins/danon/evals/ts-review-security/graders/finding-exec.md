---
type: regex
pattern: '^\W*\[CRITICAL\][^\n]*src/security/exec\.ts[^\n]*(exec|child_process|command|inject|shell)'
flags: im
match: contains
target: last_message
---
CRITICAL finding expected: child_process.exec with user input.
