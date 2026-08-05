# Conditional PR mechanics

Read only the sections that apply to the PR.

## Revising an existing body

Read the current body before editing it. Treat ordinary agent-authored prose as replaceable, but preserve these artifacts byte-for-byte unless the user explicitly asks to change them:

- a `Human overview`, `Human notes`, or similarly marked human-authored section;
- screenshots, clips, and uploaded media;
- content delimited by tool or agent markers such as HTML comments.

Never create a human-labelled section for your own writing.

Retain verified motivation, constraints, and consequential decisions from the existing body when they still describe the final change. Re-home each one beside the flow or boundary it explains; do not preserve the old section shape or discard the rationale only because a generic `Design` section is removed.

Re-read the live title and body immediately before posting an asynchronous draft. If either changed after drafting began, stop and return the draft to the primary agent. Do not overwrite concurrent work with the stale snapshot.

## Posting

Draft through a file so the exact artifact can be reviewed and posted without shell-quoting damage.

```bash
gh pr create --title "<title>" --body-file <path>
gh pr edit <number> --title "<title>" --body-file <path>
```

When a fresh PR needs a concise initial body before the final review, create it
from a short body file. After the last planned code push, draft the final title
and body through a file and run the isolated cold-reader workflow from
`SKILL.md`. Re-check the live PR and head before posting the reviewed artifact.

## External references

Put references in a Markdown list so GitHub PR and issue references unfurl. Use one reference per item.

```markdown
- Closes [AI-1297 Add upload progress to the attachment picker](https://linear.app/<workspace>/issue/AI-1297)
- #1235
- owner/repo#1413
- Design: [Session storage rollout](docs/session-storage-rollout.md)
```

- Use bare `#1235` or `owner/repo#1413` list items for GitHub issues and PRs.
- Use full URLs for systems GitHub does not unfurl. Put the title in the link text.
- Link reviewer-facing tickets, issues, and design specifications. Omit author-facing implementation plans and task checklists.
- Ask the user when a workspace slug, URL shape, or title cannot be verified.

### Linear trigger words

Linear treats a recognized keyword next to a ticket ID as automation, not decoration.

Use a closing keyword only when this PR fully completes the ticket and should close it on merge:

- `close`, `closes`, `closed`, `closing`
- `fix`, `fixes`, `fixed`, `fixing`
- `resolve`, `resolves`, `resolved`, `resolving`
- `complete`, `completes`, `completed`, `completing`
- `implements`, `implemented`, `implementing`

Use a non-closing keyword for partial, follow-up, or incidental work:

- `ref`, `refs`, `references`
- `part of`
- `related to`
- `contributes to`
- `toward`, `towards`

Keep the keyword adjacent to the ID: `Closes AI-1234`, not `Closes the ticket AI-1234`. Do not invent synonyms.

## Stack or dependency

A stack and a dependency describe different boundaries.

| Relationship | Body treatment |
|---|---|
| The branch was based on another branch in the same repository, so git ancestry enforces merge order | `Stacked on #N.` |
| The branch is independent but cannot merge or deploy until another PR lands | Explain the dependency and required order |
| Another PR depends on this PR | Mention the consumer only when it helps explain the change; this PR is not blocked |

Preserve an existing `Stacked on #N` line after the parent merges because it records lineage. Change it only if the branch was rebased or reordered onto a different parent.

For an independent dependency, say what the other PR provides and whether the constraint is on merge or deploy:

```markdown
Depends on owner/repo#1413, which ships the schema consumed by the generated client here. Merge after #1413 lands on the base branch.
```

Cross-repository relationships are dependencies, never stacks.

When several stacked PRs are mechanical slices of one unit of work, a one-sentence pre-lede may state the shared intent. Do not enumerate the stack in the body; the stack tooling and references already carry the map.

## Merge and deploy blockers

Lead with a GitHub warning only when ignoring the condition can break a merge or deployment:

```markdown
> [!WARNING]
> Do not merge before owner/repo#1413 deploys. The client in this PR calls the schema that PR introduces; deploying this one first breaks request handling.
```

State both the blocking condition and what clears it. Carry the referenced PR in the external-reference list. Remove the warning when the blocker clears.

Do not use an alert for context, ordinary risk, or a stack's ancestry-enforced order.

## How to test

Include this section only when the reviewer needs PR-specific actions to reproduce or inspect the behavior. Use concrete commands, inputs, buttons, and expected results. Omit checkboxes, unit-test inventories, and generic commands that CI already runs.

```markdown
## How to test

1. Start the API with `task dev` and create an upload containing two files.
2. Cancel one file while the other continues.
3. Confirm the cancelled file remains available for retry and the second file completes.
```

## Title conventions

Follow the repository's recent merged titles when it consistently uses Conventional Commit prefixes, ticket IDs, or stack numbering.

- Prefix a direct ticket implementation when that is team convention: `AI-1234: Add upload cancellation`.
- Omit a ticket prefix for incidental or follow-up work; keep the reference in the body.
- Use stack numbering only for a real ordered stack.
- Keep type names, function names, paths, exhaustive qualifiers, and release bookkeeping out of the title unless they are the actual public boundary being changed.
