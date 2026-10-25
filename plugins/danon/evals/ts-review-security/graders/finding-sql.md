---
type: regex
pattern: '^\W*\[CRITICAL\][^\n]*src/security/sql\.ts[^\n]*(sql|inject|parameteri)'
flags: im
match: contains
target: last_message
---
CRITICAL finding expected: SQL injection by concatenation.
