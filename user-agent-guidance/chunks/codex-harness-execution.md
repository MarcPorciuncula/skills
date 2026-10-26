---
id: codex-harness-execution
description: Codex sandbox escalation and configured execution boundaries.
---

## Codex Harness Execution

When the active execution harness is Codex, use its configured workspace, writable cache and credential roots, and allowed loopback services as the normal sandbox boundary.

- Request escalation upfront: Set `sandbox_permissions` to `require_escalated` on the first tool invocation when a command predictably needs public network access or external filesystem writes (`gh`, `gcloud`, `pulumi`, `git fetch/pull/push`, dependency installation, or tests fetching dependencies). Include the external destination or side effect in the justification. Submit escalation directly through the tool call; do not ask in chat first.
- Retry on unexpected sandbox denial: When an otherwise necessary command fails because the sandbox denied DNS, filesystem, or socket access, rerun the exact command once with `require_escalated`.
- Run confined commands normally: Do not request escalation for commands confined to the workspace, configured writable caches, credential stores, and allowed loopback services.
- Do not evade approval boundaries: Do not redirect caches, credentials, configuration, or tool state into `/tmp` or the workspace to avoid an escalation check.
- Obey Auto-review denials: When Auto-review denies an escalation, follow the denial. Use a materially safer alternative or stop and ask the user. Do not reshape commands solely to bypass the denial.
