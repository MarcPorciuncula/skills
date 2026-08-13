---
name: map-ui-affordances
description: >-
  TRIGGER: Use when the user asks to scope, design, redesign, revise,
  implement, investigate, or review the structure of a user-facing screen,
  page, panel, dialog, navigation area, or substantial UI region; questions
  whether UI content or controls are necessary; asks about UX, UI,
  information architecture, hierarchy, discoverability, filler, or
  affordances; or explicitly asks for an affordance tree. SKIP: isolated
  spacing, colour, typography, token, icon, or exact-copy changes that do not
  change an element's purpose or hierarchy; non-product graphics; and
  implementation where a current affordance tree is supplied and remains
  unchanged.
---

# Map UI Affordances

An affordance tree is a text outline of the UI's user-perceived structure.
Terminal descriptions state what each meaningful visible item lets the user do
or understand.

**NO STRUCTURAL UI ELEMENT WITHOUT A USER PURPOSE AND A PLACE IN THE AFFORDANCE TREE.**

Use required affordances from an applicable product-design skill as input when
they exist. Use applicable presentation skills after the tree establishes the
intended structure. Do not duplicate or override settled product decisions.

## Write the tree

Model the interface the user perceives, not its DOM or component wrappers.

- Include meaningful regions, groups, controls, disclosed surfaces, status,
  feedback, instructions, and necessary content.
- Nest menu items, dialog actions, and disclosed content beneath the control
  that reveals them.
- Qualify conditional items inline with `[when ...]`.
- Put multi-screen flows and complex state transitions in a separate
  representation.
- Use separate trees only when a state materially reorganises the surface.
- Omit layout wrappers, implementation-only components, decoration, evidence
  IDs, formal node types, and visual specifications.

An interactive parent such as a tab or menu may contain other affordances. Do
not distort the perceived hierarchy to force every action into a leaf-only
grammar.

## Example

Settled requirements: a workspace owner can enable or disable activity-summary
emails, choose daily or weekly delivery when enabled, understand that delivery
uses their account email, and save the settings.

Primary task: configure activity-summary email delivery.

Observed tree:

```text
Activity summaries
├─ Intro: understand that summaries help monitor the workspace
├─ Summary frequency
│  ├─ Daily: select daily delivery
│  └─ Weekly: select weekly delivery
├─ Email delivery: understand that summaries use the account email
├─ Get more from summaries: read generic educational content
└─ Save changes: persist the settings
```

Affordance coverage:

- Present: choose a frequency, understand the destination, and save.
- Missing: enable or disable summary emails.
- Unmatched: the generic intro and educational content.

Recommended intended tree:

```text
Activity summaries
├─ Activity-summary emails: enable or disable summary emails
├─ Frequency [when enabled]
│  ├─ Daily: receive a summary each day
│  └─ Weekly: receive a summary each week
├─ Delivery address [when enabled]: understand that summaries use the account email
└─ Save changes: persist the settings
```

Open decisions: initial enabled state, default frequency, and whether to display
the address itself. Keep these outside the intended tree until settled.

## Design or revise a surface

1. Inspect the settled requirements and the current surface when one exists.
2. State the primary user task and completion condition.
3. List the required affordances and necessary information. Record plausible
   but unsupported behaviour as an open decision; do not promote it into a
   requirement.
4. Construct the intended affordance tree before choosing concrete layout or
   visual treatment.
5. Audit the tree:
   - Place every required affordance.
   - Trace every intended node to a settled need. Exclude nodes that depend on
     an unanswered product decision.
   - Remove every unmatched item.
   - Keep the primary path direct.
   - Group related affordances as siblings.
   - Keep utility actions outside the primary path.
   - Keep disclosed actions beneath their trigger.
   - Present alternatives in parallel unless their tasks materially differ.
   - Give each group enough orientation to understand its children.
6. Use the accepted tree to choose UI regions, controls, and presentation.
7. When a proposal or implementation exists, reconstruct its observed tree and
   compare it with the intended tree before accepting the structure.

## Review an existing surface

1. Establish the primary task from requirements or user context. Existing UI
   proves presence, not necessity.
2. List required affordances from settled needs without using the current
   interface as evidence.
3. Reconstruct the observed tree from the available screenshot, rendered UI,
   proposal, markup, or component code.
4. Use displayed labels and perceptible grouping. Write `<unlabelled group>`
   when the interface supplies no name or orientation. Write `?` when an
   item's purpose cannot be determined.
5. Preserve repetition, asymmetry, awkward nesting, and disclosure depth. Do
   not improve the interface while describing it.
6. Map every observed item to a required affordance or user need.
7. Report missing required affordances, unmatched content, duplicated
   responsibility, incorrect grouping, excessive hiding, competing utility
   content, non-parallel alternatives, and terminology the intended audience
   cannot interpret. Report plausible interaction gaps that are not settled
   needs as open decisions, not missing affordances.
8. Produce a revised intended tree when recommending structural changes. Name
   the resulting user-visible changes. Keep unanswered product decisions
   outside the tree; do not add speculative controls, content, or states, even
   when qualified with `[when ...]`.

The observed tree records what the interface communicates, not what its author
meant.

## Output and handoff

For design or revision, provide the primary task, required affordances,
intended tree, open decisions, explicit exclusions, and presentation
consequences.

For review, provide the primary task, observed tree, affordance coverage,
structural findings, recommended tree, open decisions, and resulting
user-visible changes.

Keep the output proportional to the surface.

When delegating structural UI implementation, include the accepted intended
tree with the required affordances, exclusions, terminology, and open product
decisions. Require the implementer to stop before adding, removing, or
reparenting a user-visible node. Leave component choice and local code
structure with the implementer.

## Visual-review boundary

- Use screenshots or a running interface when the user supplies them or they
  already exist.
- Do not start a development server, render the UI, or capture screenshots
  solely for this workflow.
- State when review is limited to requirements, a proposal, markup, or code.
- Treat validation of spacing, salience, contrast, responsiveness, and actual
  perceived grouping as a separate opt-in visual review.

## Red flags

| Thought | Required response |
|---|---|
| "The component has a subtitle or helper slot, so I should supply something useful." | Optional slots do not establish user need. Leave the slot empty unless its content has a place in the tree. |
| "This section makes the page feel complete." | Completeness is not an affordance. Remove the section unless its absence harms a named user outcome. |
| "The group's purpose is obvious from its children." | In an observed tree, mark it `<unlabelled group>`. In an intended tree, decide whether users need visible orientation. |
| "I can summarise these repeated or uneven blocks as one area." | Preserve the structure the interface presents. Compression hides repetition and asymmetry. |
| "It already exists in the UI, so it must represent a requirement." | Existing implementation proves presence, not necessity. Map it to a user need or question it. |

**Violating the letter of these rules is violating the spirit of them.**
