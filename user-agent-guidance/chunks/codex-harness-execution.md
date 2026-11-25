---
id: codex-harness-execution
description: Codex sandbox permission requests, cache preservation, and policy feedback.
---

## Codex Sandbox

- For commands that need public network access (`gh`, `gcloud`, `pulumi`, `git fetch/pull/push`, or uncached package downloads), set `sandbox_permissions` to `require_escalated` on the first call with a brief justification.
- If a command hits a sandbox write restriction on a shared cache or tool state path, rerun it with `require_escalated` instead of redirecting cache or config env vars (`GOCACHE`, `GOPATH`, `XDG_*`, etc.) to a fresh directory.
- When a recurring local tool fails due to a missing filesystem write or loopback rule in the Codex sandbox, mention it in your response and recommend the exact path or domain to add to `~/.codex/config.toml`.
