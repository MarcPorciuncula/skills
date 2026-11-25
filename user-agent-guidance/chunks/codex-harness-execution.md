---
id: codex-harness-execution
description: Codex sandbox permission requests and configured path conventions.
---

## Codex Harness Execution

- In Codex, run commands confined to the workspace, configured writable caches, and allowed loopback services normally without requesting extra permissions.
- Set `sandbox_permissions` to `require_escalated` on the first call when a command predictably needs network access or external writes (`gh`, `gcloud`, `pulumi`, `git fetch/pull/push`, package installs, or network tests); include the destination or side effect in the justification and submit directly via the tool call.
- When a necessary command fails due to a sandbox DNS, filesystem, or socket restriction, retry the exact command once with `require_escalated`.
- Keep caches, tool state, and configuration in their configured paths rather than relocating them into `/tmp` or the workspace.
- When Auto-review declines a request, respect the decision; choose a safer alternative or ask the user.
