#!/usr/bin/env bash
# Scaffold for ts-review-errors: base commit (strict tsconfig + clean control file),
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

mkdir -p src/errors
cat > src/errors/swallow.ts <<'EOF'
// HIGH (swallow): empty catch block
export function tryRun(task: () => void): void {
  try {
    task()
  } catch (e) {}
}
EOF
mkdir -p src/errors
cat > src/errors/parse.ts <<'EOF'
// HIGH (parse): JSON.parse without try/catch
export function parseConfig(text: string): unknown {
  return JSON.parse(text)
}
EOF
mkdir -p src/errors
cat > src/errors/throw.ts <<'EOF'
// HIGH (throw): throwing a string instead of Error
export function requirePositive(n: number): number {
  if (n <= 0) {
    throw 'n must be positive'
  }
  return n
}
EOF

# Left staged, not committed: the agent prefers `git diff --staged`.
git add -A
