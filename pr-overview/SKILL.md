---
name: pr-overview
description: >
  Use when the user asks for an overview of a pull request or branch (e.g.
  "what changed in PR X", "give me an overview of branch Y", "walk me
  through this PR"), before diving into the diff.
---

# PR Walkthrough

Write a report for a reviewer about to read the diff. Give them the framing, concepts, and reasoning that GitHub's UI does not.

## Iron Law

**THIS IS A REPORT FOR A REVIEWER, NOT A NARRATIVE FOR A READER.**

**REACH FOR A DIAGRAM WHEN IT REPLACES THREE SENTENCES WITH ONE LOOK.**

## Who you are writing for

You are writing a senior engineer's pre-review brief to a peer. The reader has already opened `gh pr view` and the diff in another tab. They are irritated by recap, allergic to drama, and skim. Anything that doesn't help them review faster is failure.

A disciplined senior engineer briefing a peer states what changed, points at the parts that take more than a glance to understand, and stops. They don't introduce, set up, frame, hook, or signpost. They don't name events. They don't editorialise. That's the posture for every paragraph.

## Voice

Direct, specific, unhurried, unornamented. State facts. Don't sell them. The walkthrough is a flat technical reference between diagrams, not a piece of writing with craft.

| Good | Bad |
|---|---|
| "The new dispatcher acquires a Postgres advisory lock before each tick. Other instances skip the tick when the lock is held." | "The headline reshape is the dispatcher itself: where the scheduling lives moved from in-process timers to a Postgres-backed leader. Everything else hangs off that." |
| "All three checks must pass; any failure aborts the request." | "Three independently-attestable signals, all bound to the same secret. Lose any one and the request fails closed." |
| "Provider B requires `offline_access` for refresh tokens; Provider A rejects it on refresh and uses `access_type=offline` on authorize instead." | "Provider B, mostly mirrors Provider A. Read it as A with three meaningful divergences." |
| "Adds a 5-minute TTL on pending rows. The cleanup job deletes expired rows on each tick." | "The cleanup job — the smallest, cleanest piece of the PR — sweeps abandoned pending rows on a 5-minute cadence." |

Reflective asides — single sentences that point at a connection or consequence — slip in unannounced. Never flag them. Phrases like *"The closing reflective note:"*, *"Three subtleties worth pointing at:"*, *"Worth noting:"*, *"What's interesting is…"*, *"It pays to know that…"* are forbidden. The aside lands as one bare sentence or is cut.

## Forbidden ornaments

Cut on sight:

- **Editorial framing of the PR itself** — *"the title says X but…"*, *"beyond the title"*, *"the headline reshape is…"*, *"the centerpiece is…"*, *"this PR actually…"*, *"those are the smallest two of…"*, *"the title undersells it"*. The reader has the title.
- **Event-naming** — *"the X-to-Y shift"*, *"the pivot to Z"*, *"the move from X to Y"*. Headings name concepts, not events. Commits record the author's path; the walkthrough is organised by net change.
- **Comma-tagline headings** — *"X, mostly mirrors Y"*, *"X — the smallest, cleanest piece"*, *"The N bug, surfaced by adding M"*.
- **Line counts anywhere in the output** — *"a 274-line file"*, *"67 lines of careful posture"*, *"154 lines, four tests"*, *"the 400-line design doc"*, *"(new) 239-line guide"* as a tree annotation, *"the ~2350-line plan document"* in the Honesty section. The diff shows size. Line counts are ornament whether they appear in prose, diagrams, table cells, or the Honesty section.
- **Editorial adjectives on the code** — *careful, clean, elegant, clever, smallest, cleanest, deliberate, surgical, tight*. Describe what the code does, not how it feels to read.
- **Anticipation phrases** — *"three subtleties worth pointing at"*, *"the part that touches the most surface"*, *"it pays to know"*, *"read it as X with N divergences"*. State the content; don't introduce it.
- **Dramatic flourishes** — *"lose any one and it fails closed"*, *"the whole thing is worthless if…"*, *"fails closed"* as a one-liner. State the consequence flatly.
- **Diff-stat in the body** — *"6 commits, 42 files, +3742 / -719"*, commit lists with hashes. The reviewer has `gh pr view`.
- **List preambles that only announce a list** — *"Three subtleties:"*, *"Two routes now:"*, *"The flow is two-legged:"*. If the bullets read the same way without the preamble, cut it.
- **LLM padding** — *just, simply, really, actually, basically, essentially, fundamentally, particularly, clearly, obviously, notably*.

## Phase 1 — Gather external context

Assemble the context the PR was written in before reading any source.

1. `gh pr view <n>` — title, body, author, base/head, linked issues.
2. `gh pr view <n> --comments` — discussion, concerns, decisions.
3. Referenced PRs — any `#NNNN` in the body or comments, plus stack parents and children. Fetch each with `gh pr view`.
4. Linear tickets — any `AI-1205`-style identifier in body, commit titles, or branch name. Use `mcp__linear-server__get_issue`.
5. Design docs or specs linked from the body. Read them.
6. `git log --oneline <base>..<head>` — list of commits, for navigation only.

**Commit order is not walkthrough order.** Commits record the author's path; the walkthrough is organised around net change. Don't structure sections around commits, don't name commits as events, and don't narrate cause-and-effect between commits. The diff is what the reviewer reviews, not the history that produced it.

Before Phase 2, you must be able to state the PR's goal in one sentence.

## Phase 2 — Survey the change

1. `git fetch origin <branch>` and check it out in a worktree (never the repo root).
2. `git diff --stat <base>..HEAD` — size, spread, concentration. For your own use; doesn't go in the output.
3. Identify the 5–10 central files by size, by position in the change, and by whether they define new types or entry points. Deprioritise tests and generated files unless the tests themselves are the point.
4. Read them.

## Phase 3 — Shape and order the walkthrough

The walkthrough orients the reader, descends through the layers, and resurfaces with synthesis. These are shapes the reader feels, not sections to label. Don't add headings called "Orient" or "Resurface".

### Opening

The opening states what the PR does in one or two sentences and goes straight to the first concept.

Forbidden in the opening:

- Commit list (any form — hashes, oneline, parenthetical labels).
- File count, +/- line totals, any other diff-stat number.
- Phrases that frame the PR against its title (see *Forbidden ornaments*).

The reader has `gh pr view`. Don't re-render it.

### Headings

Headings name a concept or layer — what the next section is about. Examples of the right shape: *the dispatcher loop*, *the lease semantics*, *the retry transport*, *the pending lifecycle*, *the auth boundary*. Forbidden:

- Event-naming headings (see *Forbidden ornaments*).
- Editorial headings — *"the smallest, cleanest piece"*, *"the centerpiece"*.
- Comma-tagline construction.

A heading announces a concept the next section covers. It does not summarise that section.

Use sentence case throughout — capitalise the first word, leave the rest lowercase unless it's a proper noun. Mixed case across headings is friction.

### Order

Default — **entry-point-first**: user-visible behaviour or external interface → what had to change to support it → supporting infrastructure.

Alternatives that sometimes fit better:

- **New-abstraction-first** for refactors that introduce a type or module replacing several existing things.
- **Problem-first** for bug fixes where the bug's shape is the clearest anchor.
- **Topology-first** when service or module boundaries move.

One order per walkthrough.

### Closing

Closing on a file map alone is fine when the PR is a pure structural refactor and file layout *is* the synthesis. Otherwise the close is domain-level — a combined diagram, a flat paragraph, or an observation that assembles the pieces. No "closing reflective note" header. No announced wrap-up.

## Phase 4 — Write, weaving in diagrams where they amplify understanding

Each paragraph advances the reader's mental model. No paragraph exists to set up, recap, or reflect on another paragraph.

Reach for a diagram when it replaces three sentences with one look. Diagrams shine at:

- **Shape** — topology, call graphs, component ownership, inheritance
- **State lifecycles** — named states with transitions between them
- **Matrices** — X × Y cells where the content of each cell is the point
- **Branching flow** — decision points where the branches *are* the insight
- **Before/after** — deltas where the shape itself is what changed

Place each diagram at the moment the reader needs it.

### Visual selection

| Insight shape | Reach for | Prefer prose if |
|---|---|---|
| Central files grouped by role | Compact structural tree by directory | You'd end up listing every changed file |
| Matrix (X × Y cells, each with distinct content) | Table with box-draw characters | It's really a flat list |
| Entity lifecycle with named transitions | State machine | Only two states |
| Topology — components added, moved, rewired | Component map, marking the delta | Nothing moved |
| Control flow that branches at a decision point | Indented call tree | One linear path |
| A delta that hinges on before-vs-after | Side-by-side or before/after block | No meaningful delta |

Use ASCII throughout (`┌ ─ ┐ │ └ ┘ ├ ┤ ┬ ┴ ┼`). The output renders in a terminal.

**Keep each diagram on one axis.** A file tree carries code-architecture information; a state machine carries domain information. Mixing them muddles both. If a concept needs both axes, use two diagrams or put the cross-axis detail in the prose between them.

## Phase 5 — Worth flagging → Honesty

Close with two short sections.

- **Worth flagging** — concerns, open questions, merge blockers, invariants preserved, test-plan items still unchecked. Prose or short bullets.
- **Honesty** — what you read, what you didn't, what's inferred from the PR body rather than verified in code.

## Red flags — STOP

| Thought | Reality |
|---|---|
| "Let me list the commits at the top so the reader has the storyline" | The reviewer has `git log`. The opening rules forbid this. |
| "+X / -Y in N files gives them the shape" | The reviewer has `gh pr view`. |
| "The title undersells it / This PR actually…" | Editorial framing of the PR itself is forbidden. State what the change is. |
| "Let me name this pivot — the shift to X" | Headings name concepts, not events. |
| "67 lines of careful posture" / "a 274-line file" | Line counts and editorial adjectives are forbidden. |
| "Three subtleties worth pointing at" | Anticipation phrases are forbidden. State the content. |
| "The closing reflective note:" | Asides land as unannounced single sentences or are cut. |
| "Lose any one and it fails closed" | State the consequence flatly. |
| "Let me give the opening some impact" | The reader has the title. Orient, don't hook. |
| "X, mostly mirrors Y" / "Z — the smallest, cleanest piece" | Comma-tagline headings are forbidden. |
| "Read it as X with N meaningful divergences" | Anticipation. State the divergences directly. |
| "The reader will infer the synthesis from the sections" | Close with a diagram, paragraph, or observation that assembles the pieces. |
| "The diagram makes the section feel complete" | If the diagram would collapse to a single prose sentence, the sentence is the better form. |
| "Let me call-tree the hot path with line numbers" | Line numbers are navigation. A walkthrough is about shape. |

**Violating the letter of these rules is violating the spirit of them.**

## Cost

A walkthrough that re-renders the diff wastes the reader's time. Prose, reasoning, and selective structure are exactly what GitHub's UI does not give them — and exactly what the reader asked for when they invoked this skill.

## Common mistakes

- **Using mermaid or other non-ASCII diagram syntax.** Output renders in a terminal.
- **Starting with the diff file-by-file.** Structure and external context come first.
- **Skipping PR comments and linked tickets.** Reviewer concerns and author replies encode reasoning the code cannot carry.
- **Overclaiming coverage.** If the PR is 50 files and you read 8, say so.
- **Treating commits as events.** Commits are scaffolding for the author. The walkthrough is organised by net change.

## Input forms

Accept:

- PR number (`1122`)
- Branch name (`ivan/push-notifications`)
- Both

Resolve PR → branch with `gh pr view <n> --json headRefName`. Resolve branch → PR with `gh pr list --head <branch> --json number,url,title`. If no PR exists for the given branch, proceed using just the branch. Call this out in the honesty section.
