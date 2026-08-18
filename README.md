# Agent Skills

Personal collection of reusable agent skills and user-level guidance for portable workflow automation across harnesses.

## Skills

| Skill | Description |
|-------|-------------|
| **address-review** | Analyze and address PR review comments |
| **babysit-pr** | Watch a PR over time: address bot review comments and rebase when stale |
| **clean-workspaces** | Clean up worktrees for merged branches |
| **map-ui-affordances** | Design and review UI structure with affordance trees |
| **pressure-test-skills** | Run blind behavior checks after skill changes |
| **testing** | Admit valuable tests, choose their level, and run red-green |
| **red-green** | Compatibility entry point for explicit TDD requests |
| **review-comment** | Draft focused, cold-read-accessible code review comments |
| **review-findings** | Audit self-review findings before changing code |
| **setup-notifications** | Set up macOS notification hooks for Claude Code |
| **setup-worktrees** | Set up a bare repo + worktrees workflow |
| **update-branch** | Rebase branches or restack git-spice stacks |

## Repo utilities

These live in `.claude/skills/` and are available when working in this repo, not installed on machines:

| Skill | Description |
|-------|-------------|
| **manage-user-agent-guidance** | Manage chunked user-level guidance across supported agent harnesses |
| **sync-skills** | Compare machine vs repo skills, reconcile differences, install new ones |

## User-level agent guidance

Canonical guidance content lives in `user-agent-guidance/`. Its `chunks/` directory contains independently maintainable sections, while `examples/` contains harness-specific configuration fragments referenced by those sections.

Run the `manage-user-agent-guidance` repo utility to compare or render these chunks into a supported harness's user-level guidance file.
