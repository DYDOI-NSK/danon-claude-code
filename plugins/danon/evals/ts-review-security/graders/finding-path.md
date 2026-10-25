---
type: regex
pattern: '^\W*\[CRITICAL\][^\n]*src/security/path\.ts[^\n]*(path|travers)'
flags: im
match: contains
target: last_message
---
CRITICAL finding expected: path traversal in fs.readFile.
