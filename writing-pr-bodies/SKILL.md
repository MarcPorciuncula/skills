---
name: writing-pr-bodies
description: >
  Produces a PR description aimed at a human reviewer about to read the diff,
  optimised for cold-read scannability — not a re-narration of the diff itself.
  TRIGGER before any `gh pr create`, `gh pr edit --body`, `gs branch submit`,
  `git spice branch submit`, or other command that opens or updates a pull
  request body — including autonomous PR-creation flows where the user did
  not explicitly ask for a body. Also trigger when the user asks to write,
  rewrite, tighten, or review a PR description / title.
  SKIP for non-body PR operations (e.g. `gh pr ready`, `gh pr merge`, label
  or reviewer changes) and for commit messages.
---

# Writing PR Bodies

A PR body is a handout for a reviewer who is about to read the diff.

## The principle

**Cold-read scannability.** A reviewer landing on this PR with no context grasps what the change is and why within 30 seconds.

A scannable body:

- States the change and motivation immediately — first paragraph or first heading, not buried mid-prose.
- Gives the eye anchor points — paragraph breaks, headings when the PR has more than one beat, bullets when items are parallel.
- Earns every line against the diff. Inventory restatement, marketing prose, and session journey fail this test.

There is no single mandated shape. Pick the shape that orients *this* PR's reader fastest.

## Shapes

### Lede only

One short paragraph in plain prose. Use when one or two sentences carry the whole picture.

> Narrows the scope of pre-commit self-checks (lint, type-check) so they target only changed packages instead of the full repo. The repo-wide pass is slow and CI runs it anyway — the local pass exists for fast iteration, not coverage.

**Right-size to the diff.** For diffs under ~50 lines with a self-explanatory title, target ~two sentences (~50 words). The body's job is whatever the title couldn't carry — a follow-up reference, a one-sentence "why now", a constraint. A four-sentence lede on a 24-line PR is overwriting the title.

### Problem / Change

A `## Problem` heading with 1–3 sentences naming what was wrong, then a `## Change` heading with 1–3 sentences naming what the PR does. Use when the *why* takes more than half a sentence, or when the contrast between problem and change is what makes the diff legible.

> ## Problem
>
> The file-hydration pass re-fetches each `filestore://<id>/v<N>` reference at the *pinned* version on every turn. When a user edits a file between turns — increasingly common now that the markdown panel auto-saves edits back to filestore — the operator agent silently keeps quoting stale content.
>
> ## Change
>
> A new pass in the same plugin walks in-window refs, asks filestore what's current, and appends a short note to the most recent user turn naming the changed paths. The agent decides whether to re-read; the hint is informational, not a task list.

Heading pairs can be `## Problem` / `## Change`, `## Why` / `## What`, or any pair that names this PR's beats. Don't reach for `## Summary` — it opens the door to bullet-inventory bodies.

### Lede + sidecars

A short prose lede, then named sections for material that doesn't fit the lede.

> Switches the scheduled-job runner from in-process timers to a Postgres-backed leader-elected scheduler. A single instance acquires the lease and dispatches due jobs; other instances stay idle and only take over if the lease lapses. Existing job code is unchanged — only the dispatch surface moves.
>
> Lease semantics: renewed every 10s, expire after 30s, so a leader that goes silent (network partition, pause-the-world GC) loses dispatch authority before any other instance picks it up. During that gap, scheduled jobs may briefly miss their slot — the scheduler is "at-most-once per slot", not "exactly-once". Jobs that need at-least-once semantics already wrap themselves in idempotent retries.
>
> ## Background
>
> The previous in-process timer fired on every instance, and we relied on each handler's own dedupe to collapse the duplicate runs into one. That worked at three instances; under the current autoscaling profile (up to thirty), the dedupe write contention itself became the dominant cost.
>
> ## Stack
>
> Stacked on #N. Merges after the lease-table migration in #N is applied to all environments.

Shapes can combine — Problem/Change with a How-to-test sidecar is common.

#### Before/After code blocks for API-reshape refactors

When the *value* of a refactor is the API delta, two short Before/After code blocks at the call-site level are the most legible artifact a reviewer can have.

```go
// Before
sjSvc.RegisterKindForDispatch(KindFoo, FooOptions(2)...)
fooDispatcher := NewFooDispatcher(sjSvc)
```

```go
// After
fooDispatcher := FooJob.Bind(sjSvc)
```

Rules:
- Show one or two representative call sites, not the full type-signature surface.
- Show what changes, not what stays the same. Cut boilerplate, unrelated setup, untouched members.
- `// Before` / `// After` headers are enough; longer commentary belongs in `## Change`.
- Ceiling: ~15 lines per side. Past that, you're dumping the type surface — trim.

