---
id: running-tests
description: Scope local test runs to changed files and neighbours; rely on CI for the full suite.
---

## Running Tests

Scope local test runs to the files you've touched and their immediate neighbours — the specific test files, package, or directory affected by your changes. Do not run the full repo-wide suite locally to validate a change.

**Why:** Full suites are slow, burn context on unrelated output, and duplicate work CI already does. Opening a PR always triggers the repo-wide suite, so full-suite coverage is guaranteed at the point it matters. Local runs are for tight feedback on the code you just wrote.

**How to apply:** Run the narrowest invocation that exercises your change — a single test file, a `-run`/`-k`/`--testNamePattern` filter, or the package directory. Expand scope only if a targeted run surfaces something that suggests wider impact (e.g., a shared helper changed, a failure hints at a cross-package regression). Rely on CI for the full sweep.
