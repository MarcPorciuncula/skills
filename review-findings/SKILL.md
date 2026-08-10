---
name: review-findings
description: >
  Audit and preserve findings from internal, delegated, or automated code
  self-review. TRIGGER after a self-review reports one or more findings and
  before changing code in response, including when the user asks to self-review
  and fix. TRIGGER before final handoff when the current task has recorded
  review findings. SKIP for external PR review comments handled by
  address-review, clean reviews when no findings file exists, and implementation
  of a direct user requirement that did not arise as review feedback.
---

# Review Findings

Verify and preserve every finding before acting on it. Publish the assessment
in chat, then continue authorized work unless a finding creates a blocking
decision.

## Procedure

### 1. Recover the applicable scope

Establish these boundaries before judging a finding:

- The user's overall requested outcome.
- The current milestone or checkpoint. An inspectable UI, prototype, migration
  stage, or other intermediate artifact may intentionally be incomplete.
- Work explicitly deferred to a later iteration.
- The code paths and environments the product currently supports.

Judge against those boundaries. Do not replace them with the reviewer's
preferred end state.

### 2. Verify every finding

Inspect the cited code and enough surrounding context to decide whether the
finding is true. Verify that it was introduced by the reviewed change or is
required for the changed behavior to work.

Do not inherit the reviewer's severity, confidence, or suggested remedy. Find
the smallest response that satisfies the actual requirement. Do not guess when
the answer depends on a product, UX, architecture, compatibility, or scope
choice.

### 3. Assign a disposition

Use exactly one disposition per finding:

| Disposition | Meaning |
|---|---|
| `Fix now` | Verified defect in the artifact due at the current checkpoint. At final submission, this includes defects that prevent the completed requested outcome from being correct. |
| `Decision` | Plausible concern whose response changes product behavior, architecture, compatibility, or agreed scope. |
| `Deferred` | Valid for a later planned milestone, explicitly excluded scope, or unsupported corner case. |
| `Reject` | Incorrect, already handled, not introduced by the change, or not required for the requested behavior. |

A theoretical hardening opportunity is not `Fix now` unless the current scope
requires it. A repository instruction to fix every finding does not change the
disposition.

### 4. Record the findings

Create a task-specific Markdown file in the system temporary directory when the
first finding arrives. Prefix its name with `review-findings-`, keep it outside
every repository and worktree, and retain its path in task state so it can be
recovered after context compaction.

Use stable finding numbers and this table:

```markdown
# Review findings

| # | Source and location | Finding and evidence | Stage and scope assessment | Disposition | Proposed response | Status |
|---|---|---|---|---|---|---|
| 1 | Reviewer A, `path:line` | Concise verified explanation | Required at the current checkpoint | Fix now | Smallest concrete fix | Open |
```

Use `Open`, `Fixed`, `Needs user`, `Deferred`, or `Rejected` as the status.
Record every finding before making a review-driven edit. Update the existing row
when a later review repeats a finding or its status changes. Do not delete fixed,
deferred, or rejected findings.

### 5. Report the findings

Send the current review's complete findings table to the user in chat before
invoking an edit tool for a review-driven change. Include deferred and rejected
findings. Do not wait for a response unless the continuation rules require user
input.

For a `Decision`, name the choice, plausible alternatives, and observable
tradeoff instead of presenting the reviewer's remedy as the default. State when
no finding survives verification.

### 6. Continue the authorized work

- For a review-only request, report the findings without editing code.
- During authorized implementation, or when the user asked to address findings,
  fix verified `Fix now` items after publishing them and continue the task.
- Do not implement `Decision`, `Deferred`, or `Reject` items without a
  finding-specific user instruction.
- Continue independent authorized work while a `Decision` remains open. Request
  user input only when it blocks the remaining work.
- Do not let review-driven edits delay a draft transport checkpoint authorised
  by the PR workflow.
- After fixes, recheck the recorded findings and affected paths. Restart a
  whole-artifact review only when the fixes expand scope or cross a new
  responsibility, runtime, compatibility, or safety boundary. Update the
  findings file with the result and each affected status.

An explicit user disposition wins over a reviewer or repository default. A
general request to fix or address findings does not pre-approve `Decision` or
`Deferred` items.

### 7. Reconcile at final handoff

Read the findings file before final handoff. Show the complete accumulated table
to the user, including findings already fixed, deferred, or rejected. Do not
claim completion without surfacing the file when the task recorded findings.
Do not delete the file before the handoff.

## Red flags

| Thought | Response |
|---|---|
| "The subagent marked it actionable, so I should fix it." | Verify and classify it against the user's scope first. |
| "Handling this possible future case is safer." | Classify it as `Deferred` unless the current contract supports the case. |
| "I fixed it quickly, so the user does not need to see it." | Record and publish every finding before the edit, then preserve its `Fixed` status. |
| "The user is not watching, so a chat update has no value." | Publish it anyway and preserve it in the findings file for final handoff. |
| "The proposed remedy is small, so no decision is needed." | Scope and behavior changes require a `Decision` even when the diff is small. |
| "The review found defects, so the draft PR must wait until the review is clean." | Follow the PR workflow. Finding resolution gates final handoff, not a draft transport checkpoint. |
