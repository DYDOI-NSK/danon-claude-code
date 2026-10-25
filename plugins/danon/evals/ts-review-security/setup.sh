#!/usr/bin/env bash
# Scaffold for ts-review-security: base commit (strict tsconfig + clean control file),
# then staged (uncommitted) defects, one file per rule. No npm install needed.
set -euo pipefail

git init -q
git config user.email "eval@example.com"
git config user.name "Eval"

mkdir -p src/clean
cat > tsconfig.json <<'EOF'
{
  "compilerOptions": { "strict": true, "target": "ES2022", "module": "NodeNext" },
  "include": ["src"]
}
EOF
cat > src/clean/format.ts <<'EOF'
// Control file: correct code. Must produce zero findings.
export function formatPrice(cents: number): string {
  if (!Number.isInteger(cents) || cents < 0) {
    throw new Error('cents must be a non-negative integer')
  }
  return (cents / 100).toFixed(2)
}
EOF
git add -A
git commit -qm base

mkdir -p src/security
cat > src/security/xss.ts <<'EOF'
// CRITICAL (xss): XSS via innerHTML
export function renderName(el: HTMLElement, name: string): void {
  el.innerHTML = '<b>' + name + '</b>'
}
EOF
mkdir -p src/security
cat > src/security/sql.ts <<'EOF'
// CRITICAL (sql): SQL injection by concatenation
interface Db {
  query(sql: string): Promise<unknown[]>
}

export function findUser(db: Db, name: string): Promise<unknown[]> {
  return db.query("SELECT * FROM users WHERE name = '" + name + "'")
}
EOF
mkdir -p src/security
cat > src/security/path.ts <<'EOF'
// CRITICAL (path): path traversal in fs.readFile
import { readFile } from 'node:fs/promises'

export function readUpload(name: string): Promise<string> {
  return readFile('/srv/uploads/' + name, 'utf8')
}
EOF
mkdir -p src/security
cat > src/security/merge.ts <<'EOF'
// CRITICAL (merge): prototype pollution in recursive merge
export function deepMerge(
  target: Record<string, unknown>,
  source: Record<string, unknown>
): Record<string, unknown> {
  for (const key of Object.keys(source)) {
    const value = source[key]
    if (typeof value === 'object' && value !== null) {
      target[key] = deepMerge(
        (target[key] ?? {}) as Record<string, unknown>,
        value as Record<string, unknown>
      )
    } else {
      target[key] = value
    }
  }
  return target
}
EOF
mkdir -p src/security
cat > src/security/exec.ts <<'EOF'
// CRITICAL (exec): child_process.exec with user input
import { exec } from 'node:child_process'

export function ping(host: string): void {
  exec('ping -c 1 ' + host)
}
EOF

# Left staged, not committed: the agent prefers `git diff --staged`.
git add -A
