---
name: babysit-pr
description: >
  Watch a pull request over time and keep it healthy: address new review
  comments and rebase the branch when it goes stale. TRIGGER when the user says
  "babysit this PR", "watch this PR", "keep this PR mergeable", "tend the PR",
  or asks for an ongoing watch on a PR rather than a one-off pass. SKIP for a
  single "address review comments" pass (use address-review if available) or a
  single "update the branch" pass (use update-branch if available) with no
  ongoing watch.
---

# Babysit a PR

Keep an open pull request healthy across recurring loop iterations. In each iteration, check the live PR state from GitHub (never rely on memory from prior iterations), delegate new review threads to `address-review` (if available), delegate branch staleness to `update-branch` (if available), and report a one-line status update.

Never edit code, post review replies, resolve threads, or rebase inline inside `babysit-pr`; always delegate mutations to `address-review` and `update-branch` so their allowlist, attribution, and rebase rules are enforced. If either composed skill is unavailable when its signal fires, report the pending action and skip that mutation.

## Loop iteration steps

### 1. Read the PR lifecycle state

Resolve the PR from the user's argument or the current branch:

```bash
gh pr view <pr> --json number,state,isDraft,headRefName,baseRefName,mergeable,mergeStateStatus,url
```

- **`state` is `MERGED` or `CLOSED`:** Stop the loop and report completion.
- **PR is in a merge queue (`state: OPEN`):** Keep watching. A queued PR can still be evicted if a check fails or the base branch advances; only exit on `MERGED` or `CLOSED`.
- **`isDraft: true`:** Keep watching; automated reviewers and humans still comment on drafts.

### 2. Check the two action signals cheaply

Before loading `address-review` or `update-branch`, check whether either has work:

1. **Unresolved review activity:** Check for unresolved review threads via `gh pr view <pr> --comments` or `address-review`'s `fetch-review-comments.sh`. If unresolved threads exist, mark the review signal active (`address-review` determines whether threads are already dealt with).
2. **Branch staleness:** Check both staleness signals independently:
   - **Behind base (`behind_by > 0`):** Query the compare API directly:
     ```bash
     gh api "repos/{owner}/{repo}/compare/<baseRefName>...<headRefName>" --jq '.behind_by'
     ```
     Never infer behind-base status from `mergeStateStatus`: `BLOCKED` and `UNSTABLE` outrank `BEHIND` in GitHub's single precedence enum and mask that a branch is behind its base.
   - **Conflicting with base:** `mergeStateStatus: DIRTY` or `mergeable: CONFLICTING`. (If `mergeable: UNKNOWN`, GitHub is still computing mergeability; skip the conflict check for this tick while still honouring `behind_by`.)

If neither signal fires, skip steps 3 and 4 and report status.

### 3. Address review comments first

When step 2 detects unresolved review threads, invoke `address-review` in address mode:

- Let `address-review` classify dealt-with vs. not-dealt-with threads, apply its reviewer reply allowlist, post attributed replies, and resolve eligible threads.
- If `address-review` surfaces threads requiring human reply or a product decision in `Needs your attention`, preserve that handoff for step 6.

### 4. Update the branch second

When step 2 detects that the branch is behind or conflicting with its base, invoke `update-branch` *after* step 3 so any commits pushed by `address-review` are included in the rebase. If `update-branch` hits an ambiguous conflict it cannot safely resolve, stop and surface the conflict to the user.

### 5. Report iteration status

Output one concise status line covering: review comments addressed (or none pending), branch rebase status, current CI/mergeability state, and any items requiring user action.

### 6. Schedule the next check (self-paced loops)

When running under a self-paced loop, **re-run the step 2 signal checks before sleeping**. Steps 3 and 4 take several minutes, during which new bot comments or base-branch commits frequently land; sleeping without re-checking delays already-queued work.

| Fresh re-read state | Next action |
|---|---|
| New review threads or base commits arrived during steps 3 to 4 | Start the next iteration immediately |
| Comments were just addressed, branch was just rebased, or CI is still running | Short wait (a few minutes) |
| No pending signals, branch is current, and CI is green | Long wait (up to 1 hour) |
| Blocked on human action (non-allowlisted reviewer reply needed, open design decision, or unresolvable rebase conflict) | Report the blocker, send a notification if configured, and exit the loop |
| PR is `MERGED` or `CLOSED` | Exit the loop |
