---
id: frontend-tests
description: Frontend component testing preferences.
---

## Frontend tests

Component tests are a fallback for behavior that cannot be made evident through simpler component structure or extracted pure logic.

When the behavior is evident from reading the component, do not write a component test.

When a component is difficult to verify, first decompose it into smaller components. Then extract and test genuinely non-trivial pure logic when the behavior can live outside hooks or context. Keep one-line mappings, prop forwarding, and simple conditionals inline.

When one of these cases remains after refactoring, write a component test:

- branching or derived state that remains entangled after decomposition;
- non-trivial business logic that must stay behind hooks or context;
- multi-step stateful interactions where order matters;
- a regression whose failure was not apparent in review.

Do not test unconditional rendering, a single conditional element, JSX structure mirrored by queries, composition of tested components, prop drilling, or callback forwarding.

The Writing tests criteria still apply.
