#!/usr/bin/env bash
# Scaffold for ts-review-idioms: base commit (strict tsconfig + clean control file),
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

mkdir -p src/idioms
cat > src/idioms/state.ts <<'EOF'
// HIGH (state): module-level mutable shared state
export let counter = 0

export function nextId(): number {
  counter += 1
  return counter
}
EOF
mkdir -p src/idioms
cat > src/idioms/var.ts <<'EOF'
// HIGH (var): var instead of const/let
export function total(xs: number[]): number {
  var sum = 0
  for (const x of xs) {
    sum += x
  }
  return sum
}
EOF
mkdir -p src/idioms
cat > src/idioms/rettype.ts <<'EOF'
// HIGH (rettype): public function without explicit return type
export function double(x: number) {
  return x * 2
}
EOF
mkdir -p src/idioms
cat > src/idioms/callback.ts <<'EOF'
// HIGH (callback): callback mixed with async/await
import { readFile } from 'node:fs'

export async function loadText(
  path: string,
  done: (err: Error | null, data?: string) => void
): Promise<void> {
  readFile(path, 'utf8', (err, data) => done(err, data))
}
EOF
mkdir -p src/idioms
cat > src/idioms/eq.ts <<'EOF'
// HIGH (eq): == instead of ===
export function isAdmin(role: string): boolean {
  return role == 'admin'
}
EOF

# Left staged, not committed: the agent prefers `git diff --staged`.
git add -A
