---
type: regex
pattern: '^\W*\[(CRITICAL|HIGH|MEDIUM)\][^\n]*clean/format\.ts'
flags: im
match: not_contains
target: last_message
---
Control file must produce no findings.
