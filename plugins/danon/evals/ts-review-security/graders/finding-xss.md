---
type: regex
pattern: '^\W*\[CRITICAL\][^\n]*src/security/xss\.ts[^\n]*(innerHTML|xss|sanitis|sanitiz)'
flags: im
match: contains
target: last_message
---
CRITICAL finding expected: XSS via innerHTML.
