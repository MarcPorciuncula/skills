---
id: worktrees
description: Shared-repository worktree workflow.
---

## Worktrees

- Keep the repository root on `main`; never check out another branch there, even for read-only work.
- Before editing tracked files or inspecting, diffing, or reproducing behavior on a non-`main` branch, create a worktree under `.claude/worktrees/<branch-name>/` and work there:
  ```bash
  git -C <repo-root> worktree add <repo-root>/.claude/worktrees/<branch> <base-or-new>
  ```
- Update the base branch before creating a new branch unless already updated this session. Install dependencies inside the worktree.
