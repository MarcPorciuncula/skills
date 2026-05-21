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
  3. Group branches into stacks. `git-spice ls` may be empty on a fresh clone, so do not rely on it alone — also group by PR base relationships, where a branch whose PR base is another open PR branch belongs to that branch's stack (see the git-spice detection in Step 3). Branches in the same stack are updated as a single unit. Standalone branches are each their own group.
  4. Apply Step 3 to each group. For git-spice stacks, only process once per stack (not per branch).
  5. Report a summary: which branches were updated, which were skipped (and why), and any errors.

## Step 3: Update a branch/stack

### Detect git-spice management — do not trust `git-spice ls` alone

git-spice's local state is empty on a fresh clone, so a branch missing from `git-spice ls` is not proof the stack is unmanaged. Check both signals:

1. Run `git-spice ls`. If the branch appears, the stack is tracked locally.
2. If it does not appear, check the branch's PR for the git-spice stack-navigation comment — the comment git-spice posts listing every branch in the stack (`gh pr view --comments`). Its presence means the stack is git-spice managed and only the local state is missing.

### Use git-spice for any stack of 3+ branches

A stack of 3+ branches MUST be updated with git-spice. The manual rebase flow is far too slow at that size. Determine the stack size from the navigation comment if present, otherwise by following the PR base chain (`gh pr view --json baseRefName` on each branch up the chain).

If the stack is 3+ branches and the local git-spice state is missing, adopt it into git-spice before restacking: starting from the branch closest to `main` and working up, run `git-spice branch track --base <base-branch>` for each branch. Then follow the Git-spice managed flow.

### Git-spice managed

Run `git-spice repo sync` (ensures git-spice internal state is updated), then `git-spice upstack restack` (to restack from the current branch upward) or `git-spice stack restack` (to restack the entire stack), then `git-spice stack submit --update-only`.

- **If `git-spice repo sync` fails** (common in bare repo + worktree setups), continue with restacking — the fetch in Step 1 already updated the remote refs.
- **If restacking skips branches checked out in other worktrees:** `git-spice upstack restack` will skip branches checked out in other worktrees. To handle this:
  1. Start from the bottom of the stack and work up.
  2. For each branch that was skipped, `cd` into the worktree that has it checked out and run `git-spice branch restack` there.
  3. **Worktree names may not match branch names** — agents frequently check out different branches in worktrees. Use `git branch --show-current` to verify which branch a worktree actually has, and `git checkout <correct-branch>` to fix mismatches before restacking.
  4. If a worktree has no dirty changes and isn't needed, you can also remove it with `git worktree remove <path>` and then restack from elsewhere.
- **If restacking reports a stash error but the working tree is clean:** git-spice sometimes reports "Dirty changes in the worktree were stashed, but could not be re-applied" even when the rebase succeeded and the working tree is clean. This is a cosmetic error. Verify with `git status` — if the branch has diverged from its remote tracking branch and the working tree is clean, the restack succeeded despite the error. Continue with the next step.

### Normal branch

Use this flow only for a standalone branch or a 1-2 branch stack with no git-spice management. Any stack of 3+ branches uses the Git-spice managed flow.

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

## Red Flags — Stop

| Thought | Reality |
|---------|---------|
| "The rebase reported 'already up to date' — done" | The tracking ref may be stale. Verify the base branch hasn't been merged and moved underneath this one. |
| "The base branch hasn't changed, I can skip the PR check" | A branch that hasn't changed in diff can still have been merged into main. Check PR state, not just the diff. |
| "`git-spice ls` doesn't list this branch, so it's a normal branch — rebase it manually" | git-spice's local state is empty on a fresh clone. Check the PR for the stack-navigation comment before deciding the stack is unmanaged. |

## Conflict resolution

- Only auto-resolve conflicts that are completely trivial (e.g. import ordering, adjacent non-overlapping edits).
- For anything substantive, evaluate the intent of both sides and preserve both when possible.
- When in doubt, show the conflict to the user and ask how to proceed.
