#!/usr/bin/env bash
# Scaffold for ts-review-async: base commit (strict tsconfig + clean control file),
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

mkdir -p src/async
cat > src/async/unhandled.ts <<'EOF'
// HIGH (unhandled): async function called without await/catch
async function save(id: string): Promise<void> {
  await fetch('/api/items/' + id, { method: 'PUT' })
}

export function onSave(id: string): void {
  save(id)
}
EOF
mkdir -p src/async
cat > src/async/sequential.ts <<'EOF'
// HIGH (sequential): sequential awaits for independent work
export async function loadAll(ids: string[]): Promise<string[]> {
  const results: string[] = []
  for (const id of ids) {
    const res = await fetch('/api/items/' + id)
    results.push(await res.text())
  }
  return results
}
EOF
mkdir -p src/async
cat > src/async/floating.ts <<'EOF'
// HIGH (floating): floating promise in constructor
export class Cache {
  constructor() {
    this.warm()
  }

  private async warm(): Promise<void> {
    await fetch('/api/warm')
  }
}
EOF
mkdir -p src/async
cat > src/async/foreach.ts <<'EOF'
// HIGH (foreach): async callback in forEach
export function syncAll(ids: string[]): void {
  ids.forEach(async (id) => {
    await fetch('/api/sync/' + id, { method: 'POST' })
  })
}
EOF

# Left staged, not committed: the agent prefers `git diff --staged`.
git add -A
