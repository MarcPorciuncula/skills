---
name: update-branch
description: >
  Update a branch or stack of branches by rebasing onto main or updated parent
  PR branches. TRIGGER when the user says "update the branch", "update the
  stack", "rebase on main", "restack", "restack stack #N", "update branches",
  "update all branches", or similar.
---

# Update Branch and PR Stacks

Update a single branch, a chain of base-linked PRs, or a GitHub native Stack (`github.com/<owner>/<repo>/stack/<number>`). Do not ask for confirmation before force-pushing; requesting a branch update authorizes `git push --force-with-lease` (or `gh stack sync` / `gh stack push`).

If the user references a GitHub native stack number (`stack #50`, `/stack/50`) or asks to manage a native stack, load `github-stacks` (if available). Never pass a stack number to `gh pr view <number>`; stack numbers share the repository's issue/PR sequence but must be queried via `gh api repos/{owner}/{repo}/stacks/<stack-number>` or `gh stack`.

## 1. Fetch and resolve scope

Always run `git fetch origin` first, even if `origin` was fetched earlier in the session.

- **Named GitHub native stack ("restack stack #50", "update stack 50"):**
  Query the stack's ordered PR list (bottom to top) via the Stacks API:
  ```bash
  gh api repos/{owner}/{repo}/stacks/<stack-number> --jq '{base: .base.ref, prs: [.pull_requests[] | {number, state, branch: .head.ref}]}'
  ```
  (If the `gh stack` CLI extension is installed and tracking the stack in a clean worktree, you can also run `gh stack checkout <stack-number> && gh stack sync --prune`.)
- **Single branch ("update the branch", "rebase"):**
  Check the current branch's PR base, state, and whether it belongs to a native stack:
  ```bash
  gh pr view --json number,headRefName,baseRefName,state
  ```
- **All branches or base-chained stack ("update branches", "update the stack", "restack"):**
  1. List open PRs: `gh pr list --author @me --state open --json number,title,headRefName,baseRefName`.
  2. Cross-reference with `git worktree list` (verifying each worktree's actual branch via `git branch --show-current`). Report any open PR branch without a worktree.
  3. Build the dependency DAG from `baseRefName -> headRefName` and order branches topologically from `main` upward so parent branches are updated before their children.

## 2. Rebase each branch in topological order

Work from the bottom of the chain (closest to `main`) upward in each branch's worktree:

| Base branch state on GitHub | Rebase action |
|---|---|
| Base is `main` (or branch has no PR) | `git rebase origin/main` |
| Base is an upstream PR branch `<parent>` that is still `OPEN` | Rebase `<parent>` first, then replay only this branch's commits onto the updated parent:<br>`git rebase --onto <parent> <old-parent-sha> HEAD` |
| Base is an upstream PR branch `<old-base>` whose PR is now `MERGED` | Replay only this branch's commits onto `origin/main` so squash-merged parent commits are not duplicated, then retarget the PR base:<br>`git rebase --onto origin/main origin/<old-base> HEAD`<br>`gh pr edit <pr-number> --base main` |

## 3. Handle conflicts, verification, and pushing

- **Conflict resolution:** Auto-resolve only trivial conflicts (such as import ordering or adjacent non-overlapping edits). For substantive conflicts, preserve both sides' intent when clear; if ambiguous, show the conflict and ask the user. If a rebase across many commits is intractable, `git rebase --abort` and `git merge` instead.
- **Proportional verification:**
  - **Clean rebase with no conflicts:** Run no tests, linters, or self-review; the code delta is unchanged.
  - **Trivial conflict resolution:** Inspect the resolved hunks and resulting diff without running unrelated suites.
  - **Substantive conflict resolution:** Run only the narrow tests and checks covering the resolved hunks and affected packages.
- **Push:** Push each updated branch with `git push --force-with-lease` (or `gh stack push` when using `gh stack`). Report updated branches, retargeted PR bases, and any skipped branches.