This is the one place the "no code archaeology" rule yields. Narrative prose about which files changed is archaeology; a tight Before/After is the contested delta as code.

## Voice

Peer engineer. State facts. Acknowledge limits honestly. Don't sell.

- "Adds the `is_admin` flag on the user-lookup endpoint only. The list and search endpoints leave the field at its zero value for now — populating them is a follow-up." — good. Calibrated; names what isn't done.
- "Exposes per-caller admin status across the user resource." — bad. Sweeping claim that overstates the actual change.
- "Replaces three single-target image-transform tools with one bulk tool." — good. Plain.
- "Introduces a more efficient batch-oriented approach to image transforms." — bad. Corporate.

No jokes, colloquialisms, or stylised asides. They read as performance.

State the mechanism in plain language, not type names. "Adds an HTTP endpoint for updating an existing record by ID, with optional version-conflict checking" beats "Implements `PUT /resource/{id}` via `HandleUpdate` calling `UpdateResource`". Reach for identifier names only when the identifier is itself a non-obvious touchpoint a reviewer needs to find.

The same rule applies to **file paths**. Don't write narrative prose like "`pkg/server/webhooks.go` retyped the parameter; meanwhile `pkg/simplejobs/worker/worker.go` was already passing the constructor's return value as of #1209" — that's code archaeology. Name a file path only when the reviewer needs to *find* something the diff doesn't surface.

### Cut padding

LLM prose accumulates connective tissue. Get the structure right and the prose can still feel padded — cut at the sentence level too.

Words and phrases to cut:

- **Hedges and intensifiers** — *just, simply, really, actually, basically, essentially, fundamentally, quite, rather, somewhat, fairly, particularly, clearly, obviously*.
- **Filler lead-ins** — *It's worth noting that, It should be noted, Notably, Interestingly, As mentioned, In particular, In essence, At a high level, To be clear*.
- **Redundant self-reference** — *This change, This PR, This refactor* as the subject of every sentence. "This adds X" → "Adds X."
- **Explainer-mode openers** — *Let me explain, Let's walk through, To understand this, The way this works is*.
- **Empty contrasts** — *At the same time, On the other hand, That said* when nothing actually contrasts.
- **Count-signalling lead-ins** — *Three failure modes followed: …, There are two reasons: …, The change has the following implications: …*. Useless signalling — the reader will count. Drop the count and the colon: state the items directly. If they're genuinely parallel and individually reviewable, use bullets; otherwise integrate into prose.
- **Throat-clearing parentheticals** — recapping structural detail in parens. State the *consequence*, not the inventory.

| Before | After |
|---|---|
| "This change essentially refactors the auth middleware to handle expired tokens more gracefully." | "Refactors the auth middleware to handle expired tokens." |
| "It's worth noting that the worker now retries on transient failures." | "The worker now retries on transient failures." |
| "Basically, the previous approach was leaking goroutines on shutdown." | "The previous approach leaked goroutines on shutdown." |
| "Let me explain how this works: when a request comes in, we first authenticate, then dispatch." | "On request: authenticate, then dispatch." |
| "Phase 1 shipped autosave to filestore. Three failure modes followed: every typing burst becomes a new version, tab close mid-typing loses edits, and 409s surface as ineffective toasts." | "Phase 1's per-keystroke autosave produced new filestore versions on every typing burst, lost post-debounce edits on tab close, and surfaced 409s as toasts that asked users to reload and discard their work." |
| "The struct itself is now unexported, so `Foo{}` no longer compiles — that literal in `pkg/x/y.go` was the bug #1209 just fixed by hand, and the shape that allowed it (exported struct with an unexported field, plus a nil-tolerant constructor and a `reconciler()` fallback to `UnavailableFoo`) only converted the misuse into a per-call Sentry error rather than a compile failure." | "Closes the loophole behind #1209: the exported struct + nil-tolerant constructor turned this misuse into a runtime Sentry rather than a compile error." |

**Fragments are OK when they save words.** "Follow-up to #1209." reads cleaner than "This is a follow-up to #1209." Trailing reference lines, stack pointers, and one-word qualifiers don't need to be wrapped in complete sentences.

## Bullets vs paragraphs

- **Bullets when items are genuinely parallel** — three or more correctness subtleties, several review-handoff observations, multiple constraints. Each bullet can run a sentence or two.
- **Paragraphs when items aren't parallel** — when one builds on another, when one is much weightier, when reasoning flows.
- **Avoid the lead-in-then-paragraphs pattern.** "Two correctness subtleties worth flagging:" followed by two long prose paragraphs is a tell. If items are parallel enough to share a lead-in, make them bullets. If not, drop the lead-in and weave content into surrounding prose.

