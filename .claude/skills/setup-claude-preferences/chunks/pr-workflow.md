---
id: pr-workflow
description: Per-repo PR creation behavior — open draft early, auto-flip to ready, or ask first.
---

## PR Workflow

When you push a branch with the intent of getting it reviewed, the PR-creation behavior depends on the repo. Three modes:

- `ask` — push the branch, then ask before opening a PR. The fallback for any repo not listed below.
- `draft` — open a draft PR after the first commit on the branch, push subsequent commits as you make them, and leave the PR in draft when work is complete. The user (or a reviewer) flips it to ready.
- `auto-ready` — same as `draft`, but mark the PR ready for review as soon as the work is complete and pushed.

**Default for unlisted repos is `ask`.** Never auto-create PRs in repos that aren't explicitly classified — opening a PR in an unfamiliar shared-org repo can be disruptive to other maintainers.

**How to apply:**

1. Look up the repo (by `origin` remote URL or local path) in the list below.
2. If found, follow the listed mode. If not found, use `ask`.
3. Fold the PR mode into the intent declaration required by the *Committing and Pushing* chunk — e.g. "I'll work on `feature/foo`, commit and push, and open a draft PR with auto-ready-on-completion."
4. For `draft` and `auto-ready`: open the PR as draft (`gh pr create --draft`) on the same turn as the first push. Don't wait for the work to be complete.
5. For `auto-ready`: when the work is complete and the final commit is pushed, mark the PR ready (`gh pr ready`).

**Self-update.** When the user says something like "for this repo, always open auto-ready PRs" or "stop auto-creating PRs here," edit the list below to match. Only act on explicit directives — do not infer mode changes from indirect signals.

<!-- customisable: edit the lists below per machine. Repos may be listed by `owner/name` (matched against the `origin` remote) or by absolute local path. -->

### `auto-ready`

_(none yet)_

### `draft`

_(none yet)_

### `ask`

All other repos default to `ask` — no need to list them here.
