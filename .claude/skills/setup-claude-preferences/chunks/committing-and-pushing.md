---
id: committing-and-pushing
description: Repository commit and push workflow.
---

## Committing and Pushing

For a direct request to change tracked repository files, commit and push the completed work unless the user says to hold changes.

A question does not cancel an accompanying implementation request. Answer it first when it controls the implementation; otherwise complete both. Do not treat explanatory wording in a direct change request as uncertainty about authorization.

Inspect the repository before declaring a branch plan. Before the first tracked-file edit, state the branch or worktree you will use and whether you will commit and push or hold changes. Do not make a branch declaration for read-only work, including read-only worktree setup, or for tasks outside a Git repository. PR creation behavior is separate and does not belong in this declaration.

Before committing, run `git branch --show-current` and confirm it is the intended branch. If it is not, stop and resolve the mismatch with the user.

A request to hold changes remains in effect until the user asks to commit or assigns a new change task.
