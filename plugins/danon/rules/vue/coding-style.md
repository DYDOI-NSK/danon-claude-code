---
paths:
  - "**/*.vue"
---

# Vue Coding Style

> This file extends [common/coding-style.md](../common/coding-style.md) with Vue specific content.

## SFC Structure

- Always `<script setup lang="ts">` with the Composition API. No Options API in new code.
- Block order inside a `.vue` file: `<script setup>`, then `<template>`, then `<style scoped>`. One component per file.
- Naming: component files PascalCase (`AuctionCard.vue`), component folders kebab-case (`auction-card/`), composable files kebab-case prefixed `use-` (`use-auction-timer.ts`) exporting a function `useXxx` (`useAuctionTimer`), types in `name.types.ts`.
- Always type props, emits and expose (`defineProps<Types.Props>()`, `defineEmits<Types.Emits>()`, `defineExpose({...} satisfies Types.Expose)`). Never mutate props, emit events instead.
- Declaration order in `<script setup>`: imports, props/emits/models, composables, refs and simple constants, computed, arrow functions, declaration functions, watches and lifecycle hooks.

### Script Best Practices

```ts
import type { ComponentTypes } from "./component.types";

const props = defineProps<ComponentTypes.Props>();

const emit = defineEmits<ComponentTypes.Emits>();

defineExpose({
  // fields to be exposed
} satisfies ComponentTypes.Expose);
```

- Component types live in `<component-name>.types.ts` as a namespace: `Props`, `Emits`, `Expose`.

## Reactivity Declaration

- Specify the type of a `ref` via generic. The only exception is a `ref` holding a `boolean` (or other literal-inferred primitive) initial value: `ref(false)`.
- Always specify the type of `computed` and `reactive` via generic. No exceptions.

```ts
// WRONG
const visible = ref<boolean>(false);
const formState = ref();
const displayText = computed(() => (visible.value ? "text" : null));

// CORRECT
const loading = ref(false);
const data = ref<CommonTypes.Data | undefined>();
const displayText = computed<string | null>(() =>
  visible.value ? "text" : null,
);
const form = reactive<CommonTypes.FormState>({ name: "" });
```

## Computed and Watchers

- `computed` getters must be pure: no side effects, no async, no DOM access.
- 3.4+ `computed` only triggers when the returned value changes. Return the prior object unchanged when equal to skip downstream updates.
- Do not use `watch` or `watchEffect`. Use the framework's declarative approaches instead: `computed`, event handlers, `defineModel`, callbacks.

## Reference

- Skills: `vite-patterns`.
- Docs: <https://vuejs.org/api/sfc-script-setup.html> · <https://vuejs.org/guide/essentials/reactivity-fundamentals.html> · <https://eslint.vuejs.org/>
