---
id: running-tests
description: Local test and verification scope.
---

## Running Tests

Local verification provides tight feedback on the changed behavior; it does not duplicate repository-wide CI.

When verifying locally, run the narrowest check that can exercise the change: a test file, name filter, package, or affected directory. Match the check type to what could have changed; do not run tests, lint, type checks, or builds that cannot produce a different result.

When considering broader verification, expand only if a targeted result indicates wider impact or the changed boundary is shared across packages. When the PR workflow guarantees a full CI suite, rely on CI for repository-wide coverage.

Documentation, comments, and copy-only changes usually need review rather than automated verification. A clean rebase with no conflicts needs no local test run.
