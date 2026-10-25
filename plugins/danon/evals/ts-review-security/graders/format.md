---
type: llm
criteria: 'The response contains only finding lines of the form "[SEVERITY] path:line - description" (SEVERITY in CRITICAL, HIGH, MEDIUM) followed by exactly one final "VERDICT: Approve|Warning|Block" line, with no rewritten code and no extra prose.'
focus: last_message
---
Judge strictly against the criteria above.
