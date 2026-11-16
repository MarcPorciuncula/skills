---
id: running-tests
description: Local test and verification scope.
---

## Running Tests

Local verification provides tight feedback on changed behavior; it does not duplicate repository-wide CI.

When verifying locally, run the narrowest check that exercises the change: a specific test file, name filter, package, or affected directory. Match the check type to what could have changed; do not run tests, lint, type checks, or builds that cannot produce a different result.

Expand verification beyond targeted checks only if a result indicates wider impact or the changed boundary is shared across packages. When the PR workflow guarantees a full CI suite, rely on CI for repository-wide coverage.

Skip automated verification for documentation, comments, and copy-only changes. A clean rebase with no conflicts requires no local test run.

<!-- include the next paragraph only if the `inspect-depot-ci` skill is installed -->
Before diagnosing or reproducing a failed check whose details link to `depot.dev`, or whose provider is unclear in a repository containing `.depot/workflows/`, load the `inspect-depot-ci` skill.
