---
type: regex
pattern: '^\[CRITICAL\][^\n]*security/system\.js[^\n]*(secret|hardcod|api[_ -]?key)'
flags: im
match: contains
target: last_message
---
C-07: hardcoded secret reported as CRITICAL.
