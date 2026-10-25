---
paths:
  - "**/*.vue"
---

# Vue Patterns

> This file extends [common/patterns.md](../common/patterns.md) with Vue specific content.

## Feature-Sliced Design

- Layers: `app`, `pages`, `widgets`, `features`, `entities`, `shared`. Imports go only downward, never upward or sideways between slices.
- Each slice exposes a public API via `index.ts`. Import from the slice root, not its internals.
- Container components (data, state, side effects) live in `pages` / `widgets` / `features`. Presentational components (props in, events out) live in `shared/UI`.
- Component and composable types live in `*.types.ts` next to the file. See the `vue-patterns` skill for the folder layout.

## Composables

- The composable (`useXxx`) is the reusable-logic unit. Component-specific composables live in the component's `composables/` folder, reusable ones in `shared/utils/composables`.
- Composable files are kebab-case with `use-` prefix. No module-scope side effects.
- Accept `MaybeRefOrGetter<T>` inputs and normalize with `toValue`, so callers can pass a ref, a getter, or a raw value.
- Return a plain object of refs, computed values and functions, so consumers can destructure without losing reactivity. If nothing is exposed, return nothing.
- A composable that uses lifecycle hooks or `provide` / `inject` must be called inside a component `setup`, not lazily or conditionally.

## Props, Emits, v-model

- Type-based `defineProps<Types.Props>()` and tuple-form emits declared in `*.types.ts`, e.g. `change: [id: number]`.
- `defineModel<T>('name', { default })` for two-way binding. It compiles to a prop plus an `update:*` emit.

## Provide / Inject

- Use `provide` / `inject` for tree-scoped data without prop drilling.
- Type-safe collision-free keys: `const key = Symbol() as InjectionKey<T>`.
- The provider owns mutations. Expose a `readonly` ref plus an explicit updater function, never a raw mutable ref.

## Pinia

- Prefer setup stores: `ref` is state, `computed` is getters, `function` is actions.
- Setup stores do not get `$reset` for free. Define your own.
- Use `storeToRefs` for state and getters. Destructure actions directly off the store.
- Never persist raw auth tokens to `localStorage`.

## vue-router

- Lazy-load route components with dynamic `import()`.
- A global `beforeEach` auth gate keyed on `meta.requiresAuth`. Guards return `false` (cancel), a route location (redirect), or `undefined` / `true` (continue).
- Read params through `computed<string>(() => route.params.id as string)`, not the whole `route` object.

## vue-query (server cache)

- `@tanstack/vue-query` owns server-cache state. Pinia owns client state.
- Put request functions plus `queryOptions` factories in the FSD `api` segment.
- Critical: put the ref or computed ITSELF in the query key, never `.value`. Passing `.value` freezes the key and kills reactive refetch.

```ts
useQuery({
  queryKey: ["auction", id],
  queryFn: () => fetchAuction(toValue(id)),
});
// after a mutation
queryClient.invalidateQueries({ queryKey: ["auction", id] });
```

## Reference

- Skills: `vue-patterns`, `vite-patterns`.
- Docs: <https://pinia.vuejs.org/> · <https://router.vuejs.org/> · <https://tanstack.com/query/latest/docs/framework/vue/overview> · <https://vuejs.org/guide/reusability/composables.html>
