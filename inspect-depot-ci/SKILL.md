---
name: inspect-depot-ci
description: >
  Inspect and diagnose Depot CI failures from their remote evidence before
  reproducing anything locally. TRIGGER when a failed check links to depot.dev,
  a check provider is unclear in a repository containing .depot/workflows, gh
  reports a CI result but cannot show its logs, or the user asks to investigate
  a Depot CI failure. SKIP GitHub Actions checks and local verification that is
  not prompted by remote CI.
---

# Inspect Depot CI

Always inspect remote Depot diagnostics and logs before running any local reproduction. Missing logs in `gh pr checks` only mean the check is hosted by Depot rather than GitHub Actions, not that logs are unavailable. If `depot` returns an authentication, authorization, or availability error, report that blocker directly instead of running the CI suite locally.

## Procedure

1. **Get the failed check's Depot URL:** If not already provided, fetch check links from GitHub:
   ```bash
   gh pr checks <pr> --json name,state,link
   ```
2. **Extract Depot identifiers from the URL:** Parse `<workflow-id>`, `<job-id>`, and `<attempt-id>` from URLs shaped like `/workflows/<workflow-id>?job=<job-id>&attempt=<attempt-id>`.
3. **Fetch remote diagnosis and confirm in raw logs:** Run `depot ci diagnose` using the narrowest identifier available (adding `--org <org-id>` if required), then verify the exact failing command and error in `depot ci logs`:
   ```bash
   depot ci diagnose --attempt <attempt-id>   # or --job <job-id> / --workflow <workflow-id>
   depot ci logs <attempt-id-or-job-id>       # add --job <job-key> --workflow <file> if ambiguous
   ```
4. **Reproduce locally only when needed and narrowly:** Run a local command only if the remote logs leave an open question that local execution can answer. Run only the specific failing test or command, never the full workflow or unrelated gates.
5. **Stay within task scope:** Fix or delegate only failures caused by or within the current task's scope; report unrelated pre-existing failures without expanding into unrequested branch-health work.
