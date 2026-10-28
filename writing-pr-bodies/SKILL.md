---
name: writing-pr-bodies
description: >
  Write or revise a pull request title or body as a standalone review brief.
  TRIGGER before any `gh pr create`, `gh pr edit --body`, `gs branch submit`,
  `git-spice branch submit`, or other command that opens or updates a pull
  request body. SKIP for non-body PR operations such as readying, merging,
  labelling, or assigning reviewers, and for commit messages.
---

# Writing PR titles and bodies

If `writing-persistent-content` is available, load it before drafting and select its internal technical profile. That profile owns prose register; this skill owns the PR body's scope, shape, visual rhythm, and posting workflow.

Write for a senior engineer who knows the codebase but has not read the ticket, branch history, diff, or implementation discussion. Optimize for a quick human scan: put the load-bearing model in the title, opening, headings, diagrams, and bullet leads, and leave routine detail in the diff.

## First-draft rules

Every PR title and body must satisfy these rules on the first draft:

- **Open with a present-active PR verb:** Start the first agent-authored sentence with what the PR changes (`Adds`, `Updates`, `Replaces`, `Moves`, `Removes`, `Prevents`). Never open with `<Subject> now <verb>s...` (`Human checklist items now appear as...`) or `This PR...`.
- **Foreground contract and schema deltas as diff snippets:** Whenever a PR adds, modifies, or removes database tables/columns/indexes, protobuf/RPC methods or messages, public API payloads, or job/event schemas, render an abridged before/after diff block (`+`, `-`, `~`) showing the exact field, method, or column names and types. Never hide contract or schema changes inside prose summaries.
- **Match body shape to scope:** Use the simplest tier in **Size and shape** below. Do not turn a small fix or visual cleanup list into a multi-section document.
- **Break up dense prose:** Keep paragraphs to 3 sentences or fewer. Never write more than 2 consecutive prose paragraphs without a visual break (heading, bullet list, table, diff/schema block, or diagram). Never list 3 or more inline file paths, RPCs, or identifiers inside a prose sentence. Do not hard-wrap prose or bullets across source lines.
- **Bound bullet lists:** Keep bullet lists to 2 to 6 items, one sentence per item, with no nested sub-bullets. Use bold lead-in stems (`- **Surface:** ...`) when items describe distinct surfaces, components, or guarantees.
- **Omit banned sections and footers:** Never add `Summary`, `What changed`, `Design`, `Validation:`, `Testing:`, `Verification:`, `Test plan`, unit/CI/linter pass recaps, diff statistics, AI attribution, or file/identifier inventories in the PR body. When the repository uses a separate `Review focus` PR comment, put the reading-order file table there.

## Size and shape

Choose the body tier before drafting. Diff line count does not decide the tier.

| PR scope | Body shape | Cold-reader critic |
|---|---|---|
| **Small single-idea change** (focused bug fix, guard, or small behaviour tweak with no new boundary) | 1 to 2 short paragraphs, no headings | Skip |
| **Focused multi-item polish or cleanup** (2 to 6 related UI, copy, styling, or ergonomic adjustments with no new architecture) | 1-sentence framing line followed by 2 to 6 one-sentence bullets, plus framed screenshots when visual | Skip |
| **Substantial feature, contract, or architectural change** | Opening lede (plus optional 2 to 5 headline bullets), then subject-specific sections for changed surfaces and consequential architecture | Run before final body handoff |

## Classify the primary change

Classify substantial PRs before choosing sections:

| Primary change | Title, opening, and first part of the body |
|---|---|
| **Functional** (affects user- or consumer-visible behaviour, UI surfaces, or public/developer API contracts) | Lead with changed surfaces, consumer-visible behaviour, contracts, affordances, states, and limitations. Put consequential internal architecture in a separate section after the functional account. |
| **Non-functional** (changes internal boundaries, flows, storage, or operations while preserving consumer-visible behaviour) | Lead with the changed architecture, contract, ownership, or runtime boundary. |
| **Mixed** | Lead with the functional or non-functional change that explains why the PR exists. |

Do not interleave product behaviour with implementation mechanics. Omit an architecture section when no consequential internal boundary changes.

## Compose the body

### Titles

Use a specific imperative verb and object (`Add X`, `Fix Y when Z`, `Move A out of B`, `Replace X with Y`). Name the affected behaviour or boundary rather than only an area or internal type. Follow repository conventions for ticket prefixes and stack numbering.

### Opening

Lead with the net change (starting with a present-active verb) or, for a fault, the concrete prior-state problem, and state why it exists.

- When a PR has 2 to 5 distinct headline changes across surfaces or boundaries, follow the 1 to 2 sentence lede immediately with a compact bullet list (2 to 5 one-sentence bullets) before any section headings.
- Do not open with a `Summary` or `What changed` heading.

