---
id: code-removal-and-refactoring
description: Delete internal code rather than deprecate it; update all call sites atomically.
---

## Code Removal and Refactoring

When refactoring or removing code in internal codebases:

- **DO NOT mark internal code as deprecated** - this is not a public API
- **Update all consumers directly** and delete the old code in the same change
- You control all call sites in the codebase, so update them
- If code becomes unused, **delete it completely** - don't mark it deprecated or leave it orphaned

**Exception:** Only use deprecation for internal code when:
- There are many consumers (>10-15) and updating them would bloat the PR scope
- The user explicitly requests limiting the scope to avoid touching too many files
- Even then, ask first rather than assuming deprecation is preferred

**Before invoking this exception, count the call sites** — grep for usages, don't estimate. If you find yourself thinking "there are probably more than 10," that's not the exception condition. The exception requires actually having more than 10.

**The principle:** Deprecation is for maintaining backwards compatibility in public APIs. Internal codebases should evolve atomically - when you change something, update all its uses.
