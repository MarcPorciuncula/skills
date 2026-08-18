---
name: manage-user-agent-guidance
description: >
  Manage chunked user-level agent guidance across supported harness files.
  Use when the user asks to set up, update, compare, or synchronize their
  user-level instructions, CLAUDE.md, or AGENTS.md. Skip repository-scoped
  guidance and skills.
---

# Manage User Agent Guidance

Merge repository-owned workflow guidance into a supported user-level guidance file.

Canonical content lives in `user-agent-guidance/chunks/`, one file per section, indexed by `user-agent-guidance/chunks/INDEX.md`. Each rendered chunk is wrapped in HTML comment sentinels so later runs can detect drift.

## Select the target

Use the file named by the user. Otherwise use the active harness's user-level guidance file:

| Harness | Guidance file | Skills directory |
|---|---|---|
| Claude Code | `~/.claude/CLAUDE.md` | `~/.claude/skills/` |
| Codex | `~/.codex/AGENTS.md` | `~/.codex/skills/` |

When the active harness is unclear, ask which guidance file to manage. Process one target at a time. Repeat the process when the user requests multiple targets.

## Chunk file format

`user-agent-guidance/chunks/<id>.md`:

```
---
id: <stable-id>
description: <short label describing the chunk's contents>
---

## Section Title

body; can nest to ### and deeper
```

The H2 heading is part of the body. The description is inventory metadata, not a trigger or an abridged instruction. Use a noun phrase that signposts the chunk's subject.

## Sentinel format

```
<!-- chunk:<id> -->
## Section Title

body
<!-- /chunk:<id> -->
```

## Process

1. Run `.claude/skills/manage-user-agent-guidance/check-sync.py <guidance-file>` for a preliminary MATCH / DRIFT / MISSING / ORPHAN report. Treat the report as advisory. Conditional lines and placeholders can produce false drift, and malformed live content can hide missing chunks.
2. Read `user-agent-guidance/chunks/INDEX.md` for descriptions and advisory notes.
3. Read each chunk reported as DRIFT or MISSING. For DRIFT, also read the corresponding live region.
4. Classify each chunk:
   - **Match:** take no action.
   - **Drift:** show a concise diff. Compare the chunk's Git history with the live file's modification time, recommend a direction, and let the user choose keep live, overwrite with chunk, or hand-edit.
   - **Missing:** use the index note and machine capabilities to recommend include or skip. Show existing live H2 headings for proposed insertions and ask where to place them. Default to the end.
5. Surface ORPHAN H2 headings for possible extraction into new chunks. Leave their content untouched.
6. Apply the user's choices. Preserve each inserted or replaced chunk body verbatim inside its sentinels.
7. Summarize the changes.

## Create a guidance file

When the target does not exist:

1. Evaluate every chunk against its advisory note, the selected harness, and installed skills and tools.
2. Show the proposed chunks to include and skip. State the reason for each skip.
3. Confirm the selection before creating the target.
4. Render selected chunks in index order, separated by a blank line and wrapped in sentinels. Apply conditional-line and placeholder rules.

Do not add a preamble or top-level H1. The user can add unmanaged framing separately.

## Conditional content

A chunk may contain an HTML comment that gates the next line or paragraph on a named skill being installed.

1. Check the selected harness's skills directory for the named skill.
2. When installed, include the gated content verbatim and keep the marker so later runs can re-evaluate it.
3. When absent, omit the marker and gated content.
4. When installation state changes, report drift before applying the change.

Show conditional-content changes in the diff so the user can override them.

## Placeholder substitution

A chunk may contain `{{PLACEHOLDER}}` tokens. Keep tokens literal in the chunk source and substitute them only in rendered guidance.

Current placeholders:

- **`{{USER_NAME}}`:** preferred name in AI-assisted attribution labels.

When applying a chunk with placeholders:

1. Recover each value from the existing rendered chunk. Ask only when no value is available.
2. Substitute every occurrence in the rendered output.
3. Leave the chunk source unchanged.

When checking drift, reverse the substitutions before comparing. If no other difference remains, treat the chunk as matching.

## Boundaries

- Advisory notes guide recommendations. The user decides which chunks are rendered.
- Keep diffs concise. Show full content only on request.
- Never modify content outside sentinels.
