---
name: ecc-guide
description: Answer questions about the danon plugin by reading its live files — agents, skills, hooks and rules — instead of memory. Use when the user asks what danon includes, which agent or skill fits a task, how hooks behave, or how to install/update the plugin and its rules.
argument-hint: "[agents | skills | hooks | rules | install | find: <query> | <name>]"
metadata:
  origin: adapted from everything-claude-code skills/ecc-guide (v2.2.3)
---

# danon Guide

Use this skill when a user needs help understanding, navigating, installing, or choosing parts of the danon plugin.

## Core Principle

Answer from current files, not memory. Do not invent agents, skills, hooks or rules that are not present.

The plugin root is two directories above this SKILL.md (`<skill base dir>/../..`). The user's working directory is usually a different project, so always read from the plugin root, not from cwd.

Inspect only what the question needs:

```bash
ls <plugin-root>/agents <plugin-root>/skills <plugin-root>/rules
cat <plugin-root>/hooks/hooks.json
```

## Repository Map

- `README.md`: install, update, contents, TODO
- `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`: plugin and marketplace manifests
- `agents/*.md`: delegated subagent roles (name, description, tools, model in frontmatter)
- `skills/*/SKILL.md`: on-demand workflows, invoked as `/danon:<skill>`
- `rules/`: always-loaded guidelines (`common/`, `typescript/`, `vue/`, `web/`); not delivered by the plugin, installed by `install-rules.sh` as a symlink at `~/.claude/rules/danon`
- `hooks/hooks.json`, `scripts/hooks/`, `scripts/lib/`: hook behavior

## Usage

```text
/danon:ecc-guide
/danon:ecc-guide agents | skills | hooks | rules | install
/danon:ecc-guide find: <query>
/danon:ecc-guide <agent-or-skill-name>
```

### No arguments

Give a compact menu (agents, skills, hooks, rules, install/update, find a feature) and ask what the user wants next.

### Topic lookup

1. Summarize the current surface in 3-6 bullets, read from the files.
2. Point to the canonical directory or file.
3. Suggest one command to verify the state (`/agents`, `/plugin`, `ls ~/.claude/rules/danon`).
4. No exhaustive lists unless asked.

### Search mode (`find: <query>`)

1. `grep -rn "<query>" agents skills rules hooks scripts` in the plugin root.
2. Group matches by surface, strongest first, with file paths.
3. Recommend which one to use first and why.

### Feature lookup

1. Check `agents/<name>.md` and `skills/<name>/SKILL.md` first, then search.
2. Explain what it does, when to use it, and its canonical file.

## Install and update

```text
/plugin marketplace add DYDOI-NSK/danon-claude-code
/plugin install danon@danon
/plugin marketplace update danon   # after a version bump in plugin.json
```

Rules: run `install-rules.sh` from a local clone.

## Response style

Lead with the answer, then the next action:

```text
Use <agent-or-skill>. It fits because <reason>.
Canonical file: <path>
Next: <one concrete action>
```
