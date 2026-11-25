---
id: pr-workflow
description: Repository-specific pull request creation modes.
---

## PR Workflow

- Match the repository by `origin` URL or local path and apply its mode (unlisted repos default to `ask`):
  - `ask`: push the branch, then ask before creating a PR.
  - `draft`: open a draft PR immediately after the first push.
  - `auto-ready`: open a draft PR immediately after the first push, then mark it ready once requested work is complete and pushed.
- Open draft PRs on the first push without waiting for final body polish or completion self-review; run completion self-review only when requested work is done (review follow-up commits against the last reviewed head).
- Preserve an existing PR's readiness state; do not pass draft flags on updates or move a ready PR back to draft unless asked.
<!-- include the next bullet only if the `writing-pr-bodies` skill is installed on this machine. The sync agent decides whether to include it; remove it (and this comment) otherwise. -->
- Before creating a PR or updating its body, load `writing-pr-bodies`.
- Update the lists below when the user explicitly changes a repository's policy.

<!-- customisable: edit the lists below per machine. Repos may be listed by `owner/name` (matched against the `origin` remote) or by absolute local path. -->

### `auto-ready`

_(none yet)_

### `draft`

_(none yet)_

### `ask`

All other repos default to `ask`.
