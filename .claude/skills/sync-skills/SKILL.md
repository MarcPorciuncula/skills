---
name: sync-skills
description: >
  Compare skills installed on the machine with skills in this repo, identify
  differences, suggest updates in either direction, and offer to install new
  skills. Use when the user says "sync skills", "update skills", "check skills",
  or similar.
allowed-tools: [Bash, Read, Glob, Grep, Edit, Write, Agent]
---

# Sync Skills

Compare the skills installed on this machine (`~/.claude/skills/` and `~/.claude/commands/`) with the skills stored in this repo, then help the user reconcile differences.

## Step 1: Inventory

### Machine skills
- List all skills in `~/.claude/skills/*/SKILL.md`
- List all commands in `~/.claude/commands/*.md`
- For each, check if it's a symlink (`test -L`) and where it points (`readlink`)
- Read each file's content

### Repo skills
- List all skills in this repo (every `*/SKILL.md` or `*/*.md` file at the repo root, excluding `README.md`)
- Read each file's content

Build a combined list of all skill names from both sources.

## Step 2: Categorize each skill

For each skill name, determine which category it falls into:

### Symlinked
Present on both machine and repo, and the machine version is a symlink pointing to this repo. Already in sync — no action needed.

### Identical (copied)
Present on both machine and repo with the same content, but the machine version is a regular file (not a symlink). Recommend converting to a symlink for automatic sync.

### Different
Present on both but content differs (machine version is a regular file). Diff the two versions and determine which is likely newer:
- Check `git log` in the repo for the last commit date touching that skill
- Check file modification time on the machine via `stat`
- If one is clearly newer (e.g. repo was updated last week, machine file hasn't changed in months), recommend updating the older one
- If it's ambiguous, show the diff and ask the user which version they prefer or whether to merge
- After resolving, offer to convert to a symlink unless the user intentionally maintains a local copy

### Machine only
Exists on the machine but not in the repo. The user may want to add it to the repo.

### Repo only
Exists in the repo but not on the machine. The user may want to install it.

## Step 3: Present findings

Show a summary table:

| Skill | Status | Recommendation |
|-------|--------|----------------|
| red-green | Symlinked | — |
| update-branch | Identical (copied) | Convert to symlink |
| clean-workspaces | Different | Repo is newer → update machine, then symlink |
| my-custom-skill | Machine only | Add to repo? |
| setup-notifications | Repo only | Install to machine (symlink)? |

For skills with differences, show a concise summary of what changed (not the full diff unless the user asks).

## Step 4: Act on user decisions

Wait for the user to confirm which actions to take, then execute:

- **Update machine from repo (symlinked):** If the skill on the machine is already a symlink pointing to this repo, it's already in sync — no action needed. If it's a regular file, replace it with a symlink (see Install below).
- **Update machine from repo (local copy):** If the user explicitly wants a local copy (e.g. to customize for this machine), copy the repo version to the appropriate location. This is the exception, not the default.
- **Update repo from machine:** Copy the machine version into the repo, commit, and push. If the machine skill was a regular file, offer to replace it with a symlink now that the repo has the latest version.
- **Add new skill to repo:** Copy from machine to repo, commit, and push. Then offer to replace the machine copy with a symlink.
- **Install skill from repo:** Symlink the individual skill directory into `~/.claude/skills/`. For skills: `ln -s <repo>/<name> ~/.claude/skills/<name>`. For commands: `ln -s <repo>/<name>/<file>.md ~/.claude/commands/<name>.md`. Create parent directories if needed. Symlink each skill individually — do not symlink the entire skills directory, so that skills from other sources or machine-local skills can coexist.

### When to copy instead of symlink

If the user wants to modify a skill for the current machine only, they should replace the symlink with a regular copy (`cp -L` to dereference). This breaks the auto-sync for that skill, so future updates from the repo will need to be synced manually for that skill.

Batch all repo changes into a single commit.

## Notes

- The `setup-worktrees` skill lives in `~/.claude/commands/` on the machine (as `setup-worktrees.md`) but in `setup-worktrees/` in this repo. Handle this mapping — commands are flat files, skills use `SKILL.md` in a subdirectory.
- Skills that exist on the machine but are intentionally excluded from the repo (the user chose not to track them) should be offered but not pushed. If the user declines, don't ask again in the same session.
- This skill itself (`sync-skills`) is repo-only by design — it doesn't need to be installed on the machine since it runs from the repo.
