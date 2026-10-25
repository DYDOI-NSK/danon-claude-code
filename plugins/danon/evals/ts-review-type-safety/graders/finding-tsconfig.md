---
type: regex
pattern: '^\W*\[HIGH\][^\n]*tsconfig\.json[^\n]*(strict|noImplicitAny|compiler|tsconfig)'
flags: im
match: contains
target: last_message
---
HIGH finding expected: tsconfig weakened: strict turned off.