The disease was bullet *inventories of the diff* under `## Summary`, not bullets per se. Parallel observations belong in bullets.

## PR titles

The title is the PR's identity across review lists, search, squash-merge commits, notifications, and changelog scans.

### Properties of a good title

- **Specific verb + object** — `Add X`, `Fix Y when Z`, `Move A out of B`, `Drop X`, `Switch X to Y`. Not `Update`, `Improve`, `Refactor stuff`.
- **Names the affected behaviour, not just the area** — "Stop unmounting markdown editor on save" beats "Markdown editor lifecycle".
- **Matches the one-sentence scope** — not broader, not narrower.
- **Stable across the PR's life** — won't need rewriting if the implementation evolves.
- **Conventional prefix when the team uses one** — `fix(scope): …`, `feat(scope): …` per recent merged PRs.
- **Imperative-mood subject line.**

### What doesn't belong in titles

- **Phase numbers** outside an active stack (see below). Phase signal goes in the body.
- **Exhaustive scope qualifiers** — long parenthetical lists.
- **Implementation details** — type names, function names, file paths.
- **Ticket IDs** — see *Ticket IDs* below; conditional.

### Stack numbering — when it *does* belong

In a stack where merge order is enforced:

```
Port off Temporal 2/6: update reconcile interfaces
Port off Temporal 3/6: add River-backed dispatcher
```

A "this PR plus a future spec" pairing isn't a stack. Drop the numbering.

### Ticket IDs in titles

The body's external-references section always carries the ticket ID. The separate question is whether to also surface it as a title prefix.

- **Direct response → include in title.** PR closes or canonically implements the ticket. Format: `AI-1234: …`.
- **Incidental relationship → skip the prefix.** Follow-up fixing a side effect, refactor that touches mentioned code, change initiated independently in the same area.
- **When in doubt → skip.** The body still carries the reference.
- **Team convention overrides** — match recent merged PRs.

Decision test: *would a teammate landing on the ticket and looking for "the PR that did this" expect to find this one via title prefix?* Yes → prefix. No → body only.

### Self-test

Apply each before accepting a title:

1. Specific verb + object (not `Update`, `Improve`, `Refactor`)?
2. Names the affected behaviour, not just the component or area?
3. Matches the one-sentence scope?
4. Carries no info that belongs in the body?
5. Could a reviewer skimming 50 PRs identify this one in five seconds?

If 1, 2, 3, or 5 fail → strengthen. If 4 fails → trim.

**Borderline case** — weak verb (`Update`, `Improve`, `Refactor`) rescued by a specific object (`Refactor X around Y`, `Update X to handle Z`): borderline pass. Don't autonomously rewrite, but surface a tighter alternative when the user is open to feedback.

### Protocol

- **Drafting a fresh PR** — write a title that passes the self-test before opening.
- **Editing an existing PR** — silently apply the self-test. If it passes, leave it. If it fails, surface a recommended rewrite as `current → proposed`. **Do not change the title autonomously.**
- **Exception** — if the user explicitly asked for a title rewrite, proceed.

## Form the picture before drafting

Three disciplines apply before you write.

**State the change in one sentence.** Read the full diff against base and the commit storyline, then state in one sentence what the PR does. If a changed file doesn't fit the sentence, the sentence is wrong or the PR has stray scope. Don't draft until the sentence holds.

**Describe the net diff, not the session journey.** Source of truth: `git diff <base>...HEAD`, not session memory. Reverts, refactors, abandoned approaches — invisible to the reviewer, must be invisible to the body.

**Check the title against the scope sentence.** Run the self-test. Surface a recommended rewrite if it fails.

## What earns a place in the body

After the lede (or problem/change pair), include only material a reviewer needs that they couldn't get from the diff or commit messages.

**An observation earns its place if it carries one of:**
- A non-obvious design decision and why it was made
- A subtlety the reader is likely to miss while reading the code
- A behavioural difference (before vs after) that the diff doesn't make legible
- A constraint, invariant, or assumption the change rests on
- A diff-shape signal that would surprise a reviewer if not flagged (large mechanical churn, restructured tests, regenerated vendored files)

**It does *not* earn its place if it:**
- Lists files that changed
- Restates an identifier rename / move
- Says "Adds tests for X"
- Recapitulates the lede in different words

If you can't write the observation without typing identifier names or file paths, it doesn't belong in the body.

