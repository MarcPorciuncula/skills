---
id: frontend-tests
description: Default to no component test; refactor first (decompose, then extract) so the code is visibly trivial. Test only what survives.
---

## Frontend tests

Default to no component test. Write one only when reading the component is not enough to convince a reviewer the behaviour is correct.

When a component looks like it needs a test, refactor first. The preferred response is to make the code visibly trivial, not to wrap a harness around complexity. Two moves, in order:

1. **Decompose the component** into smaller pieces until each one is self-evident. A component with five interacting flags becomes three components with one or two each. The result usually needs no tests at all.
2. **Extract non-trivial logic into a pure function** and test that function. Only do this when the logic is genuinely non-trivial — a one-line mapping or a single ternary stays inline. Extracting trivial logic just to make it testable produces noise.

After refactoring, write a test only when one of these is still true:

- **High branching complexity that resists decomposition.** Enough conditional rendering, derived state, or interacting flags that a reader can't hold all the cases in their head, and the cases are genuinely entangled (not separable into smaller components).
- **Non-trivial transform or business logic that must stay in the component** — usually because it depends on hooks or context that don't survive extraction. Test through the component.
- **Stateful interaction sequences.** Multi-step flows where ordering matters (open → type → submit → error → retry), not single event handlers that flip a boolean.
- **Regression guard for a specific bug** that review didn't catch. Write the test that would have failed.

Do **not** write a test when:

- The assertion is "this text/element renders" with no condition behind it.
- The behaviour is a single `{flag && <X/>}` or ternary — a reader sees it at a glance.
- The test would mirror the JSX structure (querying for the same elements the component declares).
- The component is mostly composition of other tested components.
- The only "logic" is prop-drilling or passing a callback through.

The **Writing tests** rules above still apply to extracted functions and to component tests that survive refactoring.
