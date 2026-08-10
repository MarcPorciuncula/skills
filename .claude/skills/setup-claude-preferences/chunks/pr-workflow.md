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
3. For `draft` and `auto-ready`, create the PR with the draft flag immediately after the first push.
4. For `auto-ready`, mark it ready at completion only if it is still draft. An already-ready PR needs no action.

A first push is a transport checkpoint. For `draft` and `auto-ready`, do not
start final-body review, completion-oriented self-review, or review-driven fixes
after that push until the draft PR exists. Resolve only conditions that prevent
a meaningful or safe push, such as invalid branch ancestry, unresolved
conflicts, or exposed secrets. Incomplete work and ordinary defects belong in
the draft and its later commits.

A draft PR created or updated while planned implementation remains is a work-in-progress transport checkpoint, not a completed submission or request for human review. Do not run completion-oriented self-review solely for that action. Run it when the requested work is complete and the PR is handed off, before marking the PR ready or requesting human review, or when the user explicitly requests self-review. If repository guidance also triggers self-review before first PR creation, this preference overrides that timing only for a work-in-progress draft.

After a whole-branch submission review, review follow-up commits against the
last reviewed head and their affected paths. Repeat the whole-branch review only
when those commits invalidate its scope or cross a new responsibility, runtime,
compatibility, or safety boundary.

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
