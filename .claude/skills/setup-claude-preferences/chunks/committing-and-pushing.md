---
id: committing-and-pushing
description: Default to commit and push on direct work requests; declare intent and confirm branch first.
---

## Committing and Pushing

**Default: commit and push.** When the user directs work ("go ahead", "implement it", "proceed", "make that change", or any direct request without questions), complete the work, commit, and push without asking.

**Exception: "don't commit yet"** (or similar). Keep changes in the working tree. This holds until the user asks to commit or gives a new task.

**When a message mixes a request with a question or clarification**, the question takes priority. Answer or clarify first — don't start executing. The user may be setting context or planning, not giving the green light.

**Before committing, verify you're on the expected branch.** Run `git branch --show-current` and confirm it matches the branch you intended to work on. If it doesn't, stop and ask the user.

**Declare intent immediately.** Before your first tool call in any response where you're doing work, your very first words must state the branch you're on, whether you will commit and push or hold changes, and the PR mode (see the *PR Workflow* chunk):
- "I'll work on this on `feature/foo`, commit and push, and open a draft PR with auto-ready-on-completion."
- "I'll work on this on `feature/foo`, commit and push, then ask before opening a PR."
- "I'll work on this on `main` and hold the changes for approval."

This gives the user the opportunity to redirect before any work begins. Do not ask "should I commit?" when the user's message was a direction — that's asking for permission to comply.
