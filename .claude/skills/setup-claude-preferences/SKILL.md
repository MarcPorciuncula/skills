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

1. Run `check-sync.py` to get a preliminary status report (MATCH / DRIFT / MISSING / ORPHAN). Treat its output as advisory: a DRIFT may be a false positive caused by conditional include markers (see below), and you should re-verify any chunk you intend to act on. Do **not** trust MATCH/MISSING blindly either if something looks off — re-read the live file when in doubt.
2. Read `chunks/INDEX.md` so you have the descriptions and advisory notes.
3. Read each chunk file the script flagged DRIFT or MISSING (and the corresponding region of the live file for DRIFT).
4. For each chunk:
   - **Match** — no action.
   - **Drift** — show a concise diff. Make an educated guess about which version is newer (git log on the chunk file vs. file mtime on the live copy) and recommend a direction, but defer to the user. Options: keep live, overwrite with chunk, or hand-edit.
   - **Missing** — offer to insert. Show the live file's existing H2 headings and ask where to place the new chunk (default: append at end).
5. Surface the ORPHAN H2 list so the user can decide whether to extract any into new chunks. Leave the content itself untouched.
6. Apply the user's choices. Each inserted or replaced chunk is written wrapped in its sentinels, preserving the chunk-file body verbatim.
7. Summarise what changed.

## Creating the file from scratch

If `~/.claude/CLAUDE.md` doesn't exist, create it by concatenating every chunk (each wrapped in its sentinels) in the order they appear in `INDEX.md`, separated by blank lines. No preamble, no top-level H1 — the user can add framing afterwards.

## Notes

- Advisory notes in `INDEX.md` are guidance, not rules. Surface them so the user knows which chunks may not apply, but don't skip chunks on their behalf.
- Keep diffs concise — full content on request, not by default.
- Never touch content outside sentinels, even if it looks like a drifted chunk.

## Conditional lines within a chunk

A chunk may contain HTML-comment markers like `<!-- include the next line only if the X skill is installed -->` that gate a single line or paragraph on the presence of another skill on this machine.

When rendering or updating such a chunk:

1. Check `~/.claude/skills/` for the named skill.
2. If installed, include the gated content verbatim (and keep the marker comment so future syncs can re-evaluate).
3. If not installed, omit both the marker and the gated content.
4. On a re-sync, treat a flip in installation state as drift and surface it to the user before applying.

Surface this decision in the diff so the user can override.
