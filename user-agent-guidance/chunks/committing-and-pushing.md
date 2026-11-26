---
id: committing-and-pushing
description: Branch declaration and default commit-and-push behavior.
---

## Committing and Pushing

- Direct requests to change tracked repository files default to commit and push unless the user says to hold changes (a hold stays active until asked to commit or a new change task starts).
- When committing and pushing, push after the first commit on a branch to open the PR eagerly, then keep intermediate commits local and push once when the requested work is complete.
- Before the first tracked-file edit, state the branch or worktree you will use and whether you will commit and push or hold changes. Omit this for read-only work or tasks outside Git.
- Before committing, run `git branch --show-current` and confirm it matches the intended branch; if not, stop and resolve it with the user.
