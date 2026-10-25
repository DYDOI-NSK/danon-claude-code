---
type: regex
pattern: '^\W*\[CRITICAL\][^\n]*src/security/merge\.ts[^\n]*(prototype|pollut|__proto__)'
flags: im
match: contains
target: last_message
---
CRITICAL finding expected: prototype pollution in recursive merge.
