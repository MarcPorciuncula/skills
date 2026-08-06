# Frontend test selection

Read this file after the main test-admission criteria pass for a component,
route, hook, JSX, or browser behaviour.

Component tests are a fallback for behaviour that cannot be made evident
through simpler component structure or directly tested pure logic.

Before admitting a component test:

1. Decompose a component whose responsibilities make the behaviour difficult to
   review.
2. Extract and test non-trivial pure logic only when that logic belongs outside
   hooks or context.
3. Keep one-line mappings, prop forwarding, and simple conditionals inline and
   untested.

Admit a component test only when one of these remains:

- Branching or derived state remains entangled after decomposition.
- Non-trivial business logic must remain behind hooks or context.
- A multi-step stateful interaction depends on action order.
- A regression would not be apparent from reviewing the component.

Reject tests of:

- unconditional rendering or one conditional element;
- JSX or DOM structure mirrored by queries;
- CSS utility classes or visual alignment without a visual assertion;
- composition of already-tested components;
- prop drilling, callback forwarding, or route-to-component delegation;
- keyboard, focus, dismissal, or other behaviour owned by a UI library.

Use at most one component-level wiring test after lower-level coverage. Its
assertion must observe the product behaviour, not the component's source shape.
