#!/usr/bin/env bash
# Scaffold for ts-review-type-safety: base commit (strict tsconfig + clean control file),
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

cat > tsconfig.json <<'EOF'
{
  "compilerOptions": { "strict": false, "noImplicitAny": false, "target": "ES2022", "module": "NodeNext" },
  "include": ["src"]
}
EOF

mkdir -p src/types
cat > src/types/any.ts <<'EOF'
// HIGH (any): any without justification
export function readValue(input: any): any {
  return input.value
}
EOF
mkdir -p src/types
cat > src/types/nonnull.ts <<'EOF'
// HIGH (nonnull): non-null assertion without guard
export function firstLongName(users: { name: string }[]): string {
  return users.find((u) => u.name.length > 3)!.name
}
EOF
mkdir -p src/types
cat > src/types/cast.ts <<'EOF'
// HIGH (cast): as unknown as T cast bypassing checks
export function toUser(raw: string): { id: number } {
  return raw as unknown as { id: number }
}
EOF

# Left staged, not committed: the agent prefers `git diff --staged`.
git add -A
