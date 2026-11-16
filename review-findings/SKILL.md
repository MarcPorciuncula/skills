---
name: review-findings
description: >
  Audit and preserve findings from internal, delegated, or automated code
  self-review. TRIGGER after a self-review reports one or more findings and
  before changing code in response, including when the user asks to self-review
  and fix. TRIGGER before final handoff when the current task has recorded
  review findings. SKIP for external PR review comments, which use
  address-review if available; clean reviews when no findings file exists; and
  implementation of a direct user requirement that did not arise as review
  feedback.
---

# Review Findings

Treat internal or subagent self-review findings as unverified claims. Verify every finding against the code and current milestone scope, record it in a durable task-local file, and publish the assessment table in chat before editing code.

## 1. Verify findings against current scope and assign a disposition

Establish the user's requested outcome, the current milestone/checkpoint (an intermediate prototype or migration slice may be intentionally incomplete), and supported code paths. Inspect the cited code and assign one disposition per finding:

| Disposition | Criteria |
|---|---|
| `Fix now` | Verified defect that violates a current requirement or observable user/domain outcome due at the current checkpoint. |
| `Decision` | Plausible concern whose fix alters product behaviour, UX, architecture, compatibility, or agreed scope. |
| `Deferred` | Valid for a later milestone, excluded scope, or theoretical hardening not required by the current contract. |
| `Reject` | Factually incorrect, already handled, not introduced by the change, or unnecessary for the requested behaviour. |

- **Require a concrete failure proof for `Fix now`:** A theoretical state transition, missing defensive check, or reviewer preference is not a defect by itself. For lifecycle/cancellation findings, evaluate the background operation and the initiating UI surface separately; closing a UI surface does not require cancelling an accepted operation unless the product contract requires it.
- **Classify before considering edit size:** A repository rule to "fix every finding" or the fact that a proposed change is a 2-line edit never promotes a `Decision`, `Deferred`, or `Reject` item into `Fix now`.
- **Find the minimal fix:** Do not blindly adopt a reviewer's suggested refactor when a smaller fix satisfies the invariant.

## 2. Record and publish before editing code

1. **Maintain a task-local findings file:** On the first finding, create `/tmp/opencode/review-findings-<task-slug>.md` (outside any git repository or worktree so it survives context compaction without dirtying the worktree). Append or update rows across review passes without deleting prior `Fixed`, `Deferred`, or `Rejected` rows:
   ```markdown
   | # | Source & location | Finding & evidence | Scope assessment | Disposition | Proposed response | Status |
   |---|---|---|---|---|---|---|
   | 1 | Reviewer A, `path:line` | Verified explanation | Required at current checkpoint | Fix now | Minimal concrete fix | Open |
   ```
   Use status values `Open`, `Fixed`, `Needs user`, `Deferred`, or `Rejected`.
2. **Publish in chat before editing:** Print the complete findings table in chat before invoking any file-edit tool for a review-driven fix. For `Decision` items, state the options and trade-off neutrally rather than defaulting to the reviewer's preference.

## 3. Execute fixes and reconcile at final handoff

- **Review-only requests:** Stop after publishing the table; do not edit code.
- **Authorized implementation:** Fix only `Fix now` items (plus any `Decision` or `Deferred` items the user explicitly instructs you to implement). Do not delay an early draft PR transport checkpoint for review-driven fixes.
- **Incremental re-verification:** After applying `Fix now` edits, re-verify only the recorded findings and affected paths (update their status to `Fixed` in the findings file). Repeat a whole-branch review only if the fixes cross a new architectural, runtime, or compatibility boundary.
- **Final handoff reconciliation:** Before claiming task completion, read the findings file and display the complete accumulated table (`Fixed`, `Needs user`, `Deferred`, `Rejected`) in chat so no finding is silently lost.
