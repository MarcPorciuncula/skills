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

The bar is **cold-read scannability**. A reviewer landing on this PR with no context should grasp what the change is and why within 30 seconds, before deciding how deeply to engage. Everything else in this skill serves that test.

A scannable body is one where:

- The change and its motivation are findable immediately — in the first paragraph or first heading, not buried mid-prose.
- The eye has anchor points. Paragraph breaks, headings where the PR has more than one beat, parallel bullets where items are genuinely parallel.
- Every line earns its place against the diff. Inventory restatement, marketing prose, and session journey all fail this test.

**Form serves the principle.** There is no single mandated shape — pick the one that lets *this* PR's reader get oriented fastest. The shapes below cover most cases.

## Shapes that often fit

Pick by complexity, not by reflex.

### Lede only

A single short paragraph in plain prose. Right when one or two sentences carry the whole picture.

> Narrows the scope of pre-commit self-checks (lint, type-check) so they target only changed packages instead of the full repo. The repo-wide pass is slow and CI runs it anyway — the local pass exists for fast iteration, not coverage.

That's the whole body. The diff is a build-config change and a contributing-docs update — the reviewer doesn't need anything more to read it fluently.

**Right-size to the diff.** When the diff is small (≲ 50 lines) and the title is self-explanatory, the body's job is whatever the title couldn't carry — typically a follow-up reference, a one-sentence "why now", or a constraint a reviewer would otherwise miss — and nothing else. One or two short sentences is the target. A four-sentence lede on a 24-line PR is overwriting the title; a paragraph re-explaining what the diff plainly shows is the same anti-pattern as the dense lede on a medium PR, just at a smaller scale. If you find yourself reaching for a second paragraph on a tiny PR, check whether you're saying something new or restating the first one from a different angle.

### Problem / Change

A `## Problem` heading with 1–3 sentences naming what was wrong, then a `## Change` heading with 1–3 sentences naming what the PR does. Right when the *why* takes more than a half-sentence to state, or when the contrast between problem and change is what makes the diff make sense.

> ## Problem
>
> The file-hydration pass re-fetches each `filestore://<id>/v<N>` reference at the *pinned* version on every turn. When a user edits a file between turns — increasingly common now that the markdown panel auto-saves edits back to filestore — the operator agent silently keeps quoting stale content.
>
> ## Change
>
> A new pass in the same plugin walks in-window refs, asks filestore what's current, and appends a short note to the most recent user turn naming the changed paths. The agent decides whether to re-read; the hint is informational, not a task list.

The headings can be `## Problem` / `## Change`, `## Why` / `## What`, or any pair that names this PR's beats. Don't reach for `## Summary` — that opens the door to bullet-inventory bodies.

### Lede + sidecars

A short prose lede, then named sections for material the reviewer must know but that doesn't fit the lede: deployability, stack ordering, design link, references, how to test.

> Switches the scheduled-job runner from in-process timers to a Postgres-backed leader-elected scheduler. A single instance acquires the lease and dispatches due jobs; other instances stay idle and only take over if the lease lapses. Existing job code is unchanged — only the dispatch surface moves.
>
> Lease semantics: renewed every 10s, expire after 30s, so a leader that goes silent (network partition, pause-the-world GC) loses dispatch authority before any other instance picks it up. During that gap, scheduled jobs may briefly miss their slot — the scheduler is "at-most-once per slot", not "exactly-once". Jobs that need at-least-once semantics already wrap themselves in idempotent retries; the scheduler does not try to add a layer on top.
>
> ## Background
>
> The previous in-process timer fired on every instance, and we relied on each handler's own dedupe to collapse the duplicate runs into one. That worked when there were three instances; under the current autoscaling profile (up to thirty), the dedupe write contention itself became the dominant cost. Moving dispatch to a single leader removes the contention entirely.
>
> ## Stack
>
> Stacked on #N. Merges after the lease-table migration in #N is applied to all environments.

Background earns its place because it explains why the prior approach stopped scaling — that's the reasoning that motivates the whole PR, and it's not in the commits. Stack earns its place because order matters for merging.

