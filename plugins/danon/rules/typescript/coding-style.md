---
paths:
  - "**/*.ts"
  - "**/*.tsx"
  - "**/*.js"
  - "**/*.jsx"
---

# TypeScript/JavaScript Coding Style

> This file extends [common/coding-style.md](../common/coding-style.md) with TypeScript/JavaScript specific content.

## Namespace

Use namespace for types and interfaces declaration. Namespace responsible for domain part of project.

## Types and Interfaces

Use types to make public APIs, shared models, and component props explicit, readable, and reusable.

### Public APIs

- Add parameter and return types to exported functions, shared utilities, and public class methods
- Exception: omit the return type when a function returns nothing; do not write `void` or `Promise<void>`
- Let TypeScript infer obvious local variable types
- Extract repeated inline object shapes into named types or interfaces

```typescript
// WRONG: Exported function without explicit types
export function formatUser(user) {
  return `${user.firstName} ${user.lastName}`;
}

// CORRECT: Explicit types on public APIs
import { AuthTypes } from "./auth.types.ts";

export function formatUser(user: AuthTypes.User): string {
  return `${user.firstName} ${user.lastName}`;
}
```

```typescript
// WRONG: void and Promise<void> return types are specified
export function handleCallback(callback: () => void): void {
  callback();
}

export async function updateEntity(): Promise<void> {
  await fetchUpdate();
}

// CORRECT: void and Promise<void> are omitted
export function handleCallback(callback: () => void) {
  callback();
}

export async function updateEntity() {
  await fetchUpdate();
}
```

### Interfaces vs. Type Aliases

- Use `interface` for object shapes that may be extended or implemented
- Use `type` for unions, intersections, tuples, mapped types, and utility types
- Prefer string literal unions over `enum` unless an `enum` is required for interoperability

```typescript
export namespace AuthTypes {
  export interface User {
    id: string;
    email: string;
  }

  export interface UserWithRole extends User {
    role: UserRole;
  }

  type UserRole = "admin" | "member";
}
```

### Avoid `any`

- Avoid `any` in application code
- Use `unknown` for external or untrusted input, then narrow it safely
- Use generics when a value's type depends on the caller

```typescript
// WRONG: any removes type safety
function getErrorMessage(error: any) {
  return error.message;
}

// CORRECT: unknown forces safe narrowing
function getErrorMessage(error: unknown): string {
  if (error instanceof Error) {
    return error.message;
  }

  return "Unexpected error";
}
```

### Types order declaration

In all namespaces declaration order is:

- enums
- interfaces
- types

Separate declarations with an empty line

### Components Props

- Define component props with a named `interface`
- Type callback props explicitly

```typescript user-card.types.ts
import { AuthTypes } from "./auth.types.ts";

export namespace UserCardTypes {
  export interface Props {
    user: AuthTypes.User;
    onSelect: (id: string) => void;
  }
}
```

```typescript
<script setup lang="ts">
import { UserCardTypes } from './user-card.types.ts';

const props = defineProps<UserCardTypes.Props>()
</script>

<template>
    <button @click="() => props.onSelect(props.user.id)">{{props.user.email}}</button>
</template>
```

## Imports

Choose the import path by how far the module is from the importing file.

- Use a relative path (`./` or `../`) when the module is in the same folder, a subfolder, or at most two levels up
- Use the project alias (for example `@/`) when reaching the module needs three or more `../`
- Never write `../../../` or deeper
- Use the alias already configured in the project (`tsconfig.json` paths or bundler config)

```typescript
// File: src/projects/project-name/shared/utils/helpers/apply-changes.ts

// WRONG: alias for a nearby module
import { mapDataChanges } from "@/projects/project-name/shared/utils/mappers/data-changes-mapper";

// CORRECT: one level up, relative path
import { mapDataChanges } from "../mappers/data-changes-mapper";

// WRONG: deep relative path
import { formatDate } from "../../../../../shared/lib/format-date";

// CORRECT: far away module, alias
import { formatDate } from "@/projects/project-name/shared/lib/format-date";
```

## Immutability

Use spread operator for immutable updates:

```typescript
// WRONG: Mutation
function updateUser(user: AuthTypes.User, name: string): AuthTypes.User {
  user.name = name; // MUTATION!
  return user;
}

// CORRECT: Immutability
function updateUser(
  user: Readonly<AuthTypes.User>,
  name: string,
): AuthTypes.User {
  return {
    ...user,
    name,
  };
}
```

## Error Handling

Use async/await with try-catch and narrow unknown errors safely:

```typescript
import { AuthTypes } from "./auth.types.ts";

function riskyOperation(userId: string): Promise<AuthTypes.User> {
  throw new Error("unknown error");
}

function getErrorMessage(error: unknown): string {
  if (error instanceof Error) {
    return error.message;
  }

  return "Unexpected error";
}

const logger = {
  error: (message: string, error: unknown) => {
    // Replace with your production logger (for example, pino or winston). If logger not exist then ignore
  },
};

async function loadUser(userId: string): Promise<AuthTypes.User> {
  try {
    return await riskyOperation(userId);
  } catch (error: unknown) {
    logger.error("Operation failed", error);
    throw new Error(getErrorMessage(error));
  }
}
```

## Console.log

- No `console.log` statements in production code
- Use proper logging libraries instead
- See hooks for automatic detection
