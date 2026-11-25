---
id: running-tests
description: Local test and verification scope.
---

## Running Tests

- Run the narrowest local check that exercises the change (specific test file, name filter, or package) and matches the change type; skip checks whose outcome cannot have changed.
- Expand beyond targeted checks only when results indicate wider impact or a shared boundary changed; rely on PR CI for full-suite coverage when guaranteed.
- Skip local automated verification for documentation, comment, and copy-only edits, and for conflict-free rebases.
<!-- include the next bullet only if the `inspect-depot-ci` skill is installed -->
- Before diagnosing a failed check linking to `depot.dev` (or an unclear provider in a repo with `.depot/workflows/`), load `inspect-depot-ci`.
