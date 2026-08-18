---
id: codex-harness-execution
description: Codex sandbox escalation and configured execution boundaries.
---

## Codex Harness Execution

When the active execution harness is Codex, use its configured workspace,
writable cache and credential roots, and allowed loopback services as the
normal sandbox boundary.

- Set `sandbox_permissions` to `require_escalated` on the first invocation
  when a command predictably needs public network access or writes outside
  the configured roots. Include the external destination or side effect in
  the justification. Submit the escalation through the tool call; do not ask
  in chat first.
- Escalate networked `gcloud`, `gh`, and `pulumi` commands; `git fetch`, `git
  pull`, and `git push`; dependency installation; and tests or builds expected
  to fetch missing dependencies. Run tests and builds normally when existing
  dependencies and configured caches suffice.
- When an otherwise necessary command unexpectedly fails because the sandbox
  denied DNS, filesystem, or socket access, rerun the exact command once with
  `require_escalated`.
- Do not request escalation for commands confined to the workspace,
  configured writable caches or credential stores, and allowed loopback
  services.
- Do not redirect caches, credentials, configuration, or tool state into
  `/tmp` or the workspace to evade an approval boundary.
- When Auto-review denies an escalation, follow the denial. Use a materially
  safer alternative or stop and ask the user. Do not reshape the command
  solely to bypass the denial.
