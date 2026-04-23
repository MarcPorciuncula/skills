# Chunks Index

Each entry below names a chunk `id` and summarises what it contains. The note after the em-dash is an advisory on when the chunk is most relevant — it's guidance, not a rule. The skill always shows diffs and recommendations; the user decides what to apply.

- **architecture-and-communication** — Responsibility-first framing for code changes. Always applicable.
- **visual-explanations** — ASCII diagrams and markdown tables for explaining code. Always applicable.
- **pull-request-descriptions** — What-and-why PR bodies; no line-by-line edit lists. Skip for users who don't ship through PR review.
- **code-removal-and-refactoring** — Delete internal code rather than deprecate. Applies to internal codebases; less relevant for public-API maintenance.
- **refactoring-and-cleanup** — Don't push back on user-directed scope expansion. Always applicable.
- **temporary-files** — Write-tool-only pattern for temp files. Most relevant in sandboxed environments (e.g. `avm`) where `/tmp` triggers permission prompts — less critical on host-native setups.
- **shell-commands** — Avoid directory-targeting flags and chained `cd`. Most relevant in sandboxed environments with strict permission prompts.
- **committing-and-pushing** — Default commit+push, declare intent, check branch first. Always applicable.
