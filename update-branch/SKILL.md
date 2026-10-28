---
name: update-branch
description: >
  Update a branch or stack of branches by rebasing onto main or updated parent
  PR branches, including GitHub native Stacked PRs (`gh stack` / `/stacks/`).
  TRIGGER when the user says "update the branch", "update the stack", "rebase
  on main", "restack", "restack stack #N", "update branches", "update all
  branches", or similar.
---

# Update Branch and PR Stacks

Update a single branch or a stack of dependent PR branches using GitHub native Stacked PRs (`gh stack` and the GitHub Stacks API) or standard `git` rebasing. Do not ask for confirmation before force-pushing; requesting a branch update authorizes `git push --force-with-lease` or `gh stack sync` / `gh stack push`.

## 1. GitHub Native Stacks vs. Pull Requests

GitHub native **Stacks** are first-class repository entities (`github.com/<owner>/<repo>/stack/<number>`) whose stack numbers share the repository's issue/PR number sequence:

- **Never pass a stack number to `gh pr view <number>`:** Calling `gh pr view` on a stack number fails or resolves to the wrong entity because a stack is not a PR.
- **Query a stack by stack number or PR number via the REST API:**
  ```bash
  # Get a stack by its stack number (returns base.ref and ordered pull_requests[] bottom-to-top)
  gh api repos/{owner}/{repo}/stacks/<stack-number>

  # Find the stack containing a specific PR number (or read `.stack` directly on the PR)
  gh api "repos/{owner}/{repo}/stacks?pull_request=<pr-number>"
  gh api repos/{owner}/{repo}/pulls/<pr-number> --jq '.stack'

  # List all stacks in the repository
  gh api repos/{owner}/{repo}/stacks
  ```
- **Create or modify a stack via the REST API (or `gh stack` CLI extension):**
  ```bash
  # Create a stack from ordered PR numbers (bottom to top)
  gh api --method POST repos/{owner}/{repo}/stacks --input - <<< '{"pull_requests":[101,102,103]}'

  # Append PR(s) to the top of an existing stack
  gh api --method POST repos/{owner}/{repo}/stacks/<stack-number>/add --input - <<< '{"pull_requests":[104]}'

  # Dissolve / unstack a stack
  gh api --method POST repos/{owner}/{repo}/stacks/<stack-number>/unstack
  ```

### Using the `gh stack` CLI extension (`github/gh-stack`)

When `gh stack` is installed (`gh extension list` or `gh extension install github/gh-stack`), it tracks stack metadata in `<git-common-dir>/gh-stack` across all linked worktrees and automates cascading rebases and atomic `--force-with-lease` pushes. Always pass non-interactive flags so `gh stack` does not open a blocking TUI:

```bash
gh stack view --json                  # Inspect current stack JSON (never run bare `gh stack view`)
gh stack checkout <stack-or-pr-num>   # Fetch and track a remote stack by stack number or PR number
gh stack sync --prune                 # Fetch, reconcile remote stack, cascade rebase, atomic push, and prune merged branches
gh stack rebase                       # Cascade rebase from trunk upward (supports --upstack, --downstack, --continue, --abort)
gh stack push                         # Atomic force-with-lease push of all active branches in the stack
gh stack link <pr-or-branch>...       # Link existing branches/PRs (bottom to top) into a GitHub stack without local tracking
gh stack merge <stack-or-pr> --yes    # Merge a stack (or up to a PR) atomically (`gh pr merge` cannot merge a stack)
```

## 2. Fetch and determine scope

Always run `git fetch origin` first (or `gh stack sync` when using `gh stack`), even if `origin` was fetched earlier in the session.

- **Named stack number ("restack #50", "update stack 50"):** Inspect the stack with `gh api repos/{owner}/{repo}/stacks/50` (or `gh stack checkout 50 && gh stack sync`).
- **Single branch ("update the branch", "rebase"):** Check the current branch's PR and whether it belongs to a stack:
  ```bash
  gh api repos/{owner}/{repo}/pulls/<pr-number> --jq '{base: .base.ref, state: .state, stack: .stack}'
  ```
- **All branches ("update all branches"):** List open PRs (`gh pr list --author @me --state open --json number,title,headRefName,baseRefName`), cross-reference with `git worktree list` (verifying each worktree's branch with `git branch --show-current`), and group chained branches from `baseRefName -> headRefName` in topological order from `main` upward.

## 3. Rebase a branch or stack without `gh stack`

When `gh stack` is not used or when rebasing manually across worktrees, process branches in topological order from the bottom of the stack (closest to `main`) upward:

| Base branch state on GitHub | Rebase action |
|---|---|
| Base is `main` (or branch has no PR) | `git rebase origin/main` |
| Base is an upstream PR branch `<parent>` that is still `OPEN` | Rebase `<parent>` first, then replay only this branch's commits onto the updated parent:<br>`git rebase --onto <parent> <old-parent-sha> HEAD` |
| Base is an upstream PR branch `<old-base>` whose PR is now `MERGED` | Replay only this branch's commits onto `origin/main` so squash-merged parent commits are not duplicated, then retarget the PR base:<br>`git rebase --onto origin/main origin/<old-base> HEAD`<br>`gh pr edit <pr-number> --base main` |

## 4. Conflicts, verification, and pushing

- **Conflict resolution:** Auto-resolve only trivial conflicts (such as import ordering or adjacent non-overlapping edits). For substantive conflicts, preserve both sides' intent when clear; if ambiguous, show the conflict and ask the user.
- **Proportional verification:**
  - **Clean rebase with no conflicts:** Run no tests, linters, or self-review; the code delta is unchanged.
  - **Trivial conflict resolution:** Inspect the resolved hunks and resulting diff without running unrelated suites.
  - **Substantive conflict resolution:** Run only the narrow tests and checks covering the resolved hunks and affected packages.
- **Push:** Push with `gh stack push` (atomic across the stack) or `git push --force-with-lease` on each updated branch. Report updated branches, retargeted PR bases, and any skipped branches.
