---
id: task-tracking-dex
description: Dex task-tracking CLI conventions.
---

## Task Tracking: `dex`

- `dex` refers to the local task tracker CLI (`dex list`, `dex show`, `dex create`, `dex start`, `dex complete`), not a repository; data lives at `~/.dex-data/<project>/` or `.dex/`.
- Load `dex` (if available) when decomposing or orchestrating multi-step work. Never include ephemeral `dex` task IDs in commit messages or PR bodies.
