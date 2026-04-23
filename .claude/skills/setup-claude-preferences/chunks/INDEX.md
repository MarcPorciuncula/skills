# Chunks Index

Each entry below names a chunk `id` and summarises what it contains. The note after the em-dash is an advisory on when the chunk is most relevant — it's guidance, not a rule. The skill always shows diffs and recommendations; the user decides what to apply.

- **architecture-and-communication** — Responsibility-first framing for code changes. Always applicable.
- **visual-explanations** — ASCII diagrams and markdown tables for explaining code. Always applicable.
- **pull-request-descriptions** — What-and-why PR bodies; no line-by-line edit lists. Skip for users who don't ship through PR review.
- **code-removal-and-refactoring** — Delete internal code rather than deprecate. Applies to internal codebases; less relevant for public-API maintenance.
- **refactoring-and-cleanup** — Don't push back on user-directed scope expansion. Always applicable.
- **temporary-files** — Write-tool-only pattern for temp files. Most relevant on host-native setups where the agent's permissions are tighter and prompts interrupt the user — in sandboxed environments (e.g. `avm`) the sandbox enforces limits and the agent is expected to just try things.
- **shell-commands** — Avoid directory-targeting flags and chained `cd`. Most relevant on host-native setups where permission prompts are the main constraint; less critical in sandboxes.
- **committing-and-pushing** — Default commit+push, declare intent, check branch first. Always applicable.
