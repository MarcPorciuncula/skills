---
id: worktrees
description: Reserve the main clone for `main`; any edit goes in a dedicated worktree under `.claude/worktrees/<branch>/`.
---

## Worktrees

The main repo clone at `~/work/<repo>` is for `main` only. You may pull `main` there and read or investigate code from it. Any edit — code, docs, config, anything tracked by git — goes in a dedicated worktree under `.claude/worktrees/<branch-name>/`, created before the first edit.

**Why:** The main clone is shared with other agents and with the user. Another session can check out a different branch at any time, and any uncommitted work left in the main clone is lost when that happens. Worktrees isolate your branch so nothing you've done gets dropped when someone else needs the main clone on a different branch.

**How to apply:** At the moment you decide to touch any file in the repo — before the first edit, including quick "I'm just tweaking a doc" changes — create the worktree:

```
git -C <repo-root> worktree add <repo-root>/.claude/worktrees/<branch> <base-or-new>
cd <repo-root>/.claude/worktrees/<branch>
```

Run any dependency install (`pnpm install`, `bundle install`, etc.) fresh in the worktree — `node_modules` and similar are not shared across worktrees.

This rule applies even when the edit is exploratory and you do not yet intend to commit. It applies to documentation, configuration, and anything else tracked by git — not just code.
