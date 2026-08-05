---
name: review-findings
description: >
  Audit findings from internal, delegated, or automated code self-review before
  review-driven edits. TRIGGER after a self-review reports one or more findings
  and before changing code in response, including when the user asks to
  self-review and fix. SKIP for external PR review comments handled by
  address-review, clean reviews with no findings, and implementation of a
  direct user requirement that did not arise as review feedback.
---

# Review Findings

A review finding is a claim to verify, not an instruction to edit code. The
main agent owns the disposition and the proposed response.

## Choose the mode

- **Evaluate mode:** Use for an automatically triggered self-review, or when the
  user asks to review, check, or audit without also asking to address findings.
  Report the findings and wait before making review-driven edits.
- **Address mode:** Use only when the user explicitly asks to fix, address, or
  resolve review findings. Report the findings first, then fix verified
  `Fix now` items. Stop for user direction before any `Decision` item.

When the request is ambiguous, use Evaluate mode.

## Procedure

### 1. Recover the applicable scope

Establish these boundaries before judging a finding:

- The user's overall requested outcome.
- The current milestone or checkpoint. An inspectable UI, prototype, migration
  stage, or other intermediate artifact may intentionally be incomplete.
- Work explicitly deferred to a later iteration.
- The code paths and environments the product currently supports.

Judge against those boundaries. Do not silently replace them with the
reviewer's preferred end state.

### 2. Verify every finding

Inspect the cited code and enough surrounding context to decide whether the
finding is true. Verify that it was introduced by the reviewed change or is
required for the changed behavior to work.

Do not inherit the reviewer's severity, confidence, or suggested remedy. Find
the smallest response that satisfies the actual requirement. If the answer
depends on a product, UX, architecture, compatibility, or scope choice, do not
guess.

### 3. Assign a disposition

Use exactly one disposition per finding:

| Disposition | Meaning |
|---|---|
| `Fix now` | Verified defect in the artifact due at the current checkpoint. At final submission, this includes defects that prevent the completed requested outcome from being correct. |
| `Decision` | Plausible concern whose response changes product behavior, architecture, compatibility, or agreed scope. |
| `Deferred` | Valid for a later planned milestone, explicitly excluded scope, or unsupported corner case. |
| `Reject` | Incorrect, already handled, not introduced by the change, or not required for the requested behavior. |

A theoretical hardening opportunity is not `Fix now` unless the current scope
requires it. A repository instruction to "fix every finding" does not change
the disposition.

### 4. Report before editing

Present every finding, including deferred and rejected findings, in this form:

```markdown
## Review findings

| # | Location | Finding and evidence | Disposition | Proposed response |
|---|---|---|---|---|
| 1 | `path:line` | Concise verified explanation | Fix now | Smallest concrete fix |
```

Send the table to the user in chat before invoking any edit tool. Use stable
finding numbers so the user can redirect individual items. State when no
finding survives verification. For a `Decision`, name the choice, plausible
alternatives, and observable tradeoff instead of presenting the reviewer's
remedy as the default.

### 5. Apply the mode gate

- In Evaluate mode, stop review-driven work after the report and wait for the
  user to approve, reject, or reclassify findings.
- In Address mode, implement only `Fix now` items after reporting them. Do not
  implement `Decision`, `Deferred`, or `Reject` items without a new user
  instruction.
- Re-run the applicable review after fixes, but do not turn newly suggested
  scope into work without repeating this procedure.

An explicit user disposition wins over a reviewer or repository default. A
general request to fix or address findings selects Address mode; it does not
pre-approve `Decision` or `Deferred` items.

## Red flags

| Thought | Response |
|---|---|
| "The subagent marked it actionable, so I should fix it." | Verify and classify it against the user's scope first. |
| "Handling this possible future case is safer." | Classify it as `Deferred` unless the current contract supports the case. |
| "I can show the report and immediately start editing." | Evaluate mode stops after the report. |
| "The proposed remedy is small, so no decision is needed." | Scope and behavior changes require a `Decision` even when the diff is small. |
