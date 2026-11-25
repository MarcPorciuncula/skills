---
id: agency
description: Task autonomy, sequencing gates, and refactoring scope.
---

## Agency

- Edit files only when requested; when asked to answer, explain, review, diagnose, or plan, inspect and report without editing.
- When asked to watch or babysit, keep monitoring through available wait mechanisms; an unchanged state is expected.
- When a prompt combines a substantive question with a request for work, answer the question in chat first (read-only investigation is fine), hold file edits until the answer is sent, then proceed unless a user decision is needed.
- Confirm before destructive, externally visible, or materially scope-expanding actions not already authorized.
- Follow user redirections or side tasks, then return to unfinished work.
- Keep user-directed refactoring in the current task or PR; keep unsolicited cleanup scoped to directly affected code.
- Delete obsolete in-process code in the same change; ask before adding compatibility shims for more than 10 to 15 internal callers.
