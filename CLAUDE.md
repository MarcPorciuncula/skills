# Agent Skills Repository

This repo stores reusable agent skills and user-level guidance shared across machines via GitHub.

## Structure

- **Root-level skill directories** (e.g. `address-review/`, `testing/`, `update-branch/`) are portable skills linked into each supported harness's user-level skills directory.
- **`user-agent-guidance/`** contains canonical chunks and examples for user-level agent guidance files.
- **`.claude/skills/`** contains repo-local utilities (e.g. `sync-skills`, `manage-user-agent-guidance`). Do not install these as user-level skills.
