# Chunks Index

Each entry below names a chunk `id` and summarises what it contains. The note after the colon is an advisory on when the chunk is most relevant: it is guidance, not a rule. The skill always shows diffs and recommendations; the user decides what to apply.

- **agency**: Task autonomy, mixed-turn sequencing gates, redirections, and refactoring scope. Always applicable.
- **review-findings**: Load `review-findings` before acting on review findings and avoid automatic self-review at intermediate checkpoints. Applies when the `review-findings` skill is installed.
- **general-communication**: Structural communication preferences (diagrams/tables for 3+ elements, direct subject naming, no unsolicited closing offers) and conditional routing to `writing-persistent-content`. Always applicable.
- **attributing-content**: Label AI-authored GitHub/Linear comments, preserve protected fields, and manage standing vs per-request PR review reply authorization. Contains `{{USER_NAME}}` and `{{PR_REVIEW_REPLY_ALLOWLIST}}` placeholders. Skip for users who do not collaborate on shared issue trackers.
- **writing-tests**: Load the `testing` skill (and its frontend reference for UI/browser tests) before behavioural edits or test changes. Applies when the `testing` skill is installed.
- **worktrees**: Keep the repo root on `main` (no other-branch checkouts, even read-only); do all non-`main` work in `.claude/worktrees/<branch>/`. Most relevant when multiple agents or sessions share a single clone; skip for users who work from a single checkout.
- **codex-harness-execution**: Codex sandbox permission requests, cache-path preservation, and recommending `~/.codex/config.toml` policy updates when recurring tools hit restrictions. Requires adapting and merging [codex-agent-dev.config.toml](../examples/codex-agent-dev.config.toml) into the user-level Codex config before applying this chunk.
- **committing-and-pushing**: For direct repository mutations, declare the branch plan and commit and push by default. Applies to Git-based development workflows.
- **pr-workflow**: Per-repo PR creation modes (`ask`, `draft`, `auto-ready`) without altering existing readiness state. Applies when the user opens PRs from the agent.
- **dev-servers**: Load the `dev-servers` skill before starting, inspecting, or stopping long-lived development servers in tmux. Applies when the `dev-servers` skill is installed.
- **task-tracking-dex**: `dex` CLI conventions. Opt-in: only apply for users who have said they use dex; skip otherwise.
- **running-tests**: Match local verification type and scope to the change; rely on CI for full coverage when guaranteed; load `inspect-depot-ci` before investigating Depot failures. Skip if local full-suite validation is required.
