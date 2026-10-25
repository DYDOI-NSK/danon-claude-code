#!/usr/bin/env bash
# Scaffold for the typescript-review case: builds a git repo in the current
# (scaffold) directory with a base commit, two staged CRITICAL defects
# (C-01 eval, C-07 hardcoded secret) and a clean control file.
# Plain JavaScript on purpose: no tsconfig/package.json, so no npm install.
set -euo pipefail

git init -q
git config user.email "eval@example.com"
git config user.name "Eval"

mkdir -p src/clean src/lib

cat > src/lib/logger.js <<'EOF'
export function logInfo(message) {
  console.info(`[info] ${message}`)
}
EOF

cat > src/clean/pricing.js <<'EOF'
// Control file: correct, type-safe-ish code. Must produce zero findings.
export function applyDiscount(price, percent) {
  if (percent < 0 || percent > 100) {
    throw new Error('percent must be between 0 and 100')
  }
  return price - (price * percent) / 100
}
EOF

git add -A
git commit -qm base

mkdir -p src/security

cat > src/security/dynamic.js <<'EOF'
// CRITICAL (C-01): eval() on a value that can come from untrusted input.
export function evaluateFilter(expression, context) {
  return eval(expression)
}
EOF

cat > src/security/system.js <<'EOF'
// CRITICAL (C-07): hardcoded secret in source. Synthetic/fake value, not a
// real key, but shaped like one so the agent must recognize the pattern.
export const PAYMENT_API_KEY = 'sk_live_51TESTFAKEKEY0000000000000000'

export function chargeCard(cardToken, amountCents) {
  return fetch('https://payments.example.com/charge', {
    method: 'POST',
    headers: { Authorization: `Bearer ${PAYMENT_API_KEY}` },
    body: JSON.stringify({ cardToken, amountCents })
  })
}
EOF

git add -A
# Intentionally left staged, not committed: the agent's own instructions
# prefer `git diff --staged` first for local review.
