---
id: writing-tests
description: Before writing a test, justify its maintenance cost and identify an assertion that would catch the bug.
---

## Writing tests

Before writing or modifying a test, justify it and design it.

Write the test only when all of these hold:

- The behavior is a correctness requirement or functional contract worth maintaining, not merely an optimization or cleanup preference.
- The test exercises non-trivial product logic rather than restating a library contract.
- The behavior can be tested deterministically without timing, scheduling, or ordering fragility, unless those semantics are the product being built.
- The regression is not already obvious from reading the implementation.
- The assertion carries more value than the mocks, providers, timers, or other harness needed to reach it.

Before implementation, identify:

- the exact output, state change, or side effect to assert;
- an input that produces a detectably different result when the implementation is wrong;
- why the proposed bug would make the test fail.

Test at the lowest level where the behavior is directly observable, then use at most one higher-level test to verify wiring. Do not extract trivial logic solely to make it testable.

Name tests by behavior, keep one logical behavior per test, and make failures understandable without reading the test source. When editing a test file, remove redundant or indirect tests related to the same behavior.
