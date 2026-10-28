---
name: update-branch
description: >
  Update a branch or stack of branches by rebasing onto main or updated parent
  PR branches. TRIGGER when the user says "update the branch", "update the
  stack", "rebase on main", "restack", "update branches", "update all
  branches", or similar.
---

# Update Branch and PR Stacks

Update a single branch or a stack of dependent PR branches using native `git` and GitHub PR base relationships. Do not ask for confirmation before force-pushing; requesting a branch update authorizes `git push --force-with-lease`.

## 1. Fetch latest remote refs

Always run `git fetch origin` first, even if `origin` was fetched earlier in the session. Never trust a local "already up to date" message before fetching and checking whether the PR's base branch was merged on GitHub.

## 2. Determine scope and stack topology

Inspect open PRs and their base-branch chain on GitHub:

- **Single branch:** Check the current branch's PR state and base branch:
  ```bash
  gh pr view --json number,headRefName,baseRefName,state
  ```
- **All branches or a stack ("update branches", "update the stack", "restack"):**
  1. List your open PRs and their base relationships:
     ```bash
     gh pr list --author @me --state open --json number,title,headRefName,baseRefName
     ```
  2. Cross-reference with `git worktree list` (verify each worktree's checked-out branch with `git branch --show-current`, as directory names can drift from checked-out branches). Report any open PR branch that has no local worktree.
  3. Build the dependency DAG from `baseRefName -> headRefName`. Order each stack topologically from the branch closest to `main` upward so parent branches are rebased before their children.

## 3. Rebase each branch in topological order

For each branch (working from the bottom of a stack upward in its respective worktree):

| Base branch state on GitHub | Rebase action |
|---|---|
| Base is `main` (or branch has no PR) | `git rebase origin/main` |
| Base is another PR branch `<parent>` that is still `OPEN` | First update `<parent>`, then replay only this branch's commits onto the updated parent: `git rebase --onto <parent> <old-parent-sha> HEAD` (or `git rebase origin/<parent>`) |
| Base is another PR branch `<old-base>` whose PR is now `MERGED` | Replay only this branch's commits onto `origin/main` so squash-merged parent commits are not duplicated, then retarget the PR base on GitHub:<br>`git rebase --onto origin/main origin/<old-base> HEAD`<br>`gh pr edit <number> --base main` |

## 4. Handle conflicts, verification, and pushing

- **Conflict resolution:** Auto-resolve only trivial conflicts (such as import ordering or adjacent non-overlapping edits). For substantive conflicts, preserve both sides' intent when clear; if ambiguous, show the conflict and ask the user. If a rebase conflict across many commits is intractable, `git rebase --abort` and use `git merge` instead.
- **Proportional verification:**
  - **Clean rebase with no conflicts:** Run no tests, linters, or self-review; the code delta is unchanged.
  - **Trivial conflict resolution:** Inspect the resolved hunks and resulting diff without running unrelated suites.
  - **Substantive conflict resolution:** Run only the narrow tests and checks covering the resolved hunks and affected packages.
- **Push:** Push each updated branch with `git push --force-with-lease`. When updating multiple branches, report a concise summary of updated branches, retargeted PR bases, and any skipped branches.
