---
name: testing
description: >
  Test admission, design, cleanup, and red-green workflow. TRIGGER before the
  first production-code edit for a behaviour change or bug fix; before creating
  or modifying tests; when reviewing whether tests are valuable, redundant, or
  missing; or when the user requests tests, TDD, or red-green. SKIP for
  documentation, copy, formatting, generated-only changes, and running an
  already-selected test command without changing test design.
---

# Testing

A test is a permanent maintenance commitment. Admit the test before applying
TDD. No new test is a valid outcome.

## Procedure

### 1. Discover the local test surface

Before editing, read the repository guidance and the affected code and tests.
Identify the actual test framework and the narrow commands used by the
repository. Do not infer them from another project.

### 2. Apply test admission

Admit a proposed test only when every criterion passes:

- The behaviour is a correctness requirement or functional contract worth
  maintaining, not an optimisation or cleanup preference.
- The test exercises non-trivial product logic rather than a library contract,
  source structure, or readable glue.
- The behaviour can be tested deterministically without timing, scheduling, or
  ordering fragility, unless those semantics are the product behaviour.
- A plausible regression would not already be obvious from the implementation
  diff.
- The assertion carries more value than the mocks, providers, fixtures, timers,
  or other harness needed to reach it.

When any criterion fails, choose `No test`. Continue the requested production
change without manufacturing coverage. An explicit user requirement to add a
specific test overrides admission; record which criterion it would otherwise
fail.

### 3. Record the test decision

Publish this artifact before the first test or production edit:

```text
Test decision
- Behaviour: <contract being changed>
- Existing tests:
  - <test name>: <keep, remove, or consolidate> — <distinct failure caught,
    or the test it duplicates>
- Decision: <add, modify, remove, consolidate, or no test>
- Level: <direct unit/domain test, component exception, or wiring test>
- Failure proof: <input, assertion, and plausible bug that makes it fail>
```

For `No test`, replace `Level` and `Failure proof` with the failed admission
criterion. Keep one entry per independent behaviour.

Name each related test or table case; do not summarize them as coverage to
keep. A kept test must catch a distinct plausible defect. When two tests fail
for the same defect through the same call path, designate one for removal or
consolidation before adding coverage. Do not list unrelated tests.

For review-only work, publish the named `Existing tests` audit before the final
assessment even though no edit follows it. Do not return `Clean` until every
related retained test has a distinct failure proof.

### 4. Choose the direct level

Test at the lowest level where the contract is directly observable.

- Keep mapping, validation, and state-transition coverage at the owning pure or
  domain boundary.
- Add at most one higher-level test when non-obvious wiring cannot be observed at
  the lower level.
- Do not repeat a happy path through every layer.
- Do not extract trivial production logic solely to make it testable.
- Keep one logical behaviour per test and name it by that behaviour.

For components, routes, hooks, JSX, or browser interactions, read
`references/frontend.md` before choosing the level.

### 5. Run the admitted workflow

When an admitted test accompanies a production behaviour change, read
`references/red-green.md` and follow it before implementation.

When the request changes tests without changing production behaviour, prove
that each assertion distinguishes a plausible wrong result. Do not alter
production code solely to manufacture a red phase.

### 6. Reconcile the test area

After the behaviour passes:

- Apply the removals and consolidations recorded in the test decision.
- Remove related assertions that became redundant or indirect.
- Consolidate cases that protect the same contract through the same path.
- Keep distinct cases when they catch distinct plausible failures.
- Re-run only the narrow checks selected by repository verification guidance.

Update the test-decision artifact when implementation changes the intended
coverage.

In review-only work, report retained redundancy as a finding when the diff adds
or modifies coverage in that test area. The duplicate may predate the diff; the
failure is adding or changing nearby coverage without reconciling it.

## Red flags: STOP

| Thought | Response |
|---|---|
| "This is a bug fix, so it automatically needs a regression test." | Apply admission. Some fixes are obvious glue or library usage and do not earn permanent coverage. |
| "TDD means I should cover every edge and error path." | Admit each behaviour separately. TDD controls sequence after admission, not coverage quantity. |
| "Another layer would make this safer." | Add a wiring test only when lower-level coverage cannot expose a plausible wiring failure. |
| "I touched this test file, so I can add my case and leave the rest alone." | Audit related coverage and record what to remove or consolidate before editing. |
| "The duplicate predates this diff, so review should ignore it." | If this diff changes coverage in the same test area, report the missed reconciliation. |
| "The implementation is small, so I can write the admitted test afterwards." | An admitted production behaviour follows the red-green reference regardless of implementation size. |

**Violating the letter of these rules is violating the spirit of them.**