The shapes can combine — Problem/Change with a How-to-test sidecar is common.

#### Before/After code blocks for API-reshape refactors

When the *value* of a refactor is the API delta — a public surface narrows, a constructor contract changes, a call pattern shifts — two short Before/After code blocks at the call-site level are the most legible artifact a reviewer can have. They make the rest of the diff mechanical.

```go
// Before
sjSvc.RegisterKindForDispatch(KindFoo, FooOptions(2)...)
fooDispatcher := NewFooDispatcher(sjSvc)
```

```go
// After
fooDispatcher := FooJob.Bind(sjSvc)
```

Keep them tight:
- **Show a representative call site or two**, not the full type-signature surface. A reviewer reading two before/after snippets gets the shape; ten won't add information.
- **Show what changes**, not what stays the same. Cut configuration boilerplate, unrelated setup, and members the refactor doesn't touch.
- **Annotate only when needed.** A `// Before` / `// After` header is enough; longer commentary belongs in prose under `## Change`.

This is the one place the "no code archaeology" rule yields. The rule is about narrative prose that tells a story of which files changed; a tight Before/After is the *opposite* — it shows the contested delta directly. If you find your Before/After block running past ~15 lines per side, you've reverted to dumping the type surface; trim to the call sites that demonstrate the change.

## Voice

Peer engineer. State facts. Acknowledge limits honestly. Don't sell.

- "Adds the `is_admin` flag on the user-lookup endpoint only. The list and search endpoints leave the field at its zero value for now — populating them is a follow-up." — good. Calibrated about scope; names what isn't done.
- "Exposes per-caller admin status across the user resource." — bad. Sweeping claim that overstates the actual change. The reviewer will read it, then find the diff only touches one endpoint, then trust the body less.
- "Replaces three single-target image-transform tools with one bulk tool that accepts a list of operations. Cuts the per-call overhead the agent was paying for multi-step edits." — good. States the change and the benefit in plain words.
- "Introduces a more efficient batch-oriented approach to image transforms by consolidating the previously fragmented tool surface." — bad. Same content, but corporate.

Don't inject jokes, colloquialisms, or stylised asides to make the body feel human-written. They read as performance.

State the mechanism in plain language, not type names. "Adds an HTTP endpoint for updating an existing record by ID, with optional version-conflict checking so the client can detect a stale base" beats "Implements `PUT /resource/{id}` via `HandleUpdate` calling `UpdateResource`, which delegates through `loadAndCheckVersion` → `commitVersion`." Reach for identifier names only when an identifier is itself a non-obvious touchpoint a reviewer will need to find.

The same rule applies to **file paths**. Don't write narrative prose like "`pkg/server/webhooks.go` retyped the parameter to `MeetingEventPublisher`; meanwhile `pkg/simplejobs/worker/worker.go` was already passing the constructor's return value as of #1209" — that's code archaeology, not a reviewer handout. The diff already shows which files changed. Name a file path in the body only when the reviewer needs to *find* something the diff doesn't surface (e.g. "the contract is documented in `prompts/usage.md` next to the existing X section") — not when scene-setting a narrative about the change.

### Cut padding

LLM-generated prose accumulates connective tissue that adds words without information. Get the structure right (right shape, right beats) and the prose can still feel padded — that's the failure mode where a PR body reads as "overly prosed" even when the body-level rules pass. Cut at the sentence level too.

Words and phrases that almost always belong on the cutting room floor:

- **Hedges and intensifiers** — *just, simply, really, actually, basically, essentially, fundamentally, quite, rather, somewhat, fairly, particularly, clearly, obviously*. They never carry information; they only soften.
- **Filler lead-ins** — *It's worth noting that, It should be noted, Notably, Interestingly, As mentioned, In particular, In essence, At a high level, To be clear*. Whatever follows reads stronger without them.
- **Redundant self-reference** — *This change, This PR, This refactor* used as the subject of every sentence. The reader knows what they're reading. "This adds X" → "Adds X."
- **Explainer-mode openers** — *Let me explain, Let's walk through, To understand this, The way this works is*. The body is a handout, not a tutorial.
- **Empty contrasts** — *At the same time, On the other hand, That said* when nothing actually contrasts. If the next clause doesn't reverse the prior one, drop the connective.
- **Throat-clearing parentheticals** — recapping structural detail in parens (`exported struct with an unexported field, plus a nil-tolerant constructor and a fallback to UnavailableFoo`). The diff has the structure. State the *consequence*, not the inventory.

