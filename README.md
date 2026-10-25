# danon-claude-code

Личная сборка для Claude Code.

Сборка была инициализированна на основе плагина [everything-claude-code](https://github.com/affaan-m/everything-claude-code) v2.2.3 (коммит `76aaa77`, 2026-10-15), MIT.

## Установка

```bash
/plugin marketplace add DYDOI-NSK/danon-claude-code
/plugin install danon@danon

# rules плагином не ставятся — отдельно, из локального клона
# (симлинк rules/ -> ~/.claude/rules/danon):
./install-rules.sh
```

## Что внутри

| Папка                          | Содержимое                                                                                                                                                        |
| ------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `plugins/danon/agents/`        | architect, build-error-resolver, code-reviewer, planner, refactor-cleaner, security-reviewer, silent-failure-hunter, tdd-guide, typescript-reviewer, vue-reviewer |
| `plugins/danon/skills/`        | context-budget, e2e-testing, ecc-guide, git-workflow, search-first, strategic-compact, tdd-workflow, verification-loop, vite-patterns, vue-patterns               |
| `plugins/danon/rules/`         | common, typescript, vue, web                                                                                                                                      |
| `plugins/danon/hooks/hooks.json` | см. ниже                                                                                                                                                          |
| `plugins/danon/scripts/{hooks,lib}` | скрипты хуков ECC и их зависимости (Node, без npm-пакетов)                                                                                                        |

Агенты вызываются как `danon:<агент>`, скиллы — как `/danon:<скилл>`. Справочник по содержимому плагина — `/danon:ecc-guide`.

### Хуки

| Событие | Скрипт | Что делает |
|---|---|---|
| PreToolUse (Write/Edit) | `config-protection.js` | блокирует правку существующих конфигов линтера/форматтера |
| PostToolUse (Write/Edit) | `post-edit-accumulator.js` | запоминает изменённые файлы для Stop-хука |
| Stop | `stop-format-typecheck.js` | Prettier/Biome + `tsc --noEmit` по изменённым JS/TS-файлам |
| Stop | `check-console-log.js` | предупреждает о `console.log` в изменённых файлах |
| Stop | `desktop-notify.js` | уведомление macOS о готовом ответе |
