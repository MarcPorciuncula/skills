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

- **Open with a present-active PR verb:** Start the first agent-authored prose sentence after any review bundle with what the PR changes (`Adds`, `Updates`, `Replaces`, `Moves`, `Removes`, `Prevents`). Never open with `<Subject> now <verb>s...` (`Human checklist items now appear as...`) or `This PR...`.
- **Foreground contract and schema deltas as diff snippets:** Show changed contracts in compact diffs with exact declarations. Label each contract with its kind and container name, then indent its changes below the label. Follow **Visualise contract and schema deltas** for layout and examples.
- **Match body shape to scope:** Use the simplest tier in **Size and shape** below. Do not turn a small fix or visual cleanup list into a multi-section document.
- **Break up dense prose:** Keep paragraphs to 3 sentences or fewer. Never write more than 2 consecutive prose paragraphs without a visual break (heading, bullet list, table, diff/schema block, or diagram). Never list 3 or more inline file paths, RPCs, or identifiers inside a prose sentence. Do not hard-wrap prose or bullets across source lines.
- **Bound bullet lists:** Keep bullet lists to 2 to 6 items, one sentence per item, with no nested sub-bullets. Use bold lead-in stems (`- **Surface:** ...`) when items describe distinct surfaces, components, or guarantees.
- **Omit banned sections and footers:** Never add `Summary`, `What changed`, `Design`, `Validation:`, `Testing:`, `Verification:`, `Test plan`, unit/CI/linter pass recaps, diff statistics, AI attribution, or file/identifier inventories in the PR body. When the repository uses a separate `Review focus` PR comment, put the reading-order file table there.

## Size and shape

Choose the body tier before drafting. Diff line count does not decide the tier. A required review bundle precedes the body at every tier.

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

### Multi-PR review navigation

Before creating or updating a PR body, determine whether it belongs to a review
bundle. Include the bundle when any of these applies:

- The change spans repositories, such as a server contract and its client,
  application code and deployment config, or a schema and its consumers.
- The PR is part of a stack or a larger change split into reviewable slices.
- Merge or deployment requires coordination: preparation before cutover,
  migration before consumption, or cleanup after rollout verification.
- Understanding or judging the change requires reading other PRs, even when
  the branches are independent and could technically merge in either order.
- The author identifies several PRs as one unit of review.

The deciding question is whether a reviewer landing on this PR needs the other
PRs to understand the complete change or assess its delivery. A shared ticket,
topic, or author alone does not bundle otherwise independent changes. Omit the
block for a standalone PR.

For a bundle, start **every involved PR description** with `### Review bundle`.
Follow it with `Ticket:` and one linked Linear ticket, or `Tickets:` and the
related ticket links when several tickets identify the review unit. Follow the
ticket line directly with a numbered list of every PR, including this PR.
Separate the heading, ticket line, and list with blank lines.
Use rollout order when required; otherwise use logical review order. Do not add
introductory prose between the ticket line and the list. Mark the current entry
`**(this PR)**`.

Keep the ticket set, PR membership, order, and meaning consistent across the unit.
Adapt reference syntax to the repository containing each body; move the current-PR
marker to its entry. Use `#N` for a PR in that repository and `owner/repo#N` for a
PR elsewhere. GitHub expands list references to show the PR title and state;
do not append another copy or paraphrase of the title. Add a short repository
label only when the rendered references need it for orientation.

```markdown
### Review bundle

Ticket: [AI-1234: Change title](https://linear.app/<workspace>/issue/AI-1234)

1. owner/backend#101
2. #202 **(this PR)**

---

Switches the client to ...
```

This example is posted in `owner/web`. Do not substitute `previous`/`next`, a
parent link, or a stack-tool map for the complete list. Include merged
prerequisites that belong to the unit; exclude unrelated work and optional
future follow-ups. List related tickets when they help identify the same review
unit; sharing a topic alone does not establish membership.

The bundle does not replace Linear keyword references. Repeat relevant tickets
in the references list with the appropriate linking or closing keyword when
needed for association or automation; do not remove it as redundant.

Keep each PR entry to its reference and necessary orientation. Put rollout
mechanics and explanations below the block; add only a terse essential gate such as `after #101 deploys`
when order alone would mislead. When merge and deploy order differ, label the
constraint explicitly. If steps can roll out in either order, say so rather
than inventing a dependency.

