---
paths:
  - "**/*.ts"
  - "**/*.tsx"
  - "**/*.js"
  - "**/*.jsx"
---
# TypeScript/JavaScript Patterns

> This file extends [common/patterns.md](../common/patterns.md) with TypeScript/JavaScript specific content.

## Files declaration

files containing types have name {domain}.types.ts. Domain can be component name,
domain part, entity or any business logic of project. File names use kebab-case.

```typescript
// WRONG: auth.ts  

// CORRECT: base-button.types.ts
// CORRECT: auth.types.ts
// CORRECT: common.types.ts
```
