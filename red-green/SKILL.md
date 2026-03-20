---
name: red-green
description: >
  Red-green testing / TDD workflow. Use when the user mentions
  red-green testing, red-green, TDD, or test-driven development.
  Drives a disciplined red-green-refactor cycle: write failing tests
  first, commit them, then implement to make them pass.
---

# Red-Green Testing

A disciplined test-driven development workflow. Every logical change follows its own red-green-refactor cycle. A full implementation may produce multiple cycles: red, green, red, green, red, green.

## Autonomy

When asked to execute a red-green implementation, this is independent work — not coworking. Proceed autonomously: commit and push after each phase (red commit, push, green commit, push, etc.) without waiting for user input. Only stop to ask the user if you hit a genuine roadblock that requires their decision or intervention.

## Before writing any tests

### 1. Understand the change

Read the code being changed or added. Understand what behavior is being introduced or modified.

### 2. Examine the existing test suite

Thoroughly review the existing tests for the affected code. Determine what needs to be added, modified, or removed. This is an opportunity to:

- Remove frivolous or redundant tests
- Restructure tests that use complex setup to indirectly test something that could be verified more directly
- Consolidate overlapping test cases

### 3. Plan your verification strategy

For each behavior you need to test, answer these questions before writing anything:

- **What assertion will I write?** What specific output, state change, or side effect will I check?
- **What input produces a detectably different result if the implementation is wrong?** If you can't answer this, you can't verify the behavior at this level.
- **If the implementation were buggy, would this test actually fail?** If the answer is "no" or "only with very contrived input," you're testing at the wrong level — go one level down and ask these questions again.

Once you find the level where behavior is directly verifiable in a function's inputs and outputs, that's where comprehensive test coverage belongs (edge cases, boundary conditions, error paths). Then write at least one higher-level test that exercises one path through the smaller unit, to verify the integration/wiring.

**Example — test lower:** A method processes items in batches. A sub-function splits items so no batch contains duplicate IDs. The public method produces the same final result regardless of how batches are split — a test on the public method cannot verify the splitting logic. Test the split function comprehensively, and add one integration test through the public method for wiring.

**Example — test higher:** A function validates input and returns an error. The error is directly observable in the return value. Test the public function — don't extract validation into a helper just to unit-test it.

## Red phase

1. Write or modify tests according to your verification plan. Add, change, or remove tests as needed.
2. **Tests MUST compile.** A test that doesn't compile is not "running red" — it's not running at all. Use real types, valid imports, and correct syntax. Stub or zero-initialize values where the implementation doesn't exist yet, but the test code itself must be valid.
3. Run the tests. Verify they **fail for the right reason** — the behavior doesn't exist yet, not a setup error, wrong import, or misconfigured test harness. The failure message should clearly point to the missing behavior.
4. Commit the failing tests with a message describing what's being tested, e.g. `Add tests for batch deduplication` or `Update validation tests for new error cases`. Push the branch.

## Green phase

1. Write the **minimum code** to make the failing tests pass. No speculative code, no extra features.
2. Run the full test suite — all tests must pass, not just the new ones.
3. Commit the implementation with a normal descriptive message, e.g. `Implement batch deduplication` or `Add input validation for expired tokens`. Push the branch.

## Refactor phase

After green, clean up both production and test code while keeping tests passing. This is optional — only refactor if there's something to improve. If you do refactor, commit separately.

## Phased implementation

Do NOT write all tests for the entire change upfront. Break the implementation into logical steps. Each step gets its own red-green-refactor cycle:

1. Plan the sequence of logical changes needed
2. For the first logical change: red → green → refactor
3. For the next logical change: red → green → refactor
4. Repeat until the full implementation is complete

Each cycle should be small and focused. If you're writing more than a handful of related tests before implementing, the cycle is probably too large — split it.

## Test quality

- **Test names describe behavior, not implementation.** "rejects expired tokens" not "checks token.exp field".
- **One logical behavior per test.** Multiple assertions about the same behavior are fine. Testing unrelated behaviors in one test is not.
- **Failure messages should be informative.** When a test fails, the output should make it obvious what went wrong without reading the test source.
