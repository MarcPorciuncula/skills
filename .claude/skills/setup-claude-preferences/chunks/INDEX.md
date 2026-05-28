# Chunks Index

Each entry below names a chunk `id` and summarises what it contains. The note after the em-dash is an advisory on when the chunk is most relevant — it's guidance, not a rule. The skill always shows diffs and recommendations; the user decides what to apply.

- **agency** — How to take initiative, balance action and deferral, use tools freely. Always applicable.
- **general-communication** — Response tone and formatting baselines (no flattery, no emojis, direct answers). Always applicable.
- **design-and-change-proposals** — State responsibility, boundary, and a rejected alternative before implementing. Always applicable.
- **visual-explanations** — ASCII diagrams and markdown tables for explaining code. Always applicable.
- **attributing-content** — Prefix GitHub/Linear comments with `[AI Generated - Claude]` (autonomous), `[AI Assisted - Claude / NAME]` (user shaped the text), or no label (strictly verbatim user-provided text); customisable list of primary-content fields (PR title/body, issue title) is excepted, with human-overview sections inside them preserved. Contains a `{{USER_NAME}}` placeholder substituted at apply time. Skip for users who don't collaborate on shared issue trackers.
- **writing-tests** — Two-pass self-check before writing any test: justify it (five gates), then design it (verification questions). Always applicable.
- **frontend-tests** — Default to no component test; refactor first so the code is visibly trivial. Applies when writing component tests; skip for backend-only work.
- **code-removal-and-refactoring** — Delete internal code rather than deprecate. Applies to internal codebases; less relevant for public-API maintenance.
- **refactoring-and-cleanup** — Don't push back on user-directed scope expansion. Always applicable.
- **worktrees** — Keep the repo root on `main` (no other-branch checkouts, even read-only); do all work on other branches in `.claude/worktrees/<branch>/`. Most relevant when multiple agents or sessions share a single clone; skip for users who work from a single checkout.
- **temporary-files** — Write-tool-only pattern for temp files. Most relevant on host-native setups where the agent's permissions are tighter and prompts interrupt the user — in sandboxed environments (e.g. `avm`) the sandbox enforces limits and the agent is expected to just try things.
- **shell-commands** — Avoid directory-targeting flags and chained `cd`. Most relevant on host-native setups where permission prompts are the main constraint; less critical in sandboxes.
- **committing-and-pushing** — Default commit+push, declare intent, check branch first. Always applicable.
- **pr-workflow** — Per-repo PR creation modes (`ask`, `draft`, `auto-ready`); default `ask`. Customisable repo list. Always applicable.
- **dev-servers** — Run dev servers in named tmux sessions. Applies to any workflow that runs long-lived processes during development.
- **task-tracking-dex** — `dex` CLI conventions. **Opt-in** — only apply for users who have said they use dex; skip otherwise.
- **running-tests** — Scope local runs to changed files; rely on CI for the full suite. Most relevant when CI runs the full suite on PR; skip if you rely on local runs for full coverage.
