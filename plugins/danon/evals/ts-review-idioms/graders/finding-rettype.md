---
type: regex
pattern: '^\W*\[HIGH\][^\n]*src/idioms/rettype\.ts[^\n]*(return type|implicit|explicit)'
flags: im
match: contains
target: last_message
---
HIGH finding expected: public function without explicit return type.
