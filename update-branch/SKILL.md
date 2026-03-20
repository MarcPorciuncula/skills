---
name: update-branch
description: >
  Update branches by rebasing on main or restacking git-spice stacks.
  Use when the user says "update the branch", "update the stack", "rebase on main",
  "restack", "restack the stack", "update branches", "update all branches",
  "restack all branches", or similar. Handles both single-branch and batch updates.
---

# Update Branch(es)

Handles both updating the current branch and batch-updating all branches with open PRs.

## Step 1: Always fetch latest

Run `git fetch origin` before doing anything else. **This is mandatory even if the branch was already updated earlier in the conversation** — the remote may have changed since then. Never skip this step.

## Step 2: Determine scope

- **Single branch** (user says "update the branch", "restack", etc.): Update just the current branch/stack. Proceed to Step 3.
- **All branches** (user says "update branches", "update all branches", etc.): Discover branches first:
  1. List open PRs via `gh pr list --author @me --state open --json number,title,headRefName`.
  2. Cross-reference with `git worktree list` — only branches with a worktree can be updated. Report any PR branches without a worktree.
  3. Group branches by git-spice stack: for each branch with a worktree, run `gs ls` from within that worktree. If multiple PR branches belong to the same stack, group them — they'll be updated as a single unit. Standalone branches are each their own group.
  4. Apply Step 3 to each group. For git-spice stacks, only process once per stack (not per branch).
  5. Report a summary: which branches were updated, which were skipped (and why), and any errors.

## Step 3: Update a branch/stack

**Determine if the branch is managed by git-spice** by running `gs ls` — if the current branch appears in the output, it's git-spice managed.

### Git-spice managed

Run `gs repo sync` (ensures git-spice internal state is updated), then `gs upstack restack` (to restack from the current branch upward) or `gs stack restack` (to restack the entire stack), then `gs stack submit --update-only`.

- **If `gs repo sync` fails** (common in bare repo + worktree setups), continue with restacking — the fetch in Step 1 already updated the remote refs.
- **If restacking fails because a branch is checked out in another worktree:** Git cannot rebase a branch that's checked out elsewhere. To resolve:
  1. Run `git worktree list` to find which worktree has the conflicting branch.
  2. Check if that worktree is actively being worked on (dirty working tree, uncommitted changes).
  3. **If not actively used:** Remove it with `git worktree remove <worktree-path>`, then retry the restack.
  4. **If actively used:** `cd` into that worktree and run `gs branch restack` there to restack just that branch in place, then return to the original worktree and continue.

### Normal branch

**Determine the base branch.** Check if the branch has a PR and what its base is:
```bash
gh pr view --json baseRefName,state
```

- **If the PR base is `main`:** rebase on `origin/main`.
- **If the PR base is another branch:** check whether that base branch's PR has been merged (`gh pr list --head <base-branch> --state merged`). If merged, the base is now `main` — rebase onto `origin/main` using `--onto` to avoid replaying the base branch's commits:
  ```bash
  git rebase --onto origin/main origin/<old-base-branch> HEAD
  ```
- **If the base branch is still open:** rebase on `origin/<base-branch>`.
- **If there's no PR:** default to `origin/main`.

**The user asking to update is itself a signal** — don't short-circuit with "already up to date" without verifying the base branch still exists and hasn't been merged. A branch can appear up-to-date with its tracking ref while its base has moved underneath it.

After rebasing:
- If rebase conflicts look non-trivial, abort and `git merge` instead.
- Push with `git push --force-with-lease`.

## Pushing

Do not ask for confirmation — the user has already authorized pushing by requesting the update. Force pushes use `--force-with-lease` and the local reflog serves as a safety net.

## Conflict resolution

- Only auto-resolve conflicts that are completely trivial (e.g. import ordering, adjacent non-overlapping edits).
- For anything substantive, evaluate the intent of both sides and preserve both when possible.
- When in doubt, show the conflict to the user and ask how to proceed.
