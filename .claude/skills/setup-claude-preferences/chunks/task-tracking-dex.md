---
id: task-tracking-dex
description: `dex` is a task tracking CLI — data lives under `~/.dex-data/<project>/`. Opt-in; only apply for users who use dex.
---

## Task Tracking: `dex`

`dex` is a task tracking CLI. Task data is stored at `~/.dex-data/<project>/`, and each repo has a `.dex/config.toml` symlink (created by `avm-link`) that points dex at the right project.

When the user references "dex" they mean the task tracker, not a repo. Use `dex list`, `dex show`, `dex create`, etc. Do not clone a dex repo.
