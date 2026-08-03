---
id: running-tests
description: Match local verification to the change and use the narrowest scope that exercises it.
---

## Running Tests

Run the narrowest local verification that can exercise the change: a test file, name filter, package, or affected directory. Match the check type to what could have changed; do not run tests, lint, type checks, or builds that cannot produce a different result.

Expand only when a targeted result indicates wider impact or when the changed boundary is shared across packages. Use CI for the full repository suite when the PR workflow guarantees it.

Documentation, comments, and copy-only changes usually need review rather than automated verification. A clean rebase with no conflicts needs no local test run.
