---
name: red-green
description: >
  Compatibility entry point for explicit red-green or TDD requests. TRIGGER
  when the user invokes `red-green`, asks for committed red-green history, or
  explicitly requests test-driven development. SKIP ordinary implementation
  and test work; the `testing` skill owns those triggers if available.
---

# Red-green compatibility entry point

If `../testing/SKILL.md` is available, read it and use its red-green workflow.
Otherwise admit only a test that exercises a distinct behaviour or regression
risk, confirm that it fails for the expected reason, implement the smallest
change, and confirm that it passes. When no proposed test passes admission,
report the no-test decision and do not manufacture a failing test.
