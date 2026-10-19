# danon-claude-code

Личная сборка для Claude Code.

Сборка была инициализированна на основе плагина [everything-claude-code](https://github.com/affaan-m/everything-claude-code) v2.2.3 (коммит `76aaa77`, 2026-10-15), MIT.

## Установка

```bash
# в Claude Code
/plugin marketplace add <путь или git-URL этого репозитория>
/plugin install danon@danon

# rules плагином не ставятся — отдельно:
./install-rules.sh   # симлинк rules/ -> ~/.claude/rules/danon
```

## Что внутри

| Папка | Содержимое |
|---|---|
| `agents/` | planner, code-reviewer, vue-reviewer, typescript-reviewer, build-error-resolver, silent-failure-hunter |
| `skills/` | vue-patterns, vite-patterns, frontend-patterns, e2e-testing, tdd-workflow, verification-loop, git-workflow, search-first, strategic-compact, context-budget |
| `rules/` | common, typescript, vue, web |
| `hooks/hooks.json` | см. ниже |
| `scripts/hooks`, `scripts/lib` | скрипты хуков ECC и их зависимости (Node, без npm-пакетов) |

### Хуки

| Событие | Скрипт | Что делает |
|---|---|---|
| PreToolUse (Write/Edit) | `config-protection.js` | блокирует правку существующих конфигов линтера/форматтера |
| PostToolUse (Write/Edit) | `post-edit-accumulator.js` | запоминает изменённые файлы для Stop-хука |
| Stop | `stop-format-typecheck.js` | Prettier/Biome + `tsc --noEmit` по изменённым JS/TS-файлам |
| Stop | `check-console-log.js` | предупреждает о `console.log` в изменённых файлах |
| Stop | `desktop-notify.js` | уведомление macOS о готовом ответе |

Хуки подключены напрямую, без диспетчера `run-with-flags.js` и профилей ECC (`ECC_HOOK_PROFILE` здесь не действует).

## Что нужно сделать

- [ ] Проверил описание имеющихся агентов. Нужно проверить их в действии
- [ ] Для code-reviewer написать критические проблемы для vue-фреймворка 

Файлы скопированы без правок, поэтому ссылаются на то, чего в сборке нет:

- агенты `security-reviewer`, `tdd-guide`, `architect`, `refactor-cleaner`, `e2e-runner`, `doc-updater` и агенты других языков — в `rules/common/*.md`, `agents/build-error-resolver.md`, `agents/vue-reviewer.md` и др.;
- `/ecc:ecc-guide` — `rules/common/agents.md`;
- `scripts/hooks/suggest-compact.js` — `skills/strategic-compact/SKILL.md`;
- `scripts/setup-package-manager.js` — `skills/tdd-workflow/SKILL.md`.

Найти всё: `grep -rnE "security-reviewer|tdd-guide|architect|refactor-cleaner|e2e-runner|doc-updater|/ecc:|scripts/" agents skills rules`.