### Functional surfaces

Inventory changed user- or consumer-facing surfaces and the observable behaviour, contracts, states, or transitions on each. Organise around the product model or user journey, not the order in which code executes. Use a compact table or parallel bold-stem bullets (`- **Inbox:** ...`) when several surfaces change.

### Architecture and internal contracts

Include internal architecture only when a reviewer needs it to judge correctness, ownership, persistence, permissions, operations, or compatibility. Ask whether a plausible alternative implementation could deliver the same feature with a different boundary; if not, leave the mechanics in the diff.

| Reviewer question | What belongs in the body (when changed) | What stays in the diff |
|---|---|---|
| Who owns the invariant? | Responsibility moves, policy ownership, and cross-component boundaries | Helper splits, private types, local state hooks, and component props |
| Where and when does execution happen? | New or changed jobs, queues, workers, RPCs, transaction boundaries, and post-commit dispatch | Polling intervals, debounce timers, cache-key wiring, and routine event handlers |
| Where does state live? | Authoritative records, projections, lookup keys, uniqueness, and lifecycle | Routine CRUD queries, serializer helpers, and local UI state |
| What must versions agree on? | Producer/consumer payloads, dual-read/write compatibility, migrations, and rollout order | Unchanged wire formats and routine test fixtures |

When storage changes matter, use an ASCII schema block with `+` / `~` / `-` markers and adjacent `# comments` explaining authority, lookup purpose, and lifecycle instead of repeating DDL in prose.

### Visualise contract and schema deltas

Whenever a PR changes an RPC service or message, public API or webhook payload, database table/column/index, or persisted job/event contract, show the exact added, modified, or removed declarations in a compact `diff` or annotated block. Reviewers catch naming, type, nullability, and symmetry issues immediately when the exact names are visible in the PR body; prose summaries and conceptual tables hide those names.

- Include only the changed methods, fields, or columns plus 1 to 2 unchanged lines for context.
- Use `+` / `-` markers (in a ```` ```diff ```` or ```` ```text ```` block) and short adjacent `#` or `//` comments for non-obvious semantics, units, lookup keys, or constraints.

````markdown
```diff
 service ActionItemsService {
+  rpc ListActionItems(ListActionItemsRequest) returns (ListActionItemsResponse);
+  rpc UpdateActionItem(UpdateActionItemRequest) returns (UpdateActionItemResponse);
 }

 message ActionItem {
   string id = 1;
+  ActionItemState state = 2;              // OPEN, IN_PROGRESS, COMPLETED, CANCELLED
+  google.protobuf.Timestamp due_time = 3; // deadline only; does not schedule a reminder
 }
```
````

````markdown
```diff
 calendar_events
   id
-  organiser_copy_seen boolean NOT NULL DEFAULT false
+  organiser_last_seen_time timestamptz NULL  # set when organiser's calendar copy is observed
```
````

### Choose the representation

Use one representation per reviewer question; do not repeat the same model in a diagram, table, and prose walkthrough.

| Information | Representation |
|---|---|
| Added, modified, or removed RPCs, messages, API fields, or job/event payloads | Compact `diff` snippet with exact method/field names, types, and adjacent comments |
| Added, modified, or removed database tables, columns, or constraints | ASCII schema `diff` block (`+`, `-`, `~`) with adjacent `#` comments |
| Parallel UI surfaces, affordances, or component ownership without branching topology | Compact table or 2 to 6 bold-stem bullets |
| Ordered runtime sequence | Numbered list (1 to 5 steps) |
| Non-linear topology, branching, convergence, cycle, or state transition | Plain-text diagram |
| Cause, tradeoff, compatibility, or implication | Short prose (1 to 3 sentences) |

Before keeping a plain-text diagram, confirm that its geometry communicates branching, convergence, or containment that a numbered list or table would hide, that it has one dominant reading direction with no crossings, and that unlabelled arrows share one meaning. Follow a diagram with at most one short paragraph stating its implication; put additional parallel facts in bullets.

### Screenshots and visual changes

When a PR changes UI appearance or layout, include focused screenshots uploaded with `gh pr create --attach` or `gh pr edit --attach`. Never commit screenshots to the repository solely to embed them in a PR.

Frame screenshots so they scan cleanly in GitHub's PR column without stretching to full width:

