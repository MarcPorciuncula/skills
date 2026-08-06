---
name: red-green
description: >
  Compatibility entry point for explicit red-green or TDD requests. TRIGGER
  when the user invokes `red-green`, asks for committed red-green history, or
  explicitly requests test-driven development. SKIP ordinary implementation
  and test work; the `testing` skill owns those triggers.
---

# Red-green compatibility entry point

Read `../testing/SKILL.md` and use its red-green workflow. Test admission comes
first. When no proposed test passes admission, report the no-test decision and
do not manufacture a failing test.
