---
name: review-comment
description: >
  Draft, prepare, revise, or sanity-check focused code review comments from
  code context supplied by the user or inspected locally. Use for correctness
  bugs, missing edge cases, failure risks, architectural ownership, duplication
  or coupling, question-shaped concerns, and user-authored review text intended
  to remain verbatim. Skip full PR summaries, GitHub review-state inspection,
  posting reviews, and handling comments received from reviewers.
---

# Review Comment

Write every comment to stand alone beside the diff. A reader with no access to
the drafting conversation must be able to identify the concern, verify it from
the cited evidence, and distinguish the required outcome from an optional
remedy.

## Content authorship

Classify each segment before drafting or validating it. The complete review
comment must stand alone; individual segments need not repeat evidence from
another segment.

| Source | Treatment |
|---|---|
| Agent-authored | Verify fully and write as a neutral technical report |
| User-authored verbatim | Preserve exactly and apply the material sanity-check standard below |
| Composite | Apply the matching treatment to each segment and keep the segments separate |

## Procedure

1. **Verify the concern.** For agent-authored findings, read the relevant code
   and trace the behavior far enough to distinguish a demonstrated problem
   from a possibility. For user-authored verbatim text, use the Verbatim sanity
   checks below. Ask for missing context when the concern cannot be verified
   locally.
2. **State the consequence.** Name the wrong result, uncovered input, failure
   mode, misplaced responsibility, maintenance cost, or decision risk. Do not
   substitute a preference for an observable consequence.
3. **Select evidence that proves the concern.** Use the form that lets the
   reader verify the stated consequence; do not force every comment into one
   template.
4. **Separate outcome from remedy.** State the required behavior or ownership
   at the appropriate abstraction. Label optional implementations and
   architectural alternatives as suggestions.
5. **Draft for a cold reader.** Name the relevant behavior and introduce each
   identifier before using it. Write agent-authored text in neutral report
   voice. Include only the evidence needed to understand and verify the concern
   beside the diff.
6. **Cold-read and revise.** Read the comment as a reviewer who has only the
   diff and the comment. Remove every dependency on the prior conversation.

## Agent-authored voice

Agent-authored findings report verified behavior; they do not simulate a human
reviewer's personal voice.

- DO state the observed behavior, consequence, required outcome, and optional
  remedies directly.
- DO use a neutral question when the implementation choice is genuinely
  uncertain.
- DO NOT frame findings as personal opinions with phrases such as `I think`,
  `I would`, or `we should`.
- DO NOT address the author with `you should`; state the required outcome or
  label an optional remedy as a suggestion.
- DO NOT treat an AI attribution label as permission to adopt a human reviewer
  persona.

## Verbatim sanity checks

When the user asks to preserve review text verbatim, treat validation as a
material sanity check unless they explicitly request detailed accuracy review
or revision.

- DO confirm the text is directionally correct when no material issue exists.
- DO flag a materially false central claim, a contradiction with an
  accompanying agent report, or wording that directs the review toward the
  wrong outcome.
- DO NOT flag defensible simplifications, terminology imprecision, omitted
  qualifications, or another valid remedy.
- DO move non-material technical qualifications into a separate, attributed
  agent report.
- DO NOT rewrite, polish, or merge the user-authored text unless the user asks
  for revision.

## Evidence selection

| Concern | Evidence form |
|---|---|
| Correctness bug | Minimal input or execution path, actual result, and required result |
| Missing edge case | Unhandled boundary or state and the distinct outcome it produces |
| Failure risk | Failure sequence, persisted or externally visible state, and required guarantee |
| Architectural ownership | Verified current topology and ownership consequence; add a `Suggested shape` only when topology carries the point |
| Duplication or coupling | The duplicated rule or dependency in each location and the concrete divergence or change cost |
| Uncertain choice | A neutral question naming the observed choice, plausible alternatives, and why the answer affects the review |

Use code snippets, call paths, or diagrams only when they shorten verification.
For architecture, show current structure as fact. Keep the alternative small
and label it as a suggestion rather than a target or mandate.

## Required outcomes and suggested remedies

- State correctness fixes and required invariants firmly.
- Label an implementation choice `Suggestion:` when more than one remedy can
  satisfy the requirement.
- Label an architectural alternative `Suggested shape:`. Do not present it as
  a target.
- Demonstrate the concern before offering a remedy. A remedy without a proven
  consequence reads as preference.

## Drafting rules

- DO introduce every function, component, variable, and domain term before
  using its identifier alone.
- DO qualify relationships. Name which component is the parent, which item is
  a child of which list, or which components are siblings under which owner.
- DO replace references such as “this refactor,” “that logic,” or “the above”
  with the concrete change or behavior.
- DO match the abstraction to the concern. Prefer a behavioral guarantee or
  ownership boundary when it is sufficient.
- DO keep agent-authored additions separate from preserved user text and
  attribute them according to the active repository guidance.
- DO NOT prescribe code-level steps when the required behavior or ownership
  boundary is sufficient.

## Recognition

| Draft failure | Revise to |
|---|---|
| “This refactor” or “that logic” has no resolved reference | Name the concrete change or behavior |
| “The child” or “the parent” leaves the relationship unclear | Name both components and their relationship |
| An implementation identifier appears before its role is explained | Introduce the behavior or role before the identifier |
| An architectural alternative is framed as the target structure | Label it `Suggested shape:` and keep ownership as the review point |
| A remedy is stated before the concern is demonstrated | Show the evidence and consequence first |
| An AI-attributed finding says `I think`, `I would`, or `you should` | Report the verified behavior and consequence; state the outcome or suggestion neutrally |
| A verbatim sanity check lists minor precision or completeness qualifications | Confirm material direction; carry useful detail in the separate agent report |

## Worked example: partial success

> `saveAll` starts one save request per edited record and rejects as soon as
> any request fails. The error path then restores every record's local value,
> even though requests that succeeded remain persisted on the server. A retry
> can therefore overwrite committed values with the restored stale values.
> After the batch finishes, local records must match persisted state; do not
> restore records whose saves committed successfully.
>
> Suggestion: collect every request outcome before reconciling state. A
> transactional bulk-save endpoint is another valid remedy; the required
> outcome is that local state matches what was persisted after partial failure.

## Worked example: list-scoped state

Verified current topology:

```text
SelectionProvider (owns selected item state)
└── ResultsPanel
    └── ResultList (defines the result collection)
        ├── ResultRow (reads selection state)
        └── ResultToolbar (reads selection state)
```

Review comment:

> `SelectionProvider` owns selection state above its `ResultsPanel` child.
> Inside that panel, `ResultList` defines the selectable collection and renders
> every consumer: its `ResultRow` children and `ResultToolbar` child. A second
> list under the same panel would therefore share selection state with the
> first list, although each list defines a separate selectable collection.
>
> Suggested shape:
>
> ```text
> ResultsPanel
> └── ResultList (owns selected item state)
>     ├── ResultRow
>     └── ResultToolbar
> ```
>
> Keep independent result lists in separate selection-state boundaries. The
> suggested shape is one option; provider, hook, and prop arrangements that
> preserve one state boundary per list are also valid.
