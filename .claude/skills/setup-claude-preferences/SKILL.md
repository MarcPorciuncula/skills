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

Merge personal workflow preferences into `~/.claude/CLAUDE.md`.

Preference content lives in `chunks/`, one file per section, indexed by `chunks/INDEX.md`. In the rendered `~/.claude/CLAUDE.md`, each chunk is wrapped in HTML comment sentinels so drift can be detected on future runs. Content outside sentinels belongs to the user — never touch it.

## Chunk file format

`chunks/<id>.md`:

```
---
id: <stable-id>
description: <one-line description>
---

## Section Title

body; can nest to ### and deeper
```

The H2 heading is part of the body — there is no separate `title` field.

## Sentinel format in the rendered file

```
<!-- chunk:<id> -->
## Section Title

body
<!-- /chunk:<id> -->
```

## Process

1. Read `chunks/INDEX.md` and each `chunks/<id>.md`.
2. Read `~/.claude/CLAUDE.md` if it exists.
3. For each chunk, locate its `<!-- chunk:<id> -->` … `<!-- /chunk:<id> -->` pair in the live file:
   - **Match** — no action.
   - **Drift** — show a concise diff. Make an educated guess about which version is newer (git log on the chunk file vs. file mtime on the live copy) and recommend a direction, but defer to the user. Options: keep live, overwrite with chunk, or hand-edit.
   - **Missing** — offer to insert. Show the live file's existing H2 headings and ask where to place the new chunk (default: append at end).
4. List H2 sections in the live file that sit outside any sentinel. Leave them untouched, but surface the list so the user can decide whether to extract any into new chunks.
5. Apply the user's choices. Each inserted or replaced chunk is written wrapped in its sentinels, preserving the chunk-file body verbatim.
6. Summarise what changed.

## Creating the file from scratch

If `~/.claude/CLAUDE.md` doesn't exist, create it by concatenating every chunk (each wrapped in its sentinels) in the order they appear in `INDEX.md`, separated by blank lines. No preamble, no top-level H1 — the user can add framing afterwards.

## Notes

- Advisory notes in `INDEX.md` are guidance, not rules. Surface them so the user knows which chunks may not apply, but don't skip chunks on their behalf.
- Keep diffs concise — full content on request, not by default.
- Never touch content outside sentinels, even if it looks like a drifted chunk.
