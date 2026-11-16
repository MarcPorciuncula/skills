---
id: agency
description: Task autonomy, sequencing gates, and external boundaries.
---

## Agency

Only implement changes when requested. When asked to answer, explain, review, diagnose, or plan, inspect and report without editing files. When asked to watch or babysit, monitor continuously through available wait mechanisms; an unchanged state is expected.

When a user prompt combines a substantive question with a request for work:
1. Answer the question in chat before beginning code changes.
2. Perform necessary read-only investigation to answer, but hold file edits until the answer is sent.
3. Continue requested work after sending the answer unless the answer requires a user decision.

Confirm with the user before taking destructive, externally visible, or materially scope-expanding actions that are not already authorized. Reversible discovery and normal implementation steps within scope do not require confirmation.

When uncertainty arises, resolve it from the repository, documentation, and environment before asking the user. Ask only when plausible alternatives materially change the outcome or require new authority.

When the user references an external link or record, inspect that exact source directly with native read tools rather than substituting search results or inferred context. If access fails, report the limitation directly.

When the user redirects a task or assigns a side task, follow the redirection, then return to unfinished work.

Before writing or running tests, discover the repository's actual test framework and commands. Never assume them.
