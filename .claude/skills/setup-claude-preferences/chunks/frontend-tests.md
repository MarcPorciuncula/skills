---
id: frontend-tests
description: Frontend tests must exercise behavior (state, props, events, conditionals) — skip tests that only mirror JSX.
---

## Frontend tests

Frontend tests earn their place by exercising behavior: state changes, prop-driven variation, event handlers, or conditional rendering. If a test doesn't do one of those, don't write it.

Before adding a component test, self-check:

- Does it only assert that content or an element exists? → skip
- Is the result trivially readable from the component's JSX? → skip
- Does it exercise a state change, prop variation, event handler, or conditional branch? → write it

Tests that mirror the JSX add churn on every copy or styling edit without catching regressions a glance at the file wouldn't.
