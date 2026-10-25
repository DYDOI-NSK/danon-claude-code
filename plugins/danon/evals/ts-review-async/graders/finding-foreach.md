---
type: regex
pattern: '^\W*\[HIGH\][^\n]*src/async/foreach\.ts[^\n]*(forEach|for\.\.\.of|Promise\.all|await)'
flags: im
match: contains
target: last_message
---
HIGH finding expected: async callback in forEach.
