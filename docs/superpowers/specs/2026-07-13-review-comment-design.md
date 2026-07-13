# Review comment skill design

## Objective

Create a reusable `review-comment` skill for drafting and revising cold-read-accessible code review comments. The skill must help a reviewer expose a verified defect, risk, redundancy, or unclear decision; supply enough evidence for a reader who only has the diff and comment; and state the required or suggested outcome at the right level of abstraction.

## Responsibility

The skill owns comment analysis, explanation shape, drafting, and cold-read revision. It does not inspect or post GitHub reviews on its own, address comments received from other reviewers, or summarize an entire PR. Existing GitHub, `address-review`, and `pr-overview` workflows retain those responsibilities.

## Workflow

Every comment follows one spine:

1. Verify the concern in code and surrounding context.
2. State the problem and consequence.
3. Select the evidence form that matches the concern.
4. Separate required outcomes from optional implementation suggestions.
5. Draft for a reader with no conversation context.
6. Re-read and revise the finished comment as a cold reader.

Concern-specific evidence forms:

| Concern | Evidence form | Outcome form |
|---|---|---|
| Incorrect behavior | Trigger, execution path, actual result, expected result | Firm correctness requirement |
| Missing edge case | Input or state, unhandled branch, consequence | Firm handling requirement |
| Failure or state risk | Event sequence or state transition | Required invariant; optional implementation suggestion |
| Architectural ownership or redundancy | Current topology and responsibility boundary | Suggested shape and rationale |
| Duplication or coupling | Consumer and responsibility map | Suggested consolidation or boundary |
| Uncertain choice | Verified context and precise unknown | Focused question |

Topology diagrams are conditional. Use current/suggested structure only when ownership or relationships carry the review point. Present the current structure as verified fact and the desired structure as a suggestion, not a prescribed target.

## Drafting constraints

- Introduce identifiers before relying on them.
- Qualify relational terms such as parent, child, and sibling.
- Do not use unresolved references such as “this refactor.”
- Do not prescribe code-level steps when the architectural or behavioral outcome is sufficient.
- Preserve user-authored text verbatim when requested. Keep agent-authored additions separate and attributed according to the active repository guidance.
- Keep hard correctness requirements firm. Mark only implementation choices as suggestions when multiple valid remedies exist.

## Example

Use a generic list-scoped-state example. The current structure places state in a provider above a list even though the list defines the selectable set and renders every consumer. The suggested shape makes the list the owner and passes values to its shallow descendants. Keep this example separate from the generic rules.

## Validation

- Run the skill validator.
- Pressure-test one hard-bug review and one architectural-redundancy review with fresh agents.
- Confirm the hard-bug output does not soften correctness and the architectural output uses current/suggested structure without prescribing implementation.
