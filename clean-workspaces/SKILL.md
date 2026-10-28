---
name: clean-workspaces
description: >
  Clean up git worktrees and local branches for pull requests that have been
  merged. TRIGGER when the user says "clean up workspaces", "clean up
  worktrees", or similar.
---

# Clean Up Workspaces

Remove branch-specific worktrees whose pull requests are confirmed `MERGED` on GitHub, while protecting permanent slot worktrees and uncommitted work.

## Safety invariants

- **Never remove slot-based worktrees:** Worktrees named `<repo>-a`, `<repo>-b`, etc. (such as `web-a` or `api-b`) are permanent reusable slots. Exclude them unconditionally regardless of branch state, age, or user phrasing ("clean up everything").
- **Never force-remove dirty worktrees:** If an eligible worktree has uncommitted or untracked changes, warn the user and skip it. Never pass `--force` to `git worktree remove`.

## Procedure

1. **List worktrees:** Run `git worktree list` and exclude the primary checkout and any slot-based worktrees (`*-a`, `*-b`, etc.).
2. **Verify merged PR status:** For each remaining branch worktree, confirm its branch has a merged PR on GitHub:
   ```bash
   gh pr list --head <branch-name> --state merged --json number,title --limit 1
   ```
   Skip worktrees whose branch has no merged PR (age or inactivity alone never justifies removal).
3. **Check cleanliness and remove:** For each worktree with a confirmed merged PR, check `git -C <worktree-path> status --porcelain`:
   - If non-empty, warn the user and skip the worktree.
   - If clean, run `git worktree remove <worktree-path>` and delete the local branch with `git branch -d <branch-name>`.
4. **Report:** Summarize which worktrees and branches were removed and which were skipped (with reasons).
