---
name: pr-overview
description: >
  Use when the user asks for an overview of a pull request or branch (e.g.
  "what changed in PR X", "give me an overview of branch Y", "walk me
  through this PR"), before diving into the diff.
---

# PR Walkthrough

Narrate the change as a guided reading. The reader can open the diff themselves — your job is to give them the framing, the concepts, and the reasoning that GitHub's UI does not.

## Iron Law

**REACH FOR A DIAGRAM WHEN IT REPLACES THREE SENTENCES WITH ONE LOOK.**

Prose and diagrams do different work, and a walkthrough uses both. Prose carries reasoning, causality, and the reader's growing mental model. Diagrams show shape — topology, state, matrices, branching flow, before/after deltas.

## Voice

Write to a peer reviewer. State facts; don't sell them.

The register is a senior engineer explaining the change to a teammate who is about to review it — direct, specific, unhurried but not padded. That includes both stating facts *and* making small connections the teammate might otherwise miss: not to dramatize, but because pointing at connections is what explanation is. Facts sit plainly; consequences are stated, not amplified. No editorializing about the PR itself, no dramatic framing, no rhetorical amplification.

Reflective asides are welcome — single sentences where the narrator steps back to point out a connection, a subtlety, or a consequence. Examples: *"Silence here is the feature." "That distinction didn't exist before this PR." "This is the subtlety easy to miss when reading only the session."* They aren't analysis and they aren't diagrams; they're the connective tissue a good teacher uses.

## Phase 1 — Gather external context

Assemble the context the PR was written in before reading any source.

1. `gh pr view <n>` — title, body, author, base/head, linked issues.
2. `gh pr view <n> --comments` — discussion, concerns, decisions.
3. Referenced PRs — any `#NNNN` in the body or comments, plus stack parents and children. Fetch each with `gh pr view`.
4. Linear tickets — any `AI-1205`-style identifier in body, commit titles, or branch name. Use `mcp__linear-server__get_issue`.
5. Design docs or specs linked from the body. Read them.
6. `git log --oneline <base>..<head>` — commit storyline.

Before Phase 2, you must be able to state the PR's goal in one sentence.

## Phase 2 — Survey the change

1. `git fetch origin <branch>` and `git checkout <branch>`.
2. `git diff --stat <base>..HEAD` — size, spread, concentration.
3. Identify the 5–10 central files by size, by position in the change, and by whether they define new types or entry points. Deprioritise tests and generated files unless the tests themselves are the point.
4. Read them.

## Phase 3 — Shape and order the walkthrough

A walkthrough moves through three motions — orienting the reader, descending into the layers, and resurfacing with synthesis. These are shapes the reader *feels*, not sections you label. A walkthrough might open with a narrative context paragraph that both orients and sets up the descent; its synthesis might be a single closing diagram with no announcement. Don't add headings called "Orient" or "Resurface" — let the content carry the shape.

Section headings should come from the content, not from structural templates. "The identity layer" is better than "2. Preference module." "Recovery is where the complexity lives" is a heading; "The session" without context is a label.

Closing on a file map alone is fine when the PR is a pure structural refactor and file layout *is* the synthesis. Otherwise the close should be domain-level — a combined diagram, a prose paragraph, or an observation that assembles the pieces.

A walkthrough has one narrator telling one story. Pick the order before you write.

A PR is judged on two axes, and a walkthrough can visit both:

- **Code architecture** — where the change lives, what moved, what replaced what. Serves "where should I focus my review?"
- **Domain** — what the change means, how the system behaves, the flows and states it produces. Serves "does this actually work correctly?"

Both are legitimate. Let the PR dictate — a small refactor might be all code architecture; a behavioural fix might be all domain; a large feature touches both. When both apply, weave them into a single narrative rather than splitting into parallel sections.

Default order — **entry-point-first**: the user-visible behaviour or external interface → what had to change to support it → the supporting infrastructure.

Alternatives that sometimes fit better:

- **New-abstraction-first** for refactors that introduce a type or module replacing several existing things.
- **Problem-first** for bug fixes where the bug's shape is the clearest anchor.
- **Topology-first** when service or module boundaries move.

One order per walkthrough.

## Phase 4 — Narrate, weaving in diagrams where they amplify understanding

Write prose. Each paragraph advances the reader's mental model of the change.

Reach for a diagram when it replaces three sentences with one look. Diagrams shine at:

- **Shape** — topology, call graphs, component ownership, inheritance
- **State lifecycles** — named states with transitions between them
- **Matrices** — X × Y cells where the content of each cell is the point
- **Branching flow** — decision points where the branches *are* the insight
- **Before/after** — deltas where the shape itself is what changed

Prose shines at the space between — causality, rationale, the "why this matters," the connective tissue that carries the reader from one concept to the next. A walkthrough without paragraphs between diagrams is a gallery; a walkthrough where every diagram would collapse to a single prose sentence is under-visualised.

Place each diagram at the moment in the narration where the reader needs it, not in a dedicated diagrams section.

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

**Keep each diagram on one axis.** A file tree carries code-architecture information; a state machine carries domain information; a call graph carries code architecture; a behavioural flow carries domain. Mixing them — a file tree with behavioural labels, a state machine annotated with line numbers, a component map with sentence-length purpose columns — muddles both. If a concept needs both axes, use two diagrams or put the cross-axis detail in the prose between them.

## Phase 5 — Worth flagging → Honesty

Close with two short sections.

- **Worth flagging** — concerns, open questions, merge blockers, invariants preserved, test-plan items still unchecked. Prose or short bullets.
- **Honesty** — what you read, what you didn't, what's inferred from the PR body rather than verified in code.

## Red flags — STOP

If you find yourself thinking any of these, step back:

| Thought | Reality |
|---|---|
| "Let me call-tree the hot path with line numbers" | Line numbers are navigation. A walkthrough is about shape. |
| "This diagram makes the section feel complete" | If the diagram would collapse to a single prose sentence, the sentence is the better form. |
| "This file tree would be clearer with behavioural labels" / "This state machine should show line numbers" | Keep each diagram on one axis. Cross-axis detail goes in the prose around the diagram, not inside it. |
| "The title undersells it" / "This PR actually..." | Editorial asides about the PR itself are noise. State what it does. |
| "The insight that unlocks..." / "What you wouldn't think of until..." | Teaser framing is drama. Present the insight directly. |
| "The whole thing is worthless if..." | Hyperbole. State the risk plainly: "If X is wrong, the recording is incomplete." |
| "Let me give the opening some impact" | The reader has the title. Orient, don't hook. |
| "The reader will infer the synthesis from the sections" | Ending on one layer's details leaves the reader holding parts, not a whole. Close with a diagram, a paragraph, or an observation that assembles them. |

**Violating the letter of these rules is violating the spirit of them.**

## Cost

A walkthrough that re-renders the diff wastes the reader's time. Prose, reasoning, and selective structure are exactly what GitHub's UI does not give them — and exactly what the reader asked for when they invoked this skill.

## Common mistakes

- **Using mermaid or other non-ASCII diagram syntax.** Output renders in a terminal.
- **Starting with the diff file-by-file.** Structure and external context come first.
- **Skipping PR comments and linked tickets.** Reviewer concerns and author replies encode reasoning the code cannot carry.
- **Overclaiming coverage.** If the PR is 50 files and you read 8, say so.

## Input forms

Accept:

- PR number (`1122`)
- Branch name (`ivan/push-notifications`)
- Both

Resolve PR → branch with `gh pr view <n> --json headRefName`. Resolve branch → PR with `gh pr list --head <branch> --json number,url,title`. If no PR exists for the given branch, proceed using just the branch. Call this out in the honesty section.