Same content, tightened:

| Before | After |
|---|---|
| "This change essentially refactors the auth middleware to handle expired tokens more gracefully." | "Refactors the auth middleware to handle expired tokens." |
| "It's worth noting that the worker now retries on transient failures." | "The worker now retries on transient failures." |
| "Basically, the previous approach was leaking goroutines on shutdown." | "The previous approach leaked goroutines on shutdown." |
| "Let me explain how this works: when a request comes in, we first authenticate, then dispatch." | "On request: authenticate, then dispatch." |
| "The struct itself is now unexported, so `Foo{}` no longer compiles — that literal in `pkg/x/y.go` was the bug #1209 just fixed by hand, and the shape that allowed it (exported struct with an unexported field, plus a nil-tolerant constructor and a `reconciler()` fallback to `UnavailableFoo`) only converted the misuse into a per-call Sentry error rather than a compile failure." | "Closes the loophole behind #1209: the exported struct + nil-tolerant constructor turned this misuse into a runtime Sentry rather than a compile error." |

**Fragments are OK when they save words.** "Follow-up to #1209." reads cleaner than "This is a follow-up to #1209." A trailing reference line, a stack pointer, or a one-word qualifier doesn't need to be wrapped in a complete sentence to be understood.

## Bullets vs paragraphs

Within any shape:

- **Bullets when items are genuinely parallel** — three or more correctness subtleties to flag, several review-handoff observations, multiple constraints. Each bullet can run a sentence or two; what matters is that the items share shape and the reader benefits from scanning them at once.
- **Paragraphs when items aren't parallel** — when one builds on another, when one is much weightier than the rest, when the reasoning flows.
- **Avoid the lead-in-then-paragraphs pattern.** "Two correctness subtleties worth flagging:" followed by two long prose paragraphs is a tell — if the items are parallel enough to deserve a lead-in, they're parallel enough to be bullets. If they're not, drop the lead-in and integrate the content into the surrounding prose.

The disease was never bullets; it was *bullet inventories of the diff* under `## Summary`. Parallel observations belong in bullets.

## PR titles

The title is the PR's identity across review lists, search, squash-merge commits, notifications, and changelog scans. It must work in all those contexts.

### Properties of a good title

- **Specific verb + object.** `Add X`, `Fix Y when Z`, `Move A out of B`, `Drop X`, `Switch X to Y`. Not abstract verbs like `Update`, `Improve`, `Refactor stuff`.
- **Names the affected behaviour, not just the area.** "Stop unmounting markdown editor on save" beats "Markdown editor lifecycle". The latter doesn't say what changed.
- **Matches the one-sentence scope.** Not broader (overpromises), not narrower (understates).
- **Stable across the PR's life.** Won't need rewriting if the implementation evolves. Don't reference internals that might change.
- **Conventional prefix when the team uses one.** `fix(scope): …`, `feat(scope): …` — match recent merged PRs.
- **Imperative-mood subject line.** Reads like a good commit message subject.

### What doesn't belong

- **Phase numbers** — unless the PR is part of an actively-in-flight stack (see Stack numbering below). A "phase 1 of 2 with a future spec" pairing isn't a stack — that's a sequence in your head, not in the merge graph. Phase signal goes in the body.
- **Exhaustive scope qualifiers** — long parenthetical lists of every touched area.
- **Implementation details** — type names, function names, file paths. Belong in the diff and the body.
- **Ticket IDs** — see *Ticket IDs in titles* below. The body's external-references section always carries them; the title prefix is conditional.

### Stack numbering — when it *does* belong

