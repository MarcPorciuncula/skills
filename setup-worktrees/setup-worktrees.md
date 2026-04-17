---
description: Set up a bare repo + worktrees workflow for a git repository
argument-hint: <repo-url> [directory-name]
allowed-tools: [Bash, Read, Write, Glob, Grep]
---

# Set Up Bare Repo + Worktrees

Set up a bare git clone with a worktree-based development workflow.

## Arguments

The user provided: $ARGUMENTS

Parse the repo URL and optional directory name. If no directory name is given, derive it from the repo URL (e.g. `org/my-repo.git` -> `my-repo`).

## Steps

### 1. Clone as bare repo

```bash
git clone --bare <repo-url> <directory-name>
cd <directory-name>
```

### 2. Fix remote fetch refspec

Bare clones don't automatically track remote branches. Fix this:

```bash
git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
git fetch origin
```

### 3. Set up hooks directory

**Important:** `core.hooksPath` must be an absolute path. Relative paths resolve from the `.git` directory, which for worktrees is `worktrees/<name>/` inside the bare repo — not the bare repo root. A relative path like `hooks` will silently fail to find the hooks from any worktree.

```bash
mkdir -p hooks
git config core.hooksPath "$(pwd)/hooks"
```

### 4. Create post-checkout hook

Write `hooks/post-checkout` with this content and make it executable (`chmod +x`):

```bash
#!/bin/sh
# Auto-symlink shared .claude/settings.local.json into new worktrees

BARE_DIR="$(git rev-parse --path-format=absolute --git-common-dir)"
SHARED_SETTINGS="$BARE_DIR/.claude/settings.local.json"
LOCAL_SETTINGS=".claude/settings.local.json"

# Only proceed if the shared settings file exists
if [ ! -f "$SHARED_SETTINGS" ]; then
    exit 0
fi

# Create .claude dir if needed (git checkout may not have created it yet)
mkdir -p .claude

# Symlink if not already present
if [ ! -e "$LOCAL_SETTINGS" ]; then
    ln -s "$SHARED_SETTINGS" "$LOCAL_SETTINGS"
fi
```

### 5. Create shared Claude Code settings

```bash
mkdir -p .claude
```

Create `.claude/settings.local.json` with an empty allowlist (the user will populate it):

```json
{
  "permissions": {
    "allow": [],
    "deny": []
  }
}
```

### 6. Initialize git-spice

```bash
git-spice repo init --trunk main
```

If `git-spice` is not available, skip this step and note that git-spice was not initialized.

### 7. Create README.md

Write a `README.md` in the bare repo root describing the setup. Follow this structure, adapting the repo name:

```markdown
# <repo-name> (bare repo)

This is a bare git clone of `<repo-url>` configured for a worktree-based workflow.

## Layout

```
<repo-name>/                   # Bare repo (this directory)
├── .claude/
│   └── settings.local.json   # Shared Claude Code permissions (symlinked into worktrees)
├── .envrc                     # Shared direnv config (create manually if needed)
├── hooks/
│   └── post-checkout          # Auto-symlinks .claude/settings.local.json into new worktrees
├── CLAUDE.md                  # Personal Claude Code instructions (loaded by all worktrees)
├── README.md                  # This file
├── <repo-name>-a/             # Worktree slot A
└── <repo-name>-b/             # Worktree slot B
```

## Creating a new worktree

```bash
cd <repo-name>
git worktree add <repo-name>-c <branch>
```

The `post-checkout` hook will automatically symlink `.claude/settings.local.json` from the bare repo into the new worktree.

git-spice state is stored in `refs/spice/` in the bare repo, so `git-spice repo init --trunk main` only needs to be run once — it applies to all worktrees.
```

### 8. Create CLAUDE.md

Write a `CLAUDE.md` in the bare repo root with starter content:

```markdown
# Personal Workflow Notes

This is a bare repo + worktrees setup. Worktrees live inside this bare repo directory.

Shared configuration lives in this bare repo root:
- `.envrc` — direnv environment config
- `.claude/settings.local.json` — Claude Code permissions (symlinked into each worktree)
- `post-checkout` hook handles symlinking settings into new worktrees automatically

See `README.md` in this directory for full setup details.

Any personal development workflow preferences that shouldn't be committed to the repo's tracked `CLAUDE.md` should go in this file (bare-repo root).

## Worktree Workflows

There are two approaches to working with worktrees:

### Slot-based (generic worktrees)

Generic slots like `<repo-name>-a`, `<repo-name>-b` are long-lived worktrees used for swapping between branches within a session.

**Caveat:** Only one worktree can have a given branch checked out at a time. If slot A has `main` checked out and slot B needs `main`, you must either:
- Move slot A to a different branch first, or
- Perform operations without physically checking out `main` (e.g. `git fetch` + ref-based operations)

### Dedicated worktree (branch-named)

Create a worktree with the same name as the branch:
```bash
git worktree add <branch-name> <branch>
```

Work happens entirely within that worktree for the lifetime of the branch. Remove the worktree when the branch is merged:
```bash
git worktree remove <branch-name>
```
```

### 9. Create initial worktree slots

```bash
git worktree add <repo-name>-a main
git worktree add <repo-name>-b main  # This will need a new branch since main is taken
```

For the second slot, create it on a temporary branch off main:

```bash
git worktree add <repo-name>-b -b <repo-name>-b-temp main
```

Or ask the user which branch they want for slot B.

### 10. Summary

After setup, print a summary of what was created and any manual steps remaining (e.g. creating `.envrc`, populating Claude Code permissions).
