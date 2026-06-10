---
name: babysit-pr
description: >
  Watch a pull request over time and keep it healthy: address new bot
  review comments and rebase the branch when it goes stale. Use when the
  user says "babysit this PR", "watch this PR", "keep this PR mergeable",
  "tend the PR", "keep the branch up to date", or asks for an ongoing
  watch on a PR rather than a one-off pass. SKIP for a single "address
  review comments" pass (use address-review) or a single "update the
  branch" (use update-branch) with no ongoing watch.
---

# Babysit a PR

Keep one PR healthy over time. Each iteration: address new bot review
comments via the address-review skill, rebase the branch via the
update-branch skill when it has gone stale, then report.

This skill is the loop *body*. It runs under an in-session `/loop`,
covered at the end.

## Iron Law

NO PR MUTATION EXCEPT THROUGH THE COMPOSED SKILLS.

babysit-pr does not edit code, reply to comments, resolve threads, or
rebase on its own. Every change to the PR goes through the address-review
skill or the update-branch skill. Those skills carry the gates that keep
this safe — the reviewer allowlist, the attribution labels, the
analysis-table gate, the fetch-before-rebase rule. Reimplementing their
work here bypasses those gates and posts or pushes things it should not.

## Each run reads state from the PR, not from memory

A loop iteration starts fresh. It may have no memory of prior iterations
once context is summarised between them. Determine everything from the PR
itself: mergeability, unresolved threads, CI, merge/close state. Never
assume work from a previous iteration is done or not done.

## Loop body

Run these steps in order, every iteration.

### 1. Resolve the PR

Take the PR from the user's argument, or fall back to the current
branch's PR. Confirm it exists and read its state in one query:

```bash
gh pr view <pr> --json number,state,isDraft,headRefName,baseRefName,mergeable,mergeStateStatus,url
```

- DO stop the loop if `state` is `MERGED` or `CLOSED`. Report it done. Nothing left to babysit.
- DO keep babysitting a PR sitting in a merge queue. A queued PR is still `OPEN` and can be knocked back if a required check fails or the base advances. Only `state: MERGED` means it landed — exit on that, not on "queued".
- DO treat `mergeable: UNKNOWN` as "GitHub is still computing" — skip the staleness check this iteration, re-read next time. Do not act on UNKNOWN.
- DO keep babysitting a `DRAFT` PR. Bots still comment on drafts.

### 2. Gather the two signals cheaply

Before invoking the heavy skills, check whether either has work to do.

- **New review activity** — are there unresolved review threads? Check with `gh pr view <pr> --comments`, or reuse address-review's fetch scripts. Presence of unresolved threads is the signal; the dealt-with analysis belongs to address-review, not here.
- **Branch staleness** — read `mergeStateStatus` from step 1:

  | `mergeStateStatus` | Meaning | Action |
  |---|---|---|
  | `BEHIND` | Base branch advanced; head is out of date | Update the branch |
  | `DIRTY` | Merge conflict with base | Update the branch |
  | `CLEAN`, `UNSTABLE`, `BLOCKED`, `HAS_HOOKS` | Up to date with base | Leave the branch alone |

  `mergeable: CONFLICTING` is the same signal as `DIRTY` — update the branch.

If neither signal fires, skip to the report. Do not invoke the composed skills with no work for them.

### 3. Address new bot review comments

When step 2 found unresolved threads, invoke the address-review skill in
address mode (analyze, then execute). Delegate completely:

- DO let address-review decide which threads are not-dealt-with, which to reply to, and which to resolve. It owns that logic.
- DO let address-review apply its reviewer allowlist and attribution labels. A thread from an author it cannot auto-reply to is handed back for the user — that is correct, not a failure to fix.
- DO NOT pre-filter, reply, or resolve threads yourself. That is an Iron Law violation.

### 4. Update the branch if it went stale

When step 2 flagged the branch `BEHIND`, `DIRTY`, or `CONFLICTING`,
invoke the update-branch skill for the current branch. Run this *after*
step 3 so any commits address-review just pushed are included in the
rebase.

- DO let update-branch handle the rebase-or-restack decision and the git-spice detection.
- DO stop and surface to the user if update-branch reports a conflict it cannot resolve cleanly. Do not force or guess a resolution.

### 5. Report

One concise status line per iteration. Cover: comments addressed (or
none pending), branch updated (or already current), current
mergeability/CI, and anything handed back for the user.

### 6. Pick the next cadence (self-paced runner only)

When the runner lets you choose the next wake-up (a `/loop` with no fixed
interval), re-read the step 2 signals first, then set the wait from that
fresh read.

**Re-read before you wait.** Steps 3–4 take minutes. New bot comments or a
freshly-advanced base can land while address-review or update-branch runs, so
the signals you gathered in step 2 are stale by the time you reach here.
Re-run the step 2 checks. If either signal fires, start the next iteration now
instead of waiting. A long sleep here misses work already queued.

Set the wait from the fresh read:

- **Active** — comments just addressed, branch just rebased, CI running → short wait (minutes).
- **Quiet** — nothing pending on the re-read, CI green, branch current → long wait (up to an hour).
- **Blocked on a human** — address-review handed back a thread, or update-branch hit an unresolvable conflict → report, send a push notification if the user has stepped away, and end the loop. Spinning changes nothing until the human acts.
- **Done** — PR merged or closed → end the loop.

A fixed-interval `/loop` ignores this step; it re-fires on its own schedule and re-reads state each time.

## Red flags: STOP

| Thought | Reality |
|---|---|
| "There's a new comment from a human reviewer, I'll just reply to keep things moving" | babysit-pr never posts. Hand it to address-review, which decides reply eligibility by its allowlist. |
| "The branch conflicts; I'll resolve it inline, it's faster than invoking update-branch" | Iron Law: rebases go through update-branch. Inline resolution skips its git-spice handling and its fetch-first rule. |
| "address-review already ran this PR last session, so the threads are handled" | State comes from the PR, not memory. Re-read. A thread reopened since then is not-dealt-with again. |
| "`mergeable` is UNKNOWN but `mergeStateStatus` says BEHIND, I'll rebase anyway" | UNKNOWN means GitHub is still computing. Re-read next iteration rather than acting on a half-computed state. |
| "Nothing is pending, but I'll invoke address-review each tick just to be sure" | With zero unresolved threads there is nothing to analyze. Skip it; the cheap signal in step 2 is the gate. |
| "I just finished addressing comments and rebasing, so nothing new can have arrived, I'll sleep an hour" | Those runs took minutes; bot comments and base advances land during them. Re-read the step 2 signals before scheduling any wait. |

Violating the letter of these rules is violating the spirit of them.

## Runner

Run the loop body under an in-session `/loop`, while the Claude Code
session stays open, with full local context and the installed skills.

```text
/loop /babysit-pr 1234          # fixed cadence you set
/loop                           # self-paced; built-in maintenance prompt already tends the current PR
```

- A self-paced `/loop` (no interval) lets step 6 choose each wake-up.
- Closing the terminal stops the loop. Recurring loops expire 7 days after creation.
- To make a bare `/loop` babysit a specific PR by default, put the instruction in `.claude/loop.md` (project) or `~/.claude/loop.md` (user).
