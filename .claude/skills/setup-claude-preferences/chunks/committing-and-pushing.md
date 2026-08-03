---
id: committing-and-pushing
description: Repository commit and push workflow.
---

## Committing and Pushing

For a direct request to change tracked repository files, commit and push the completed work unless the user says to hold changes.

When a message combines a question with an implementation request, complete both. Answer the question first when it controls the implementation. Do not treat explanatory wording in a direct change request as uncertainty about authorization.

When a requested action may change tracked repository files, inspect the repository before running it. Before the first tracked-file edit, state the branch or worktree you will use and whether you will commit and push or hold changes. Do not make a branch declaration for read-only work, including read-only worktree setup, or for tasks outside a Git repository. PR creation behavior is separate and does not belong in this declaration.

Before committing, run `git branch --show-current` and confirm it is the intended branch. If it is not, stop and resolve the mismatch with the user.

A request to hold changes remains in effect until the user asks to commit or assigns a new change task.