The test: imagine the reviewer reading the PR with the body collapsed. Which paragraphs would they reach for? Those earn their place.

## Sidecars

Add a sidecar only if it carries information the reviewer must know.

- **Deployability** — rollout dependency, migration ordering, merge gate.
- **Stack** — when ordering matters.
- **Differences from #N** — re-baselining an earlier sibling.
- **Areas touched** — for cross-cutting refactors. Two or three lines naming *scope of impact* — subsystems affected, where conflicts with in-flight work are likely, where to watch for regression. Bar: could a teammate predict where this PR collides with theirs without opening the diff? Do *not* substitute file counts or full file lists. Skip for single-package PRs.
  ```
  ## Areas touched

  - `pkg/foo/*` — internal API reshape; no behaviour change.
  - All composition roots (api, worker, periodic-runner) — call-site updates.
  - `pkg/{bar,baz}/dispatch.go` — new descriptors; old wrappers removed.
  ```
- **Also in this PR** — secondary changes that fell out of the same work but aren't part of the headline. One bullet per item, each naming a behavioural or API consequence (not docs or renames — those are diff-recoverable). Use this heading verbatim; avoid "Other changes that fell out…" framings.
- **Design** — link to a spec when one exists. Not a re-summary.
  ```
  ## Design

  [docs/specs/2026-04-17-dev-entrypoint-design.md](docs/specs/2026-04-17-dev-entrypoint-design.md)
  ```
  Multiple distinct artifacts → short list. **Implementation plans are not reviewer artifacts** — they're author-facing tracking; skip them.
- **External references** — Linear tickets, related/follow-up PR numbers, parent or stacked PRs. **Always include.** Plain lines at the bottom or a `## References` block:
  ```
  Linear: AI-1234
  Follow-up: #1235
  ```
- **Background** — only if the commits don't carry it.
- **How to test** — bottom of the body. Numbered or bulleted concrete steps. Each step names a specific user action, command, or button. **No checkboxes** (compliance signal, not reproduction). PR-specific by construction — if every PR's "How to test" looks the same, you've reverted to ritual; cut it.
  ```
  ## How to test

  1. Start the API server locally with `task dev`.
  2. In another terminal, find the API process: `pgrep -f 'alcova server'`.
  3. Send `kill -TERM <pid>` and watch the logs — expect "graceful shutdown: draining" followed by a clean exit within ~8s.
  4. Repeat with `kill -INT <pid>` — expect "fast shutdown: dropping in-flight connections" and immediate exit.
  ```

Skip every sidecar that would be empty or filler.

## Human overview sections

A `## Human overview` (or `## Human notes`, `## From the author`) section is a provenance claim — the heading asserts the human's own words.

**Don't author one yourself.** Writing under that heading is lying about authorship. Put your framing in the lede or a substantive paragraph.

**When editing an existing PR body, treat the section as immutable.** Leave it byte-for-byte. No copy-edits, reflowing, or "while I'm here" tweaks. Modify only the agent-authored content around it. If the human overview now contradicts the rest of the body because the diff has moved on, surface that to the user; don't reconcile it yourself.

These rules apply regardless of the section's name, capitalisation, position, or whether it's currently empty (an empty heading is the user reserving space — leave it).

## When revising an existing PR body

Revision is not editing. The existing body is one input, not a baseline to preserve.

When asked to "revise", "rewrite", "tighten", or "update" a PR body, the reflex is to read the existing content and treat it as ground truth — restructuring paragraphs, swapping headings, polishing sentences. That produces a body that *looks* improved but carries forward the same beats, the same padding, and the same length. Restructuring is not cutting.

Apply the same discipline as a fresh draft:

1. **Read the diff first, not the existing body.** Read `git diff <base>...HEAD` and the commit storyline. Form your one-sentence scope from the diff alone. Only then look at the existing body.
2. **Treat the existing body as one input.** Use it to surface observations the diff doesn't carry — a constraint the original author flagged, a subtlety they identified. That content earns the same way as content you'd write fresh: only if a reviewer couldn't recover it from the diff.
3. **Apply *earns its place* to existing paragraphs as ruthlessly as to new ones.** Inheriting prose because it was already there is the silent failure mode. If a paragraph wouldn't survive a from-scratch draft, cut it.
4. **Don't merge in detail just because it was in the original.** Restructuring three dense paragraphs into Problem/Change/Subtleties keeps the same word count. The body is shorter, or it isn't revised.
5. **Trust your tighter draft.** If your draft is shorter than the original, that's a likely correct outcome, not a sign you're missing something.

The exception: a `## Human overview` section is immutable (see *Human overview sections*). Everything else in an agent-authored body is yours to cut.

## Drafting flow

1. Read the full diff against base and the commit storyline.
2. State the change in one sentence. Don't draft until the sentence holds.
3. Pick a shape — lede only, problem/change, or lede + sidecars — by *this* PR's complexity.
4. Write the body in that shape.
5. Apply the cold-read test: would a reviewer with no context know what the PR is and why within 30 seconds?
6. Add only observations that earn their place. Add sidecars only if load-bearing.
7. Reread. Cut anything that hits a Red flag.

## Red flags — STOP

| Thought | Reality |
|---|---|
| "Let me start with `## Summary`" + bullets of changed files | Diff inventory. Use a prose lede or `## Problem` / `## Change`. |
| "I'll cram problem and change into one dense lede paragraph" | Headings before the lede aren't forbidden. Split with `## Problem` / `## Change`. The disease is inventory bullets, not headings. |
| "Two correctness subtleties worth flagging:" + two long prose paragraphs | Lead-in-then-paragraphs anti-pattern. Parallel items → bullets. Non-parallel → drop the lead-in. |
| "Three failure modes followed: …" / "There are two reasons: …" / "The change has the following implications: …" | Count-signalling. Useless — the reader will count. Drop the count and the colon: state the items directly, either inline or as bullets if genuinely parallel. |
| "The user asked me to revise — I'll keep most of the original and restructure / polish" | Revision is not editing. The existing body is one input, not a baseline. Re-derive from the diff first; apply *earns its place* to existing paragraphs as ruthlessly as to new ones. Restructuring without cutting is not a revision. See *When revising an existing PR body*. |
| "The lede is fine, it's only four sentences" | Count beats, not sentences. Multiple beats → heading split, not packed paragraph. |
| "I've said this once, but let me reframe it from the deletion angle / call-site angle / historical angle" | One beat, three times, is still one beat. Pick the most informative angle and cut the others. |
| "Let me narrate which files changed and what changed in each" | Code archaeology. Diff has it. Name a file path only when the reviewer needs to *find* something the diff doesn't surface. |
| "It's a 24-line PR but the lede is a 100-word sentence threading five things" | Right-size to the diff. Tiny PRs get one or two short sentences. |
| "Just / really / basically / essentially / clearly / it's worth noting that …" | Padding. Cut. See *Cut padding*. |
| "## What's no longer public" / "## What was removed" + identifier list | Diff inventory dressed as a section. Cut. Promote any non-obvious removal decision into a sentence under `## Change`. |
| "Net diff: 53 files, 1081 insertions, 1021 deletions" | Recoverable from the PR header. Doesn't predict conflicts or regressions. Use `## Areas touched` instead. |
| "## Also in this PR — Docs: new CLAUDE.md walks through …" | Docs updates that follow mechanically don't earn an "Also in this PR" bullet. Reserve for behavioural or API consequences. |
| "Linking the implementation plan / task-tracking doc the author worked from" | Implementation plans are author-facing tracking. Skip. The Design sidecar is for the *spec* a reviewer would consult, not a to-do list. |
| "I'll add a Test plan checkbox list" | Use `## How to test` instead — concrete steps, no checkboxes. Drop entirely if every step is a generic command (`task test`, `go vet`). |
| "Let me list every changed file" | The diff has that. |
| "I should add a Background section to be thorough" | Only if it carries info the commits don't. |
| "I'll restate the title in the first sentence" | Cut. The reader has the title. |
| "Let me name the types and packages I touched" | Plain language unless an identifier is a non-obvious touchpoint. |
| "I'll add the 🤖 attribution" | Don't. |
| "I'll add a `## Human overview` section to frame the change" | That heading is a provenance claim about the human, not you. Put framing in the lede. |
| "The existing human overview reads a bit rough — let me tighten it" | Don't. It's the user's words; leave it byte-for-byte. |
| "Comprehensive / robust / seamless / elegant fits here" | Marketing register. Cut. |
| "This needs more structure to feel complete" | A short prose body *is* complete for a small PR. |
| "Plain prose only, no headings" | Overcorrection. Structure that anchors the reader (problem/change, parallel bullets) serves the cold-read test. |
| "Let me describe how the approach evolved" | Net diff, not session. |
| "I'll start writing once I've read the recent commits" | Read the full diff against base first. |
| "The title's a bit off but I'll just rewrite it while I'm here" | Don't change the title autonomously. Surface a recommended rewrite. |

**Violating the letter of these rules is violating the spirit of them.**
