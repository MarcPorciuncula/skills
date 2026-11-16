---
name: testing
description: >
  Test admission, design, cleanup, and red-green workflow. TRIGGER before the
  first production-code edit for a behaviour change or bug fix; before creating
  or modifying tests; when reviewing whether tests are valuable, redundant, or
  missing; or when the user requests tests, TDD, or red-green. SKIP while an
  explicitly activated visual-iteration workflow remains in its disposable
  visual-staging phase; for documentation, copy, formatting, or generated-only
  changes; and when running an already-selected test command without changing
  test design.
---

# Testing

A test is a permanent maintenance commitment. Admit each test before applying TDD; `No test` is a valid first-class outcome, including for bug fixes that only touch obvious glue or library usage.

If an explicitly activated `visual-iteration` workflow is in its disposable staging phase, ignore this skill until the user exits visual iteration.

## 1. Discover the local test surface

Before editing, inspect the affected code and neighbouring tests to identify the repository's actual test framework and narrow verification commands. Never assume commands from another project.

## 2. Apply test admission

Admit a proposed test only when **every** criterion holds:

1. **Worth maintaining:** The behaviour is a correctness requirement or functional contract, not an optimisation or cleanup preference.
2. **Non-trivial product logic:** The test exercises real domain or product logic rather than a framework/library contract, source structure, or trivial glue.
3. **Deterministic:** The behaviour can be asserted without timing, scheduling, or ordering flakiness (unless concurrency/timing is the contract under test).
4. **Non-obvious from the diff:** A plausible regression would not already be immediately obvious from reading the implementation diff.
5. **High signal-to-harness ratio:** The assertion carries more value than the mocks, providers, fixtures, or harness required to reach it.

When any criterion fails, choose `No test` and proceed with the production change without manufacturing coverage. (If the user explicitly asks for a specific test that fails admission, implement it and note which criterion it would otherwise fail.)

## 3. Audit existing coverage and publish the `Test decision`

Before making the first test or production edit (and before returning an assessment in review-only work), audit related tests in the touched area and publish this compact decision block in chat:

```text
Test decision
- Behaviour: <contract being changed>
- Existing tests:
  - <test name>: <keep | remove | consolidate> (<distinct failure caught, or the test it duplicates>)
- Decision: <add | modify | remove | consolidate | no test>
- Level: <direct unit/domain test | component exception | wiring test> (or failed admission criterion for `no test`)
- Failure proof: <input, assertion, and plausible product bug that makes it fail>
```

- **Name each related test or table case individually:** Every retained test must catch a distinct plausible defect. When two tests fail for the same defect through the same call path, mark one for removal or consolidation before adding new cases.

## 4. Choose the lowest direct level

Test at the lowest boundary where the contract is directly observable:

- Keep mapping, validation, and state-transition tests at the owning pure function or domain service.
- Add at most one higher-level wiring test when non-obvious integration cannot be observed at the unit/domain level; do not repeat the happy path across every layer.
- Do not extract trivial code solely to make it unit-testable.
- For UI components, routes, hooks, JSX, or browser interactions, read [references/frontend.md](references/frontend.md) before admitting a component test.

## 5. Execute and reconcile

- **Red-green execution:** When an admitted test accompanies a production behaviour change, follow [references/red-green.md](references/red-green.md) (confirm the test fails for the expected missing behaviour before editing production code). When modifying tests without changing production behaviour, confirm each assertion distinguishes a plausible bug without breaking production code just to manufacture a red phase.
- **Reconcile the test area:** After the change passes, apply the removals and consolidations recorded in your `Test decision` and run only the narrow verification commands for the touched scope. In code reviews, flag any diff that adds or modifies tests in an area without reconciling adjacent duplicate coverage.
