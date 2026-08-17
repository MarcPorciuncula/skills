# Chunks Index

Each entry below names a chunk `id` and summarises what it contains. The note after the em-dash is an advisory on when the chunk is most relevant — it's guidance, not a rule. The skill always shows diffs and recommendations; the user decides what to apply.

- **agency** — Choose report, execute, or monitor mode; answer mixed-turn questions in chat before starting accompanying work. Always applicable.
- **review-findings** — Treat internal review findings as claims, publish their assessment, preserve a task-local record, and continue authorized work without losing feedback. Applies when the `review-findings` skill is installed.
- **general-communication** — Decision-oriented chat structure, technical precision without technical prose, and concise progress updates. Always applicable.
- **design-and-change-proposals** — For architectural choices, state responsibility, boundary, and a rejected alternative. Skip when ownership is localized and unambiguous.
- **visual-explanations** — Prefer ASCII diagrams, tables, and call trees for structural or relational explanations. Always applicable.
- **attributing-content** — Label AI-authored GitHub/Linear comments, except primary-content fields, and preserve human-overview sections. Contains a `{{USER_NAME}}` placeholder. Skip for users who do not collaborate on shared issue trackers.
- **writing-tests** — Load the canonical testing skill before behavioural implementation or test edits. Applies when the `testing` skill is installed.
- **frontend-tests** — Load the testing skill's frontend path for component, route, hook, JSX, or browser tests. Skip for backend-only work.
- **code-removal-and-refactoring** — Remove code atomically inside one runtime boundary; preserve compatibility across deployments, transports, and persisted data. Applies to internal codebases; less relevant for public-API maintenance.
- **refactoring-and-cleanup** — Proceed with user-directed cleanup while keeping unsolicited cleanup focused. Always applicable.
- **worktrees** — Keep the repo root on `main` (no other-branch checkouts, even read-only); do all work on other branches in `.claude/worktrees/<branch>/`. Most relevant when multiple agents or sessions share a single clone; skip for users who work from a single checkout.
- **temporary-files** — Write-tool-only pattern for temp files. Most relevant on host-native setups where the agent's permissions are tighter and prompts interrupt the user — in sandboxed environments (e.g. `avm`) the sandbox enforces limits and the agent is expected to just try things.
- **shell-commands** — Avoid directory-targeting flags and chained `cd`. Most relevant on host-native setups where permission prompts are the main constraint; less critical in sandboxes.
- **codex-harness-execution** — First-attempt escalation and configured cache, credential-store, and loopback behavior. Applies when Codex runs with a custom sandbox profile and Auto-review.
- **committing-and-pushing** — For direct repository mutations, declare the branch plan and commit and push by default. Applies to Git-based development workflows.
- **pr-workflow** — Per-repo PR creation modes (`ask`, `draft`, `auto-ready`) without enforcing state after creation. Applies when the user opens PRs from the agent.
- **dev-servers** — Run long-lived processes in named tmux sessions with ownership and actual port in the name. Applies to workflows that start development processes.
- **task-tracking-dex** — `dex` CLI conventions. **Opt-in** — only apply for users who have said they use dex; skip otherwise.
- **running-tests** — Match verification type and scope to the change; rely on CI for full coverage when guaranteed. Skip if local full-suite validation is required.
