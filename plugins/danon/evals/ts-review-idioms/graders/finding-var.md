---
type: regex
pattern: '^\W*\[HIGH\][^\n]*src/idioms/var\.ts[^\n]*(\bvar\b)'
flags: im
match: contains
target: last_message
---
HIGH finding expected: var instead of const/let.
