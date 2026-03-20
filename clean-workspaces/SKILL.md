---
name: clean-workspaces
description: >
  Clean up worktrees for branches that have been merged. Use when the user says
  "clean up workspaces", "clean up worktrees", or similar.
---

# Clean Up Workspaces

1. **List all worktrees** with `git worktree list`.

2. **Skip slot-based worktrees** — these follow the pattern `<repo-name>-a`, `<repo-name>-b`, etc. (e.g. `operator-ui-a`, `alcova-backend-b`). They are long-lived and should never be removed automatically.

3. **For each dedicated (branch-named) worktree**, check if its branch has been merged by looking for a merged PR on GitHub:
   - Run `gh pr list --head <branch-name> --state merged --json number,title --limit 1`
   - If a merged PR is found, the worktree is eligible for cleanup.

4. **Remove eligible worktrees:**
   - `git worktree remove <worktree-path>`
   - If the worktree has uncommitted changes, warn the user and skip it rather than force-removing.

5. **Delete the local branch** after removing the worktree: `git branch -d <branch-name>`.

6. **Report** a summary of what was cleaned up and what was skipped (and why).
