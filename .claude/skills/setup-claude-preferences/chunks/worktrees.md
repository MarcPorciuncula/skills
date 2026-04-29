---
id: worktrees
description: Keep the repo root on `main` (no other-branch checkouts, even read-only); any work on another branch goes in a worktree under `.claude/worktrees/<branch>/`.
---

## Worktrees

The repo root is for `main` only — never check out another branch there, not even for read-only investigation. You may pull `main` there and read or investigate `main`'s code from it. Anything else — editing on any branch, or reading, diffing, or reproducing a bug on a non-main branch — goes in a dedicated worktree under `.claude/worktrees/<branch-name>/`.

**Why:** The repo root is shared with other agents and with the user. Another session can check out a different branch at any time, and any uncommitted work left in the root is lost when that happens. Worktrees isolate your branch so nothing you've done gets dropped when someone else needs the root on a different branch.

**How to apply:** At the moment you decide to touch any file in the repo, or to look at a non-main branch — before the first action, including quick "I'm just tweaking a doc" changes or a one-off `git checkout` to read a diff — create the worktree:

```
git -C <repo-root> worktree add <repo-root>/.claude/worktrees/<branch> <base-or-new>
cd <repo-root>/.claude/worktrees/<branch>
```

Before forking a new branch, pull the latest base branch (usually `main`) so the new branch starts from current upstream — unless the base branch was already updated or built on earlier in this session, in which case trust the session state and don't re-pull.

Run any dependency install (`pnpm install`, `bundle install`, etc.) fresh in the worktree — `node_modules` and similar are not shared across worktrees.

This rule applies even when the edit is exploratory and you do not yet intend to commit. It applies to documentation, configuration, and anything else tracked by git — not just code.
