---
id: frontend-tests
description: Prefer simple component structure and pure-function tests over component harnesses.
---

## Frontend tests

Default to no component test when the behavior is evident from reading the component.

When a component is difficult to verify, first decompose it into smaller components. Then extract and test genuinely non-trivial pure logic when the behavior can live outside hooks or context. Keep one-line mappings, prop forwarding, and simple conditionals inline.

Write a component test only for:

- branching or derived state that remains entangled after decomposition;
- non-trivial business logic that must stay behind hooks or context;
- multi-step stateful interactions where order matters;
- a regression whose failure was not apparent in review.

Do not test unconditional rendering, a single conditional element, JSX structure mirrored by queries, composition of tested components, prop drilling, or callback forwarding.

The Writing tests criteria still apply.
