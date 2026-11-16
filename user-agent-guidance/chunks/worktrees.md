---
id: worktrees
description: Shared-repository worktree workflow.
---

## Worktrees

Keep the repository root on `main`. Never check out another branch there, including for read-only investigation.

Before editing tracked files or inspecting, diffing, or reproducing behavior on a non-main branch, create a dedicated worktree under `.claude/worktrees/<branch-name>/` and work there. This includes exploratory edits, documentation, and configuration.

```bash
git -C <repo-root> worktree add <repo-root>/.claude/worktrees/<branch> <base-or-new>
cd <repo-root>/.claude/worktrees/<branch>
```

When creating a new branch, update its base first unless the base was already updated in this session. When a worktree needs dependencies, install them in that worktree; dependency directories are not shared.

The shared root may be read on `main` and updated with a fast-forward pull. All other branch activity stays isolated.
