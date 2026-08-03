---
id: pr-workflow
description: Repository-specific pull request creation modes.
---

## PR Workflow

PR mode controls creation and, for `auto-ready`, one completion transition. It is not a persistent desired state for an existing PR.

- `ask` — push the branch, then ask before creating a PR.
- `draft` — create a draft PR after the first push.
- `auto-ready` — create a draft PR after the first push, then mark it ready once the requested work is complete and pushed.

When a repository is not listed below, use `ask`. Opening a PR in an unfamiliar shared repository is externally visible and may affect other maintainers.

When creating a PR:

1. Match the repository by `origin` URL or local path.
2. Apply its listed mode, or `ask` when unlisted.
3. For `draft` and `auto-ready`, create the PR with the draft flag after the first push.
4. For `auto-ready`, mark it ready at completion only if it is still draft. An already-ready PR needs no action.

When a PR already exists, treat its current state as authoritative. Do not pass draft flags while editing, pushing, rebasing, or changing metadata. Do not move a ready PR back to draft unless the user explicitly asks. Do not repeatedly report that a PR remains draft. A later external readiness change is not drift to correct.

<!-- include the next line only if the `writing-pr-bodies` skill is installed on this machine. The sync agent decides whether to include it; remove it (and this comment) otherwise. -->
**PR body authoring.** Before creating a PR or updating its body, invoke the `writing-pr-bodies` skill.

When the user explicitly changes a repository's policy, update the lists. Do not infer policy changes from indirect signals.

<!-- customisable: edit the lists below per machine. Repos may be listed by `owner/name` (matched against the `origin` remote) or by absolute local path. -->

### `auto-ready`

_(none yet)_

### `draft`

_(none yet)_

### `ask`

All other repos default to `ask`.
