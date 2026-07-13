---
name: review-comment
description: >
  Draft, prepare, or revise focused code review comments from code context
  supplied by the user or inspected locally. Use for correctness bugs, missing
  edge cases, failure risks, architectural ownership, duplication or coupling,
  and question-shaped concerns. Skip full PR summaries, GitHub review-state
  inspection, posting reviews, and handling comments received from reviewers.
---

# Review Comment

Produce a comment that a reader can evaluate without the conversation that
preceded it.

## Procedure

1. **Verify the concern.** Read the relevant code and trace the behavior far
   enough to distinguish a demonstrated problem from a possibility. Ask for
   missing context when the concern cannot be verified locally.
2. **State the consequence.** Name the wrong result, uncovered input, failure
   mode, misplaced responsibility, maintenance cost, or decision risk. Do not
   substitute a preference for an observable consequence.
3. **Select the evidence form.** Use the form that makes this concern easiest
   to verify; do not force every comment into one template.
4. **Separate outcome from remedy.** State required behavior or ownership
   firmly. Introduce an optional implementation with `Suggestion:` or
   `Suggested shape:`. Do not soften a demonstrated bug into a suggestion.
5. **Draft without session context.** Name the relevant behavior and introduce
   each identifier before using it. Include only the evidence needed to
   understand and verify the concern.
6. **Cold-read and revise.** Read the comment as a reviewer who has only the
   diff and the comment. Remove every dependency on the prior conversation.

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

## Drafting checks

- Introduce every function, component, variable, and domain term before using
  its identifier alone.
- Qualify relationships. Name which component is the parent, which item is a
  child of which list, or which components are siblings under which owner.
- Replace unresolved references such as “this refactor,” “that logic,” or “the
  above” with the concrete change or behavior.
- Match the abstraction to the concern. Prefer a behavioral guarantee or
  ownership boundary over a code-level prescription when either is sufficient.
- Preserve user-authored text verbatim when the user requests it. Do not polish,
  merge, or silently correct that text.
- Keep agent-authored additions separate from preserved user text. Attribute
  those additions according to the active repository guidance.
- Keep hard requirements and optional remedies visibly distinct.

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

> `SelectionProvider` currently owns selection state above `ResultsPanel`,
> while `ResultList` defines the result collection and renders both consumers:
> its `ResultRow` children and its `ResultToolbar` child. This makes
> list-scoped selection part of the panel's wider state boundary, so another
> list added under `ResultsPanel` would share state that belongs to the first
> list.
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
> Keep each result list's selection state within that list's ownership
> boundary. The provider can move with the boundary, but the specific
> component or hook arrangement is optional.