Before drafting, establish the review unit from the task, Linear links and
sub-issues, live PR bodies, and stack/dependency metadata. Verify membership and
order rather than sorting by PR number or assuming one ticket means one PR.
Read [references/mechanics.md](references/mechanics.md#github-pr-reference-rendering)
for rendering rules, missing PR links, and keeping copies consistent.

### Titles

Use a specific imperative verb and object (`Add X`, `Fix Y when Z`, `Move A out of B`, `Replace X with Y`). Name the affected behaviour or boundary rather than only an area or internal type. Follow repository conventions for ticket prefixes and stack numbering.

### Opening

After any review bundle, lead with the net change (starting with a present-active verb) or, for a fault, the concrete prior-state problem, and state why it exists.

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

For storage changes, use the schema diff format in **Visualise contract and schema deltas**. Use adjacent comments to explain authority, lookup purpose, and lifecycle where needed.

### Visualise contract and schema deltas

Whenever a PR changes an RPC service, message, interface, public API or webhook payload, database table, column, index, or constraint, or persisted job or event payload, show the exact changed declarations in a compact `diff` or annotated `text` block.

- Give each contract one label with the full contract kind followed by the exact container name, such as `table trigger_tags`, `job payload triggers.dispatch`, or `event payload meeting.notes_ready`.
- Indent declarations under their label. Use `+`, `-`, or `~` to mark changes, with indentation after the marker. Include exact names and types, plus up to two unchanged lines where they clarify the change.
- Contracts can share a block. Put their labels at the same indentation level and leave a blank line between contracts.
- Use short adjacent `#` or `//` comments for non-obvious semantics, units, lookup keys, or constraints.

````markdown
```diff
 RPC service ActionItemsService
+  rpc ListActionItems(ListActionItemsRequest) returns (ListActionItemsResponse);

 protobuf message ActionItem
   string id = 1;
+  google.protobuf.Timestamp due_time = 3; // deadline only

 table calendar_events
-  organiser_copy_seen boolean NOT NULL DEFAULT false
+  organiser_last_seen_time timestamptz NULL
```
````

### Choose the representation

Use one representation per reviewer question; do not repeat the same model in a diagram, table, and prose walkthrough.

| Information | Representation |
|---|---|
| Added, modified, or removed RPCs, messages, API fields, or job/event payloads | Labelled `diff` snippet with exact method/field names and types |
| Added, modified, or removed database tables, columns, or constraints | Labelled schema `diff` with exact column names and types |
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

For a multi-PR change, the review bundle must be the first content in every involved PR description from creation, before opening prose, WIP notices, or blocker warnings. Include it in initial, maintained, and final bodies; a later discussion comment does not satisfy this requirement.

When repository policy opens a draft PR early, post a concise initial body first (stating what changed, why, and any deploy blocker, or beginning the prose after any review bundle with `Work in progress` if implementation remains). Skip the cold-reader critic for initial and WIP bodies, and for small or cleanup-list PRs.

### 3. Maintain an existing body

When updating a PR whose scope and core model have not changed:

1. Re-read the live title, body, and head.
2. Patch only claims made stale by the new commits.
3. Preserve human-authored sections (`Human overview`, `Human notes`), uploaded media, and HTML-comment-delimited tool blocks byte-for-byte.
4. Recheck any review bundle against the live ticket and PR set, updating membership, order, and copies within the authorised scope.
5. Post via `--body-file` and verify the live result.

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

1. **First-draft rules pass:** Opening prose after any review bundle starts with a present-active PR verb; contains no `Validation:`/`Testing:` footer, `How to test` recap of routine CI, or file/identifier inventory; paragraphs are <= 3 sentences; at most 2 consecutive prose paragraphs appear without a structural break; no sentence lists 3+ inline paths or identifiers.
2. **Contract and schema deltas are visible:** Check that each changed contract has a compact diff with exact declarations indented under a label that gives its kind and container name. In shared blocks, check that contract labels align and blank lines separate the contracts.
3. **Scan test passes:** Reading only the title, opening, headings, diff/schema blocks, diagrams, tables, and bold bullet stems communicates the net change, motivation, and core model.
4. **Separation holds:** Functional behaviour comes first; consequential internal architecture is in a separate section; routine implementation mechanics (timers, local state, helper names) are omitted.
5. **Zero duplication:** Each capability, contract, or guarantee is explained in one place and one representation.
6. **Review bundle is complete when required:** The description starts with `### Review bundle`, one linked ticket or related tickets, and every involved PR in rollout or logical review order. Mark this PR, resolve each reference relative to the destination repository, and avoid repeating expanded titles. Keep ticket sets and PR membership consistent across copies. Apply this check to initial and maintenance bodies too; verify membership and order against live sources.

When subagent delegation is available on a substantial PR, pass only the proposed title and agent-authored body (excluding human-authored sections) to an isolated subagent with no repo access or tools:

```text
Cold-read this PR title and body using only the text below. Do not use tools or inspect any files.

Return:
1. Scan-only takeaway from reading only the title, opening, headings, diff/schema blocks, diagrams, tables, and bullet stems.
2. Any violation of these rules:
   - First prose sentence after any review bundle must start with a present-active PR verb (Adds, Updates, Replaces, Moves, Removes, Prevents), never "<Noun> now <verb>s" or "This PR".
   - Each changed contract must appear as a compact diff/schema snippet with exact declarations indented under a label that gives its kind and container name. In shared blocks, contract labels must align and blank lines must separate the contracts.
   - No Validation/Testing/Verification summaries, CI/test-pass recaps, or file/identifier inventories.
   - Max 3 sentences per paragraph; max 2 consecutive prose paragraphs without a visual break; no 3+ inline paths/identifiers in a prose sentence.
   - Functional behaviour must precede internal architecture without interleaving or narrating routine mechanics (timers, cache wiring, local hooks).
   - No capability or guarantee repeated across multiple sections or representations.
   - Diagrams must show real branching, convergence, or containment with unambiguous arrows.
   - For a multi-PR change, the body must start with `### Review bundle`: linked ticket or related tickets, complete ordered PR list using repository-appropriate references, and this PR marked, without duplicated titles or introductory prose between the ticket line and list.
3. PASS or FAIL with exact locations of any failures. Do not rewrite the text.
```

Revise any failed check, re-read the live PR title and body to avoid clobbering concurrent edits, post with `gh pr create --body-file` or `gh pr edit --body-file`, and verify the rendered result.
