---
id: writing-tests
description: Two-pass self-check before writing or modifying any test — justify it (five gates), then design it (verification questions).
---

## Writing tests

A test is a permanent maintenance commitment. Before writing or modifying one, run two passes: justify it, then design it.

### Pass 1 — Should this test exist?

All five gates must pass. Any single fail → don't write the test.

1. **Severity — does the underlying behaviour earn a permanent test?**
   - **Pass:** Correctness bug with user-visible blast radius (crash, data loss, wrong result, auth bypass), or a functional gap other code will depend on.
   - **Fail:** Optimization, performance improvement, or "more-correct" cleanup.

2. **Subject — would the test exercise our logic, or a library's?**
   - **Pass:** Non-trivial transformation, branching, state, or data shape that we wrote.
   - **Fail:** Trivial composition of a well-tested library primitive (rxjs operator, TanStack Query option, vetted hook). The test would re-assert the library's contract, not ours.

3. **Category — is the behaviour brittle and expensive to test in product code?**
   - **Pass:** Deterministic; doesn't depend on timing, scheduling, or concurrent ordering primitives.
   - **Fail:** Depends on fine timing (debounce/throttle, animation frames), concurrency (races, async ordering), or lifecycle ordering (signals, teardown). These tests are CI-flaky for low return. **Exception:** systems code where this category *is* the deliverable (databases, schedulers, distributed locks, kernels).

4. **Visibility — could a code reviewer spot the regression by reading the change?**
   - **Pass:** Regression is non-obvious from the diff — hidden behind layers of state, indirection, or interaction.
   - **Fail:** Change is small and behaviour is visible at a glance. A test would mirror the source without catching anything review wouldn't.

5. **Harness — is the test setup proportionate to the assertion?**
   - **Pass:** Assertion does the heavy lifting; setup is incidental.
   - **Fail:** Harness (mocks, providers, fake timers, scaffolding) dwarfs the assertion. The test mostly verifies that the harness was set up correctly.

### Pass 2 — Will this test actually catch a bug?

Once justified, answer all three before writing:

- **What assertion will I write?** What specific output, state change, or side effect will I check?
- **What input produces a detectably different result if the implementation is wrong?** If you can't answer this, you can't verify the behaviour at this level.
- **If the implementation were buggy, would this test actually fail?** If "no" or "only with very contrived input," go one level down and ask these questions again.

Find the level where behaviour is directly verifiable in inputs and outputs. That's where comprehensive coverage belongs (edge cases, boundaries, error paths). Then write one higher-level test that exercises a single path through the smaller unit, to verify wiring.

**Example — test lower:** A method processes items in batches; a sub-function splits items so no batch contains duplicate IDs. The public method's final result is the same regardless of batching, so a test on the public method cannot verify the splitting logic. Test the split function comprehensively; one integration test through the public method covers wiring.

**Example — test higher:** A function validates input and returns an error directly observable in the return value. Test the public function — don't extract validation into a helper just to unit-test it.

### Test hygiene

- **Name tests by behaviour, not implementation.** "rejects expired tokens" not "checks token.exp field".
- **One logical behaviour per test.** Multiple assertions about the same behaviour are fine; unrelated behaviours in one test are not.
- **Failure messages should be informative** without reading the test source.
- **When working in a test file, leave it better than you found it** — remove frivolous or redundant tests, consolidate overlapping cases, restructure tests that use complex setup to indirectly verify something that could be checked more directly.