In a stack where merge order is enforced, the number is identity-bearing — the reviewer needs to know which segment they're looking at:

```
Port off Temporal 2/6: update reconcile interfaces
Port off Temporal 3/6: add River-backed dispatcher
```

A "this PR plus a future spec we haven't opened a PR for yet" pairing isn't a stack. Drop the numbering.

### Ticket IDs in titles

The body's external-references section always carries the ticket ID. The separate question is whether to also surface it as a title prefix.

- **Direct response → include in title.** The ticket's description is what the work set out to address; the PR closes (or canonically implements) the ticket; a teammate searching Linear for `AI-1234` would expect this PR as *the* implementation. Format: `AI-1234: …` or `fix(AI-1234): …` per team convention.
- **Incidental relationship → skip the prefix.** A follow-up fixing a side effect of an earlier ticket. A refactor that touches code the ticket mentioned. A change initiated independently but in the same area. A PR that addresses one corner of a larger ticket but isn't the canonical implementation.
- **When in doubt → skip the prefix.** The body still carries the reference, so omission is recoverable via search. Inclusion when the relationship is loose over-claims canonical status and pollutes tracking.
- **Team convention overrides** — if recent merged PRs consistently prefix titles with ticket IDs (or consistently don't), match the convention.

The decision test:

> *Would a teammate landing on the ticket and looking for "the PR that did this" expect to find this one via title prefix?*

Yes → prefix. No → body only.

### Self-test

Apply each before accepting a title — fresh or existing:

1. Specific verb + object (not `Update`, `Improve`, `Refactor`)?
2. Names the affected behaviour, not just the component or area?
3. Matches the one-sentence scope — not broader, not narrower?
4. Carries no info that belongs in the body (phase numbers outside an active stack, implementation detail, ticket ID for an incidental relationship)?
5. Could a reviewer skimming 50 PRs in a list identify this one in five seconds?

If 1, 2, 3, or 5 fail → strengthen. If 4 fails → trim.

### Protocol

- **Drafting a fresh PR**: write a title that passes the self-test before opening.
- **Editing an existing PR**: silently apply the self-test. If the title passes, leave it. If it fails, surface a recommended rewrite as `current → proposed`, with one sentence on why. Do not change the title autonomously.
- **Exception**: if the user explicitly asked for a title rewrite ("clean up the title", "rename the PR", "rewrite the title"), proceed without checking in.

Users identify PRs by their titles. Frequent or dramatic title changes make a PR hard to recognise as the same artifact across review cycles, search, and ongoing discussion. Every title change should be user-mandated or user-confirmed.

## Form the picture before drafting

Three disciplines apply before you write.

### State what the change is, in one sentence

Read the full diff against the base branch and the commit storyline, then state in one sentence what the PR does. If a changed file doesn't fit the sentence, either the sentence is wrong or the PR has stray scope. Don't start drafting until the sentence holds.

Without this gate, agents reading the diff bottom-up produce inventory-style bodies.

### Describe the net diff, not the session journey

The source of truth is `git diff <base>...HEAD`, not session memory. Whatever happened between commits — reverts, refactors, second attempts, abandoned approaches — is invisible to the reviewer and must be invisible to the body.

No "initially we did X, then refactored to Y" framing. No emphasis on the most recent commits over earlier ones. If a step was reverted, it didn't happen as far as the PR is concerned.

Mid-session, the live memory of the approach evolving will pull the body toward a session log. Re-derive from the diff.

### Check the title against your scope sentence

Run the self-test from `## PR titles` against the existing title. If it fails, follow the protocol there — surface a recommended rewrite, don't change the title autonomously.

## What goes in the body

After the lede (or problem/change pair), include only the material a reviewer needs that they couldn't get from the diff or commit messages.

### Observations the diff doesn't carry

An observation earns its place if it carries one of:
- A non-obvious design decision and why it was made
- A subtlety the reader is likely to miss while reading the code
- A behavioural difference (before vs after) that the diff doesn't make legible on its own
- A constraint, invariant, or assumption the change rests on
- A diff-shape signal that would surprise a reviewer if not flagged (e.g. unusually large churn from a mechanical reshape, a test file restructured for a non-obvious reason, a vendored file regenerated)

It does *not* earn its place if it:
- Lists files that changed (the diff has this)
- Restates an identifier rename / move ("renamed X to Y")
- Says "Adds tests for X" (the test files are visible)
- Recapitulates the lede in different words

If you can't write the observation without typing identifier names or file paths, that's a signal it doesn't belong in the body — it belongs in the diff or the commit message.

#### A worked borderline example

Imagine a PR adding new builder options to a library, with a paragraph in the proposed body that reads:

> The validation in the `With…` options panics on misconfiguration (empty name, non-positive numeric arguments, unknown enum values). That's deliberate and matches the existing patterns in this package: wiring bugs should fail at startup, not as malformed records in prod.

Cut it. It looks like it satisfies "non-obvious design decision and why" — fail-at-startup vs fail-at-runtime is a real choice. But the bar isn't "non-obvious to anyone, ever"; it's "non-obvious to *a reviewer reading this diff*." A reviewer who sees `panic("empty name")` understands the intent in two seconds without prose. The fail-at-startup rationale belongs in a code comment, where a future engineer touching the option type would actually look. The PR body is for things the reviewer can't recover from the diff itself.

The test: imagine the reviewer reading the PR with the body collapsed. Which paragraphs would they reach for to make sense of what they're seeing? Those are the ones that earn their place.

### Sidecars (only when load-bearing)

Add a sidecar section *only* if it carries information the reviewer must know and that doesn't fit elsewhere. Common ones:

- **Deployability** — when the PR has a rollout dependency, migration ordering constraint, or merge gate.
- **Stack** — when the PR is part of a stack and order matters.
- **Differences from #N** — when the PR re-bases or re-baselines an earlier sibling.
- **Areas touched** — for cross-cutting refactors and other PRs whose impact spans many packages or subsystems. Two or three lines naming *scope of impact* — which subsystems are affected, where conflicts with other in-flight work are likely, where to watch for regression after merge. The bar is "could a teammate predict where this PR collides with theirs without opening the diff?" Do *not* substitute a file count or a list of every file changed — those are recoverable from the diff and don't answer the conflict-and-regression question. Skip this for PRs scoped to a single package or subsystem; the title already conveys it.
  ```
  ## Areas touched

  - `pkg/foo/*` — internal API reshape; no behaviour change.
  - All composition roots (api, worker, periodic-runner) — call-site updates.
  - `pkg/{bar,baz}/dispatch.go` — new descriptors; old wrappers removed.
  ```
- **Also in this PR** — for secondary changes that genuinely fell out of the same work but aren't part of the headline change. One bullet per item, each naming a specific behavioural or API consequence (not a docs update or a rename — those are diff-recoverable). Use this heading verbatim; avoid prose framings like "Other changes that fell out of the refactor" or "Miscellaneous" — they read as apologetic. If a secondary change is load-bearing enough to need a paragraph, fold it into the main section instead.
- **Design** — a link to a design doc when one exists. Not a re-summary of it. Default to a single canonical link (the spec). Format as a `## Design` heading with the link on the line beneath:
  ```
  ## Design

  [docs/specs/2026-04-17-dev-entrypoint-design.md](docs/specs/2026-04-17-dev-entrypoint-design.md)
  ```
  When there are multiple distinct artifacts a reviewer would benefit from (e.g. current-phase spec + future-phase spec for a multi-PR plan), use a short list under the heading:
  ```
  ## Design

  - Phase 1 spec: [docs/specs/2026-04-27-feature-phase-1.md](docs/specs/2026-04-27-feature-phase-1.md)
  - Phase 2 spec (deferred): [docs/specs/2026-04-27-feature-phase-2.md](docs/specs/2026-04-27-feature-phase-2.md)
  ```
  **Implementation plans are not reviewer artifacts** — they're author-facing task tracking; skip them.
- **External references** — Linear tickets, related/follow-up PR numbers, issue links, parent or stacked PRs. **Always include these.** They are essential cross-reference tracking — not optional, not fluff, never to be cut for brevity. Include them even when they appear in the title (the title is for humans skimming a PR list; the body reference is for tools, search, and future readers tracing the change history). Format as plain lines at the bottom of the body, or as a small `## References` block when there are several:
  ```
  Linear: AI-1234
  Follow-up: #1235
  ```
- **Background** — only if there's context the commits don't carry. If the commit messages already explain the why, skip this.
- **How to test** — placed at the bottom of the body. Include when the change has user-visible or operationally observable behaviour that a reviewer would benefit from being able to reproduce. A plain numbered or bulleted list of concrete steps. Each step names a specific user action, command, or button — not a generic `task test` or `go vet`. No checkboxes (those signal pre-merge compliance, not reproduction). PR-specific by construction — if every PR's "How to test" looks the same, you've reverted to a compliance ritual; cut it. If a step doesn't tell the reviewer exactly what to type or click, rewrite it.

  ```
  ## How to test

  1. Start the API server locally with `task dev`.
  2. In another terminal, find the API process: `pgrep -f 'alcova server'`.
  3. Send `kill -TERM <pid>` and watch the logs — expect "graceful shutdown: draining" followed by a clean exit within ~8s.
  4. Repeat with `kill -INT <pid>` — expect "fast shutdown: dropping in-flight connections" and immediate exit.
  ```

Skip every sidecar that would be empty or filler.

## Human overview sections

A `## Human overview` (or similarly named — `## Human notes`, `## From the author`) section is a provenance claim. The heading asserts that what follows is the human's own words, added to the body after the fact. Two hard rules follow.

**Don't author one yourself.** Writing under that heading is lying about authorship — the section name is the load-bearing thing, not the content. If you want to add framing, reasoning, or context, put it in the lede or a substantive paragraph. The body is yours to write; the human overview is not.

**When editing an existing PR body, treat the section as immutable.** Leave it byte-for-byte — no copy-edits, no reflowing, no "while I'm here" tweaks, no merging it into the surrounding prose. Modify only the agent-authored content around it. If the human overview now contradicts the rest of the body because the diff has moved on, surface that to the user; don't reconcile it yourself.

These rules apply regardless of how the section is named, capitalised, or positioned, and regardless of whether it's currently empty (an empty `## Human overview` heading is the user reserving space — leave it).

## Drafting flow

1. Read the full diff against base and the commit storyline before writing anything.
2. State what the change is, in one sentence. Don't start drafting until the sentence holds.
3. Pick a shape — lede only, problem/change, or lede + sidecars — by the complexity of *this* PR.
4. Write the body in that shape.
5. Apply the cold-read test: would a reviewer with no context know what the PR is and why within 30 seconds of landing on it? If not, restructure — usually the change is to split a dense lede into problem/change, or to surface a buried observation as its own paragraph or bullet list.
6. Add only observations that earn their place. Add sidecars only if load-bearing.
7. Reread. Cut anything that hits a Red flag.

## Red flags — STOP

| Thought | Reality |
|---|---|
| "Let me start with `## Summary`" + bullets of changed files | Inventory of the diff. Don't. The reviewer has the diff. Use a prose lede or `## Problem` / `## Change`. |
| "I'll cram problem and change into one dense lede paragraph because headings before the lede are forbidden" | They aren't. If problem and change are each their own beat, split them with `## Problem` / `## Change`. The disease was inventory bullets, not headings. |
| "Two correctness subtleties worth flagging:" + two long prose paragraphs | Lead-in-then-paragraphs anti-pattern. If the items are parallel enough to share a lead-in, make them bullets. If they aren't, drop the lead-in and weave the content into the surrounding prose. |
| "The lede is fine, it's only four sentences" | Count the *beats*, not the sentences. If the lede has more than one beat (problem + change, current state + new state), it's better as a heading split than a packed paragraph. |
| "I've said this once, but let me reframe it from the deletion angle / call-site angle / historical angle" | One beat, three times, is still one beat. Pick the most informative angle and cut the others. If three angles all feel necessary, the underlying claim probably isn't load-bearing. |
| "Let me narrate which files changed and what changed in each" | Code-archaeology prose. The diff already shows which files changed. Name a file path only when the reviewer needs to *find* something the diff doesn't surface — not when scene-setting a story about the change. |
| "It's a 24-line PR but the lede is a 100-word sentence threading five things together" | Right-size the body to the diff. Tiny PRs with self-explanatory titles get one or two short sentences carrying whatever the title couldn't — a follow-up reference, a "why now", a constraint. Not a re-explanation of what the diff plainly shows. |
| "Just / really / basically / essentially / clearly / it's worth noting that …" | Padding. Cut. See the *Cut padding* subsection under Voice for the full blacklist and concrete sentence-level rewrites. |
| "## What's no longer public" / "## What was removed" + bulleted list of identifiers | Diff inventory dressed as a section. Cut. If a removal carries a non-obvious design decision (why this wrapper was deleted, why these peer types collapsed, why this option moved), promote that one decision into a sentence under `## Change` or alongside the relevant Before/After. The list itself is recoverable from the diff. |
| "Net diff: 53 files, 1081 insertions, 1021 deletions" | File count and line count are recoverable from the PR header. They don't tell the reviewer where conflicts or regressions will show up. If the PR is cross-cutting enough to want a scope statement, write `## Areas touched` instead — name the subsystems impacted. |
| "## Also in this PR — Docs: new CLAUDE.md walks through …" | Docs updates that follow mechanically from a code change don't earn an "Also in this PR" bullet. The diff has the file. Reserve the section for secondary *behavioural or API* consequences. |
| "Linking the implementation plan / task-tracking doc the author worked from" | Implementation plans are author-facing tracking, not reviewer artifacts. Skip. The Design sidecar is for the *spec* a reviewer would consult to evaluate the change, not the to-do list the author worked through. |
| "I'll add a Test plan checkbox list" | If the change has behaviour a reviewer would reproduce, write `## How to test` instead — concrete steps, no checkboxes. Rewrite an existing checkbox plan as `## How to test` if the steps are already concrete; drop entirely if every step is a generic command (`task test`, `go vet`) — that's compliance theatre, not reproduction. |
| "Let me list every changed file" | The diff has that. The body shouldn't. |
| "I should add a Background section to be thorough" | Only if it carries info the commits don't. |
| "I'll restate the title in the first sentence" | Cut it. The reader has the title. |
| "Let me name the types and packages I touched" | Plain language unless an identifier is a non-obvious touchpoint. |
| "I'll add the 🤖 attribution" | Don't. |
| "I'll add a `## Human overview` section to frame the change for the reviewer" | That heading is a provenance claim about the human, not you. Authoring under it is the violation. Put your framing in the lede. |
| "The existing human overview reads a bit rough — let me tighten it while I'm here" | Don't. It's the user's own words; leave it byte-for-byte. Edit only the surrounding agent-authored content. |
| "Comprehensive / robust / seamless / elegant fits here" | Marketing register. Cut. |
| "This needs more structure to feel complete" | A short prose body *is* complete for a small PR. Don't add structure to look thorough. |
| "Plain prose only, no headings, structure is bullet-inventory" | Overcorrection. The disease is inventory; structure that anchors the reader (problem/change, parallel bullets for parallel items) serves the cold-read test. |
| "Let me describe how the approach evolved" | The body describes the net diff, not the session. Reverts and intermediate states didn't happen as far as the reviewer is concerned. |
| "I'll start writing once I've read the recent commits" | Read the full diff against base first. Recent-commit bias skews the body toward what was done last instead of what the PR is. |
| "The title's a bit off but I'll just rewrite it while I'm here" | Don't change the title autonomously. Surface a recommended rewrite (`current → proposed`) to the user. Title churn makes the PR hard to recognise across review cycles. See `## PR titles`. |

**Violating the letter of these rules is violating the spirit of them.**
