---
id: task-tracking-dex
description: Dex task-tracking CLI conventions.
---

## Task Tracking: `dex`

`dex` is a persistent local task tracker. Task data is stored at `~/.dex-data/<project>/` or `.dex/`, and each repo has a `.dex/config.toml` symlink (created by `avm-bridge link`) that points `dex` at the right project.

When the user references `dex`, they mean the task tracker CLI (`dex list`, `dex show`, `dex create`, `dex start`, `dex complete`), not a repository. Load the `dex` skill (if available) when decomposing or orchestrating multi-step work in `dex`. Never include ephemeral `dex` task IDs in git commit messages or PR bodies.
