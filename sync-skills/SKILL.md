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
- Read each file's content

### Repo skills
- List all skills in this repo (every `*/SKILL.md` or `*/*.md` file at the repo root, excluding `README.md`)
- Read each file's content

Build a combined list of all skill names from both sources.

## Step 2: Categorize each skill

For each skill name, determine which category it falls into:

### Identical
Present on both machine and repo with the same content. No action needed.

### Different
Present on both but content differs. Diff the two versions and determine which is likely newer:
- Check `git log` in the repo for the last commit date touching that skill
- Check file modification time on the machine via `stat`
- If one is clearly newer (e.g. repo was updated last week, machine file hasn't changed in months), recommend updating the older one
- If it's ambiguous, show the diff and ask the user which version they prefer or whether to merge

### Machine only
Exists on the machine but not in the repo. The user may want to add it to the repo.

### Repo only
Exists in the repo but not on the machine. The user may want to install it.

## Step 3: Present findings

Show a summary table:

| Skill | Status | Recommendation |
|-------|--------|----------------|
| red-green | Identical | — |
| update-branch | Different | Repo is newer → update machine |
| my-custom-skill | Machine only | Add to repo? |
| setup-notifications | Repo only | Install to machine? |

For skills with differences, show a concise summary of what changed (not the full diff unless the user asks).

## Step 4: Act on user decisions

Wait for the user to confirm which actions to take, then execute:

- **Update machine from repo:** Copy the repo version to the appropriate location (`~/.claude/skills/<name>/SKILL.md` or `~/.claude/commands/<name>.md`). Preserve the original directory structure — skills with `SKILL.md` go in a subdirectory, commands go as flat `.md` files.
- **Update repo from machine:** Copy the machine version into the repo, commit, and push.
- **Add new skill to repo:** Copy from machine to repo, commit, and push.
- **Install skill from repo:** Copy from repo to `~/.claude/skills/<name>/SKILL.md` on the machine. Create the directory if needed.

Batch all repo changes into a single commit.

## Notes

- The `setup-worktrees` skill lives in `~/.claude/commands/` on the machine (as `setup-worktrees.md`) but in `setup-worktrees/` in this repo. Handle this mapping — commands are flat files, skills use `SKILL.md` in a subdirectory.
- Skills that exist on the machine but are intentionally excluded from the repo (the user chose not to track them) should be offered but not pushed. If the user declines, don't ask again in the same session.
- This skill itself (`sync-skills`) is repo-only by design — it doesn't need to be installed on the machine since it runs from the repo.
