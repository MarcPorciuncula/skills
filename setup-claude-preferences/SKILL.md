---
name: setup-claude-preferences
description: >
  Set up user-level CLAUDE.md with personal workflow preferences (PR style,
  refactoring philosophy, commit behavior, etc.). Use when the user says
  "set up my claude preferences", "set up my claude.md", "set up my user instructions",
  or similar.
allowed-tools: [Bash, Read, Write, Edit]
---

# Set Up Claude Preferences

Apply the user's personal workflow preferences to their user-level `~/.claude/CLAUDE.md`.

## Important

The content below should be **merged into** the user's existing `~/.claude/CLAUDE.md`, not replace it. If the file already exists, read it first and integrate the sections below — don't duplicate content that's already present with equivalent intent.

If the file doesn't exist yet, create it with the content below as a starting point.

The user's `~/.claude/CLAUDE.md` is for personal cross-project preferences. Project-specific instructions belong in the project's own `CLAUDE.md`.

## Content to apply

```markdown
# User-Level Claude Instructions

## Pull Request Descriptions

When creating PR descriptions:

- Focus on **what** was done and **why**, not implementation details
- DO NOT list individual code-level edits (e.g., "Lines 17: Added X import", "Lines 27-48: Added helper function")
- DO NOT include detailed testing instructions or checklists - the code review will cover testing
- Keep it concise: Problem → Root Cause → Solution approach → High-level changes
- The commit message and code diff provide the implementation details

## Code Removal and Refactoring

When refactoring or removing code in internal codebases:

- **DO NOT mark internal code as deprecated** - this is not a public API
- **Update all consumers directly** and delete the old code in the same change
- You control all call sites in the codebase, so update them
- If code becomes unused, **delete it completely** - don't mark it deprecated or leave it orphaned

**Exception:** Only use deprecation for internal code when:
- There are many consumers (>10-15) and updating them would bloat the PR scope
- The user explicitly requests limiting the scope to avoid touching too many files
- Even then, ask first rather than assuming deprecation is preferred

**The principle:** Deprecation is for maintaining backwards compatibility in public APIs. Internal codebases should evolve atomically - when you change something, update all its uses.

## Refactoring and Cleanup

Follow the "leave it better than you found it" principle. When working in an area of the codebase, related cleanup and refactoring is expected and welcome — especially when:

- The original task changes are already committed (keeping fix vs. refactor in separate commits)
- The user is discussing, suggesting, or requesting the cleanup
- The refactor is in code directly related to what was just changed

**Do not push back on refactoring requests** by citing ticket scope, suggesting it belongs in a separate PR, or asking "are you sure?" when the user has clearly directed the work. If the user is asking for it, do it.

The distinction is:
- **Unsolicited refactoring:** Don't do this without asking — stay focused on the task
- **User-directed refactoring:** Proceed without hesitation — the user is explicitly expanding the scope

## Temporary Files

When you need to write temporary files (e.g., commit messages, scratch data for a command to read), write them in the current working directory/worktree — not in `/tmp`. Files in `/tmp` trigger a permission prompt every time. Write the file locally, use it, then delete it immediately. Never commit temporary files.

## Committing and Pushing

**Default: commit and push.** When the user directs work ("go ahead", "implement it", "proceed", "make that change", or any direct request without questions), complete the work, commit, and push without asking.

**Exception: "don't commit yet"** (or similar). Keep changes in the working tree. This holds until the user asks to commit or gives a new task.

**When a message mixes a request with a question or clarification**, the question takes priority. Answer or clarify first — don't start executing. The user may be setting context or planning, not giving the green light.

**Before committing, verify you're on the expected branch.** Run `git branch --show-current` and confirm it matches the branch you intended to work on. If it doesn't, stop and ask the user.

**Declare intent immediately.** When you begin executing work, your very first words should state whether you will commit and push or hold changes:
- "I'll work on this then commit and push."
- "I'll work on this and hold the changes for approval."
```

## Steps

1. Check if `~/.claude/CLAUDE.md` exists. If it does, read it.
2. Merge the content above into the file — add missing sections, skip sections that already exist with equivalent intent.
3. Write the result to `~/.claude/CLAUDE.md`.
4. Show the user what was added or changed.