1. **Crop to the area of focus with breathing room:** Capture the target component or region with 24 to 48px of surrounding context rather than a mostly empty full-viewport screenshot.
2. **Composite narrow or portrait crops onto a ~16:9 canvas:** GitHub expands standalone tall or narrow images (such as sidebars, dialogs, menus, or mobile views with aspect ratio `< 1.4:1`) to fill the column width, overwhelming the PR body. Center narrow crops on a ~16:9 landscape canvas (such as `1312x738`) padded with a neutral background that contrasts cleanly with the component (for example, `#f5f4f0` behind a white `#ffffff` light-mode card, or `#141413` in dark mode).
3. **Attach inline via local file paths:** Reference the local path in the body file (`![Descriptive alt text](/tmp/opencode/shot.png)`) and pass `--attach /tmp/opencode/shot.png` when creating or editing the PR so `gh` replaces the local path with the uploaded asset URL.

Read [references/mechanics.md](references/mechanics.md) for the ready-to-run browser and `ffmpeg` 16:9 compositing snippets, `--attach` commands, external ticket links, stack/dependency rules, and protected human sections. Read [examples.md](examples.md) for concrete examples of each tier.

## Workflow: Draft, maintain, and verify

### 1. Gather evidence

Inspect the base-to-head diff and surrounding code for changed boundaries, and use the task conversation, ticket, or design brief for motivation. Describe the final net change on the branch, not the history of intermediate commits.

### 2. Publish in two stages when needed

When repository policy opens a draft PR early, post a concise initial body first (stating what changed, why, and any deploy blocker, or beginning with `Work in progress` if implementation remains). Skip the cold-reader critic for initial and WIP bodies, and for small or cleanup-list PRs.

### 3. Maintain an existing body

When updating a PR whose scope and core model have not changed:

1. Re-read the live title, body, and head.
2. Patch only claims made stale by the new commits.
3. Preserve human-authored sections (`Human overview`, `Human notes`), uploaded media, and HTML-comment-delimited tool blocks byte-for-byte.
4. Post via `--body-file` and verify the live result.

### 4. Build and verify a substantial final body

For a substantial PR (new feature surfaces, changed public contracts, or new architectural/storage boundaries), write a brief reader model before drafting:

```text
Primary impact: functional | non-functional | mixed (<primary>)
Intended takeaway: <one sentence>
Reader should retain:
- <3 to 5 core facts>
Consequential constraints:
- <rollout, migration, or compatibility constraints, if any>
```

Before posting, verify the draft against this checklist:

1. **First-draft rules pass:** Starts with a present-active PR verb; contains no `Validation:`/`Testing:` footer, `How to test` recap of routine CI, or file/identifier inventory; paragraphs are <= 3 sentences; at most 2 consecutive prose paragraphs appear without a structural break; no sentence lists 3+ inline paths or identifiers.
2. **Contract and schema deltas are visible:** Any changed RPC method/message, API payload, persisted job/event schema, or database table/column/constraint is shown as a compact `diff` snippet with exact field/column names and types, not merely described in prose or a conceptual table.
3. **Scan test passes:** Reading only the title, opening, headings, diff/schema blocks, diagrams, tables, and bold bullet stems communicates the net change, motivation, and core model.
4. **Separation holds:** Functional behaviour comes first; consequential internal architecture is in a separate section; routine implementation mechanics (timers, local state, helper names) are omitted.
5. **Zero duplication:** Each capability, contract, or guarantee is explained in one place and one representation.

When subagent delegation is available on a substantial PR, pass only the proposed title and agent-authored body (excluding human-authored sections) to an isolated subagent with no repo access or tools:

```text
Cold-read this PR title and body using only the text below. Do not use tools or inspect any files.

Return:
1. Scan-only takeaway from reading only the title, opening, headings, diff/schema blocks, diagrams, tables, and bullet stems.
2. Any violation of these rules:
   - First sentence must start with a present-active PR verb (Adds, Updates, Replaces, Moves, Removes, Prevents), never "<Noun> now <verb>s" or "This PR".
   - Changed RPCs, API/message fields, database tables/columns, or persisted schemas must appear as a compact diff/schema block showing exact names and types, not only prose or a conceptual summary table.
   - No Validation/Testing/Verification summaries, CI/test-pass recaps, or file/identifier inventories.
   - Max 3 sentences per paragraph; max 2 consecutive prose paragraphs without a visual break; no 3+ inline paths/identifiers in a prose sentence.
   - Functional behaviour must precede internal architecture without interleaving or narrating routine mechanics (timers, cache wiring, local hooks).
   - No capability or guarantee repeated across multiple sections or representations.
   - Diagrams must show real branching, convergence, or containment with unambiguous arrows.
3. PASS or FAIL with exact locations of any failures. Do not rewrite the text.
```

Revise any failed check, re-read the live PR title and body to avoid clobbering concurrent edits, post with `gh pr create --body-file` or `gh pr edit --body-file`, and verify the rendered result.
