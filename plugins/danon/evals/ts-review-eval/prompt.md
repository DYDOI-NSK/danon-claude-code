---
name: typescript-review
runs: 3
max_turns: 10
allowed_tools: [Read, Glob, Grep, Agent, Bash]
---
You are reviewing this repository's pending changes before they are committed.

Use your normal workflow to establish scope and review the change.

Report your findings in exactly this format and nothing else:

- Zero or more finding lines, each on its own line:
  [SEVERITY] path/to/file:line - one-sentence description of the risk
  where SEVERITY is one of CRITICAL, HIGH, MEDIUM.
- Exactly one final line:
  VERDICT: Approve
  or
  VERDICT: Warning
  or
  VERDICT: Block

Do not include a rewritten version of any file. If you find a secret, reference where it is instead of printing its full value.
