---
id: pr-workflow
description: Repository-specific pull request creation modes.
---

## PR Workflow

PR mode controls creation and, for `auto-ready`, one completion transition:

- `ask`: push the branch, then ask before creating a PR.
- `draft`: create a draft PR after the first push.
- `auto-ready`: create a draft PR after the first push, then mark it ready once requested work is complete and pushed.

When a repository is not listed below, use `ask`.

When creating a PR:

1. Match the repository by `origin` URL or local path. Apply its listed mode, or `ask` when unlisted.
2. For `draft` and `auto-ready`, create the PR with the draft flag immediately after the first push.
3. For `auto-ready`, mark it ready at completion only if it is still draft. An already-ready PR needs no action.

Treat initial and work-in-progress pushes as transport checkpoints. For `draft` and `auto-ready`, open the draft PR immediately after the first push; do not delay creation for final body review, completion-oriented self-review, or polish. Incomplete work and routine defects belong in the draft and subsequent commits.

Run completion-oriented self-review only when the requested work is complete, before marking the PR ready or handing off to the user. Review follow-up commits against the last reviewed head and affected paths rather than repeating whole-branch review.

Treat an existing PR's current readiness state as authoritative. Do not pass draft flags while editing, pushing, rebasing, or updating metadata. Do not move a ready PR back to draft unless explicitly asked.

<!-- include the next line only if the `writing-pr-bodies` skill is installed on this machine. The sync agent decides whether to include it; remove it (and this comment) otherwise. -->
**PR body authoring.** Before creating a PR or updating its body, invoke the `writing-pr-bodies` skill.

When the user explicitly changes a repository's policy, update the lists below.

<!-- customisable: edit the lists below per machine. Repos may be listed by `owner/name` (matched against the `origin` remote) or by absolute local path. -->

### `auto-ready`

_(none yet)_

### `draft`

_(none yet)_

### `ask`

All other repos default to `ask`.
