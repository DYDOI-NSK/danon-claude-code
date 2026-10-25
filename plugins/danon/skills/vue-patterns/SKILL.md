---
name: vue-patterns
description: Vue.js 3 Composition API project conventions - Feature-Sliced Design structure, component folder layout, typed props/emits/expose, composables, script declaration order, and performance techniques. Use when building or reviewing Vue 3 code.
origin: ECC (adapted)
---

# Vue.js Patterns and Best Practices

Project conventions for Vue.js 3 development using Composition API (`<script setup>`): structure, component design, composables and performance. Short mandatory rules live in `rules/vue/`; this skill holds the structure, examples and rationale.

## When to Activate

Activate this skill when:

- The project uses Vue.js 3, Vite + Vue, or Pinia.
- The user asks about Vue component architecture, file structure, composables, or Feature-Sliced Design.
- Creating, moving or reviewing Vue Single-File Components (`.vue` files).
- Discussing Vue-specific performance.

---

## 1. Project Structure

### Recommended Layout (Feature-Sliced Design)

#### Layers

Imports go only downward: a layer may import from the layers below it, never above or sideways between slices.

```
src/
├── app/            # app and router configuration
├── pages/          # route-level components
├── widgets/        # Complex business-logic UI-components
├── features/       # Features of business-logic based on entities and shared modules
├── entities/       # Domain entities of business-logic
├── shared/         # Shared/reusable code, no business logic
```

Each slice exposes a public API through `index.ts`. Import from the slice root, not from its internals.

#### Segments

Each slice may contain segments. Example for `shared`:

```
src/
├── shared/
│   ├── api/          # axios and request functions
│   ├── utils/        # reusable business logic
│   │   ├── constants/
│   │   ├── functions/
│   │   └── composables/
│   ├── types/        # reusable types
│   └── UI/           # reusable UI-components
```

Slice-specific code stays inside the slice. Move it to `shared` only when a second slice needs it.

### File Naming

| Convention               | When to Use                             |
| ------------------------ | --------------------------------------- |
| `PascalCase.vue`         | All components                          |
| `use-kebab-case.ts`      | Composable files (function: `useXxx`)   |
| `name.types.ts`          | Types of a component or composable      |
| `kebab-case` directories | Component folders, features, route dirs |

---

## 2. Component Architecture

### Single-File Component Order

```vue
<script setup lang="ts">
// 1. Imports (vue → ecosystem → absolute → relative)
// 2. Props & Emits & Models & Expose
// 3. Composables
// ... full declaration order: rules/vue/coding-style.md
</script>

<template>
  <!-- Template content -->
</template>

<style scoped>
/* Scoped styles */
</style>
```

### Presentational vs Container

- **Container components**: Own data fetching, state, and side effects. Render presentational components. Usually live in `pages/`, `widgets/`, `features/`.
- **Presentational components**: Receive props, emit events. No API calls, no store access. Pure rendering. Usually live in `shared/UI`.

### Component Folder

When creating or modifying components, keep every change consistent with this file structure:

```
├── base-button/              # component folder name
│   ├── composables/          # composables (if needed)
│   ├── components/           # child components used only here (if needed)
│   ├── BaseButton.vue
│   ├── BaseButton.spec.ts    # tests next to the component
│   └── base-button.types.ts  # component own types declaration (if needed)
```

- A child component used by one parent stays in that parent's `components/`.
- Once a second consumer appears, move it to `shared/UI` (or the lowest suitable layer).

---

## 3. Composables (Reusable Logic)

### Structure

```ts
// composables/use-loading.ts
import type { ComposableTypes } from "./composable.types";

export default function useLoading(params: ComposableTypes.UseLoadingParams) {
  const loading = ref(params.loading);

  const setLoading = (value: boolean) => (loading.value = value);

  return {
    loading,
    setLoading,
  };
}
```

### Rules

- File name is kebab-case with `use-` prefix, the exported function is `useXxx`.
- Return an object with exposed state and methods. If nothing is exposed, return nothing.
- No module-scope side effects.

---

## 4. Performance

| Technique               | When to Use                                 |
| ----------------------- | ------------------------------------------- |
| `v-memo`                | List items that rarely change               |
| `v-once`                | Content rendered once and static forever    |
| `shallowRef()`          | Large data structures replaced wholesale    |
| `shallowReactive()`     | Only top-level properties are reactive      |
| `v-show` over `v-if`    | Frequent visibility toggles                 |
| `<KeepAlive :max="10">` | Cache toggled views                         |
| Lazy routes             | `() => import(...)` for non-critical routes |
| `Suspense`              | Async component loading with fallback       |

---

## Related

- `rules/vue/` — mandatory Vue rules (coding style, patterns, security, testing)
- `rules/typescript/` — TypeScript rules applied to Vue projects
