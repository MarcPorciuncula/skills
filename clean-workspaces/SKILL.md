---
name: clean-workspaces
description: >
  Clean up worktrees for branches that have been merged. Use when the user says
  "clean up workspaces", "clean up worktrees", or similar.
---

# Clean Up Workspaces

**NEVER remove slot-based worktrees** (those ending in `-a`, `-b`, etc., e.g. `operator-ui-a`, `alcova-backend-b`). They are long-lived infrastructure. No merged PR, old age, or user phrasing justifies removing them automatically.

**NEVER force-remove a worktree with uncommitted changes.** Doing so permanently destroys that work. Always warn and skip.

## Red Flags — Stop

If you find yourself thinking any of these, stop:

| Thought | Reality |
|---------|---------|
| "This worktree looks old/unused, I'll remove it" | Only a confirmed merged PR justifies removal. Age and appearance are not signals. |
| "It ends in `-a` but seems abandoned" | Slot-based worktrees are never removed automatically. Full stop. |
| "The user said clean up everything" | "Everything" means all *eligible* worktrees — slots are never eligible. |
| "There are uncommitted changes but they look trivial" | You cannot know that. Warn and skip — always. |

## Steps

1. **List all worktrees** with `git worktree list`.

2. **Identify slot-based worktrees** — those matching `<repo-name>-a`, `<repo-name>-b`, etc. Mark them as permanently excluded. Do not evaluate them further.

3. **For each dedicated (branch-named) worktree**, check if its branch has been merged by looking for a merged PR on GitHub:
   - Run `gh pr list --head <branch-name> --state merged --json number,title --limit 1`
   - If a merged PR is found, the worktree is eligible for cleanup.

4. **Before removing each eligible worktree**, check for uncommitted changes:
   - If the worktree has uncommitted changes, warn the user and skip it — do not force-remove.
   - If clean, run `git worktree remove <worktree-path>`.

5. **Delete the local branch** after removing the worktree: `git branch -d <branch-name>`.

6. **Report** a summary of what was cleaned up and what was skipped (and why).
