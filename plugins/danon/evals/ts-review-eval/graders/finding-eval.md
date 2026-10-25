---
type: regex
pattern: '^\[CRITICAL\][^\n]*security/dynamic\.js[^\n]*\beval\b'
flags: im
match: contains
target: last_message
---
C-01: eval() finding reported as CRITICAL.
