---
name: visual-iteration
description: >-
  Enter, continue, or exit a temporary UI visual-iteration mode that prioritises
  rapid in-context presentation changes over production implementation
  discipline. Use when staging mockups or forced UI states in application code,
  including with a coordinator and implementer agent. Skip ordinary UI delivery,
  design discussion without a rendered implementation, and static image mockups.
---

# Visual Iteration

Use application code as a disposable visual draft. Optimise for the speed and
quality of visual decisions. Defer production implementation work until the user
explicitly exits visual iteration.

## Establish the design envelope

Determine the intended design envelope from the user's request:

| Intent | Visible states and interactions |
|---|---|
| Design exploration | May include speculative or currently unimplementable behaviour. |
| Implementation-constrained iteration | Must remain implementable against the intended production contract. |

When the request stages a design immediately before implementation and does not
propose future behaviour, use implementation-constrained iteration. When the
request explores concepts or future behaviour, use design exploration. If the
choice remains unclear and would change what the user sees, ask which envelope
to use before staging the conflicting states.

Apply the selected envelope to the rendered UI, not to the temporary code used
to produce it. In either envelope, the draft may bypass types, data mappings,
permissions, mutations, validation, and business logic.

## Stage the real interface

When the target page and components exist, stage the draft in that real context.
Use the actual route, surrounding content, component hierarchy, and styling.

- Replace or alter incoming frontend data at the most convenient local boundary.
- Hard-code props, create synthetic objects, cast values, bypass mappings, or
  force local state when that produces the requested presentation faster.
- Make a temporary data replacement unconditional when isolation adds no visual
  value.
- Use existing components and rendering paths where they keep the draft grounded
  in the product context.
- Create the smallest in-context shell when the target surface does not yet
  exist.

Do not create a design-system gallery, showcase route, parallel mock component,
URL flag, feature flag, or reusable fixture system merely to isolate the draft.
Use one of those surfaces only when the user requests it or it is the actual
surface under evaluation.

## Defer production logic

Implement only the behaviour needed to present and manipulate the current visual
draft.

- Do not spend time wiring mutations, permissions, validation, persistence,
  error handling, loading lifecycles, or business rules for production
  correctness unless that behaviour is itself under visual evaluation.
- Leave an existing mutation connected when changing it adds no value to the
  visual iteration.
- Simulate an interaction with local state when real integration would delay the
  next visual decision.
- Do not productionise data construction, mappings, component APIs, or temporary
  state management during this phase.
- Do not refactor unrelated code or build permanent mock infrastructure.

Correct only compilation or runtime problems that prevent the requested surface
from rendering or the requested interaction from being evaluated.

## Suspend delivery checks

Treat this phase as disposable visual staging, not production behaviour
implementation.

- Do not inspect test files or test configuration.
- Do not plan, create, modify, or run tests.
- Do not run separate lint, type-check, build, audit, or review commands.
- Do not perform self-review or production-readiness review.
- Do not invoke testing, review, or completion workflows solely because
  application source files changed.
- Do not commit, push, create or update a pull request, or update an issue.

Use only the development server, hot reload, browser, screenshots, or equivalent
rendering feedback needed for visual iteration. Do not convert that feedback
into a broader correctness check.

Keep visual iteration active across the current workflow until the user
explicitly exits it. Do not infer an exit from approval of one revision or from
phrases such as `looks good`.

## Coordinate through an implementer

When the user also invokes an available coordinator-and-implementer workflow,
keep product decisions, visual direction, and user acceptance in the
coordinator. Give repository investigation and code changes to one implementer.

While visual iteration is active, replace any default implementer requirements
to run tests, checks, or self-review with the constraints in
[Suspend delivery checks](#suspend-delivery-checks).

Include these facts in the first implementer handoff:

- Visual iteration is active and the work is a disposable local draft.
- The selected design envelope and required visible states.
- The real page or product context to stage.
- Temporary code may bypass types, data, and production business logic.
- Only rendering blockers should be repaired.
- Tests, checks, self-review, commits, pushes, pull requests, and issue updates
  are out of scope.
- The implementer must stop for a user-visible product or design decision, not
  for a choice about temporary implementation correctness.

Reuse the same implementer for visual corrections. State that visual iteration
remains active in each follow-up that changes the draft.

## Exit visual iteration

Exit only when the user explicitly ends visual iteration. An instruction such as
`Exit visual iteration and productionise the accepted design` both exits the
mode and authorises the production phase. An instruction that only exits the
mode does not by itself authorise further implementation.

On exit:

1. State that the temporary visual-iteration constraints no longer apply.
2. Tell an active implementer that the earlier reduced-discipline instructions
   are revoked.
3. Remove synthetic overrides, forced states, and temporary staging paths unless
   the user explicitly asks to retain them.
4. Preserve the accepted visible design within its selected design envelope.
5. Follow the normal repository, testing, review, commit, push, and pull-request
   workflows for any production implementation the user requested.
