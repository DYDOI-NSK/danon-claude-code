---
type: regex
pattern: '^\[(CRITICAL|HIGH|MEDIUM)\][^\n]*clean/pricing\.js'
flags: m
match: not_contains
target: last_message
---
Control file must produce no findings.
