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

## Posting and review focus comments

Draft through a file so the exact artifact can be reviewed and posted without shell-quoting damage:

```bash
gh pr create --title "<title>" --body-file <path>
gh pr edit <number> --title "<title>" --body-file <path>
```

Keep file-by-file reading order out of the PR body. When the repository uses a separate `Review focus` PR comment (such as `pr-handoff`), maintain a single `<!-- review-focus -->` comment with a grouped reading-order table rather than listing files in the PR body or posting a new comment on each push.

## Framing and attaching screenshots

Never commit screenshots to the repository solely to embed them in a PR body. Upload them with `gh pr create --attach` or `gh pr edit --attach` (if the installed `gh` CLI lacks `--attach`, update `gh` first).

### 1. Capture the target region with context padding

Crop to the changed UI component or region with 24 to 48px of surrounding padding rather than capturing a mostly empty full-screen viewport. In Puppeteer or Playwright, compute the element's bounding box and expand the clip rectangle:

```js
const rect = await page.locator('<selector>').boundingBox();
const pad = 32;
await page.screenshot({
  path: '/tmp/opencode/raw-crop.png',
  clip: {
    x: Math.max(0, Math.floor(rect.x - pad)),
    y: Math.max(0, Math.floor(rect.y - pad)),
    width: Math.ceil(rect.width + pad * 2),
    height: Math.ceil(rect.height + pad * 2),
  },
});
```

### 2. Pad tall or narrow crops to a ~16:9 frame

GitHub scales standalone portrait or square images (`width / height < 1.4`, such as side rails, dialogs, popovers, or mobile viewports) across the full PR column width. Before attaching a narrow crop, composite it onto a ~16:9 canvas with neutral background padding that contrasts subtly with the component surface (for example, `#f5f4f0` behind a white light-mode surface, or `#141413` behind a dark-mode surface):

**Option A: `ffmpeg` (when installed)**

```bash
# Pads any narrow image out to a 16:9 canvas with at least 48px vertical margin
ffmpeg -y -i /tmp/opencode/raw-crop.png \
  -vf "pad='max(iw+96,ceil((ih+96)*16/9/2)*2)':'ceil((ih+96)/2)*2':'(ow-iw)/2':'(oh-ih)/2':color=#f5f4f0" \
  /tmp/opencode/framed-shot.png
```

**Option B: In-browser HTML canvas (zero external CLI dependencies)**

When capturing through a headless or host browser, composite the PNG buffer onto a 16:9 `<canvas>` inside `page.evaluate` or stage the target component centered inside a `1312x738` (`16:9`) container with `background: #f5f4f0` before taking the clip screenshot.

### 3. Attach inline with `gh pr`

Include a local Markdown image link in the body file and pass the same path to `--attach`. GitHub CLI uploads the image and replaces the local path with the hosted asset URL:

```markdown
![Light-mode workflow run sidebar](/tmp/opencode/framed-shot.png)
```

```bash
gh pr edit 123 --body-file /tmp/opencode/pr-body.md --attach /tmp/opencode/framed-shot.png
```

To append a screenshot without replacing the existing PR body:

```bash
gh pr edit 123 --attach '/tmp/opencode/framed-shot.png#Light-mode workflow run sidebar'
```

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
