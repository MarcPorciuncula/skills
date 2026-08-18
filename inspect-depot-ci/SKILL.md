---
name: inspect-depot-ci
description: >
  Inspect and diagnose Depot CI failures from their remote evidence before
  reproducing anything locally. Use when a failed check links to depot.dev, a
  check provider is unclear in a repository containing .depot/workflows, gh
  reports a CI result but cannot show its logs, or the user asks to investigate
  a Depot CI failure. Skip GitHub Actions checks and local verification that is
  not prompted by remote CI.
---

# Inspect Depot CI

Remote CI output is the evidence for what failed. Local execution starts only
after that failure is known.

## Iron Law

NO LOCAL CI REPRODUCTION BEFORE DEPOT DIAGNOSIS OR LOGS.

If Depot itself returns an authentication, authorization, or availability
error, report that blocker. Do not substitute a local CI run.

## Diagnose the failure

1. Read the failed check's details URL. When necessary, get it from GitHub:

   ```bash
   gh pr checks <pr> --json name,state,link
   ```

2. Take the identifiers from the Depot URL. A URL shaped like
   `/workflows/<workflow-id>?job=<job-id>&attempt=<attempt-id>` supplies the
   values directly.

3. Retrieve the stored failure context:

   ```bash
   depot ci diagnose --workflow <workflow-id>
   depot ci diagnose --job <job-id>
   depot ci diagnose --attempt <attempt-id>
   ```

   Use the narrowest identifier available. Pass `--org <org-id>` when the CLI
   requires organization disambiguation.

4. Confirm the relevant command and error in the remote logs. A diagnosis is
   a summary and can be wrong.

   ```bash
   depot ci logs <run-id-or-job-id-or-attempt-id>
   ```

   Add `--job <job-key>` and `--workflow <workflow-file>` when a run ID is
   ambiguous.

5. Run a local reproduction only when the remote evidence leaves a question
   that local execution can answer. Run the identified failing command or the
   narrowest equivalent that preserves the failure. Do not recreate the full
   workflow or run unrelated jobs and gates.

6. Fix or delegate only failures in the current task's scope. Report unrelated
   failures; do not convert them into branch-health work unless the user or
   repository workflow authorizes it.

## Red flag

| Thought | Required response |
|---|---|
| "`gh` cannot show the logs, so I need to run the CI command locally." | The check is hosted by Depot. Use its details URL with `depot ci diagnose` and `depot ci logs`; missing GitHub logs say nothing about Depot access. |

Violating the letter of these rules is violating the spirit of them.
