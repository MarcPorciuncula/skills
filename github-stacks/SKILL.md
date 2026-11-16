---
name: github-stacks
description: >
  Distinguish plain base-chained PRs from GitHub native Stacked PRs (`/stacks/`
  and `gh stack`), and query, create, extend, restack, or merge GitHub native
  stacks. TRIGGER when the user mentions a GitHub stack, a native stack, a
  stack number (`stack #N` or `/stack/N`), `gh stack`, or asks to stack PRs.
---

# GitHub Stacked PRs vs. Base-Chained PRs

"Stacking" pull requests can mean two different things on GitHub. Choose the right mechanism before creating or linking PRs:

| Mechanism | What it does | When to use |
|---|---|---|
| **Base-chained PRs (Default)** | Opens PR B with `--base <branch-A>` (`gh pr create --base <branch-A>`) without creating a GitHub `Stack` entity | **Default whenever the user says "stack this PR on X" or "raise a PR stacked over #N".** Use when stacking unrelated or loosely coupled work that happens to depend on an unmerged branch, or when multiple branches fan out from the same base branch (a tree/DAG). |
| **GitHub Native Stack (Explicit opt-in)** | Links a strictly linear (`1 -> 1`) chain of PRs into a first-class GitHub `Stack` entity (`github.com/<owner>/<repo>/stack/<number>`) that controls the PR merge box, cascading rebases, and atomic stack merges | **Only when the user explicitly requests a "GitHub stack" or "native stack", or when operating on an existing native stack (`/stack/<number>`).** Used when:<br>1. One cohesive feature is split into sequential layers for clean review boundaries and merged atomically together.<br>2. One cohesive feature is sequenced across required deploy boundaries (for example, an additive migration PR followed by a caller cutover/cleanup PR). |

Never create a GitHub native `Stack` entity (`/repos/{owner}/{repo}/stacks` or `gh stack submit` / `gh stack link`) unless the user explicitly asks for a GitHub/native stack or the target PR already belongs to one.

## Stack numbers vs. PR numbers

GitHub native Stacks have their own repository-scoped **stack number** that shares the same number sequence as issues and pull requests (`github.com/<owner>/<repo>/stack/50`):

- **Never pass a stack number to `gh pr view <number>` or `gh pr checkout <number>`:** A stack entity is not a pull request; querying `/pulls/<stack-number>` returns `404` or an unrelated issue/PR.
- **Always resolve a stack number through the Stacks API (`repos/{owner}/{repo}/stacks/<stack-number>`) or `gh stack`.**

## Querying and managing native stacks via `gh api`

The GitHub REST API works in every environment without requiring the `gh stack` CLI extension:

```bash
# Inspect a stack by its stack number (returns base.ref and ordered pull_requests[] bottom-to-top)
gh api repos/{owner}/{repo}/stacks/<stack-number>

# Check whether a PR belongs to a native stack (returns null for plain base-chained PRs)
gh api repos/{owner}/{repo}/pulls/<pr-number> --jq '.stack'

# Find the full stack object containing a specific PR number
gh api "repos/{owner}/{repo}/stacks?pull_request=<pr-number>"

# List all native stacks in the repository
gh api repos/{owner}/{repo}/stacks
```

When the user explicitly asks to create, extend, or dissolve a native stack:

```bash
# Create a native stack from ordered PR numbers (bottom to top; PR base refs must already chain)
gh api --method POST repos/{owner}/{repo}/stacks --input - <<< '{"pull_requests":[101,102,103]}'

# Append PR(s) onto the top of an existing native stack
gh api --method POST repos/{owner}/{repo}/stacks/<stack-number>/add --input - <<< '{"pull_requests":[104]}'

# Dissolve / unstack unmerged PRs from a native stack
gh api --method POST repos/{owner}/{repo}/stacks/<stack-number}/unstack
```

## Using the `gh stack` CLI extension (`github/gh-stack`)

When `gh stack` is installed (`gh extension list` or `gh extension install github/gh-stack`), always pass non-interactive flags so `gh stack` does not open a blocking terminal UI:

| Task | Command | Notes |
|---|---|---|
| Inspect current local stack | `gh stack view --json` | Never run bare `gh stack view` (opens a full-screen TUI) |
| Check out a stack by stack or PR number | `gh stack checkout <stack-or-pr-num>` | Fetches branches and sets up local tracking in `<git-common-dir>/gh-stack` |
| Fetch, reconcile, rebase, and push stack | `gh stack sync --prune` | Rebases all layers from trunk upward and pushes atomically |
| Cascade rebase across local stack | `gh stack rebase` | Supports `--upstack`, `--downstack`, `--continue`, `--abort` |
| Push all stack branches atomically | `gh stack push` | Uses per-branch `--force-with-lease` |
| Link existing branches/PRs into a native stack | `gh stack link <pr-or-branch>...` | Ordered bottom to top; creates/updates remote native stack without local tracking |
| Merge a native stack (or up to a PR) | `gh stack merge <stack-or-pr> --yes` | Uses GitHub's async stack merge API (`gh pr merge` cannot merge a native stack) |

To restack branches (either a native GitHub stack or plain base-chained PRs across worktrees), use `update-branch` if available.
