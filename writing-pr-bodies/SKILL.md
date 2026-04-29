---
name: writing-pr-bodies
description: >
  Use when writing or improving a pull request body / description — including
  the body produced as part of `gh pr create`. Produces a short, prose-led
  description aimed at a human reviewer about to read the diff, not a re-
  narration of the diff itself.
---

# Writing PR Bodies

A PR body is a handout for a reviewer who is about to read the diff.

## Iron Law

**LEAD WITH PROSE. THE FIRST THING A REVIEWER SEES IS 1–4 SENTENCES IN PLAIN LANGUAGE STATING WHAT THE CHANGE DOES AND WHY.**

No bullets in the lede. No headings before the lede. No `## Summary` opening with `- Adds X` `- Refactors Y`. The reader gets the gist as a paragraph, in the voice of a peer at standup, before any structure appears.

If the lede paragraph alone is enough — for a small PR — that's the whole body.

## Voice

Peer engineer. State facts. Acknowledge limits honestly. Don't sell.

- "Adds the `is_admin` flag on the user-lookup endpoint only. The list and search endpoints leave the field at its zero value for now — populating them is a follow-up." — good. Calibrated about scope; names what isn't done.
- "Exposes per-caller admin status across the user resource." — bad. Sweeping claim that overstates the actual change. The reviewer will read it, then find the diff only touches one endpoint, then trust the body less.
- "Replaces three single-target image-transform tools with one bulk tool that accepts a list of operations. Cuts the per-call overhead the agent was paying for multi-step edits." — good. States the change and the benefit in plain words.
- "Introduces a more efficient batch-oriented approach to image transforms by consolidating the previously fragmented tool surface." — bad. Same content, but corporate.

Don't inject jokes, colloquialisms, or stylised asides to make the body feel human-written. They read as performance.

State the mechanism in plain language, not type names. "Adds an HTTP endpoint for updating an existing record by ID, with optional version-conflict checking so the client can detect a stale base" beats "Implements `PUT /resource/{id}` via `HandleUpdate` calling `UpdateResource`, which delegates through `loadAndCheckVersion` → `commitVersion`." Reach for identifier names only when an identifier is itself a non-obvious touchpoint a reviewer will need to find.

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

Three disciplines apply before you write the lede.

### State what the change is, in one sentence

Read the full diff against the base branch and the commit storyline, then state in one sentence what the PR does. If a changed file doesn't fit the sentence, either the sentence is wrong or the PR has stray scope. Don't start drafting until the sentence holds.

Without this gate, agents reading the diff bottom-up produce inventory-style bodies.

### Describe the net diff, not the session journey

The source of truth is `git diff <base>...HEAD`, not session memory. Whatever happened between commits — reverts, refactors, second attempts, abandoned approaches — is invisible to the reviewer and must be invisible to the body.

No "initially we did X, then refactored to Y" framing. No emphasis on the most recent commits over earlier ones. If a step was reverted, it didn't happen as far as the PR is concerned.

Mid-session, the live memory of the approach evolving will pull the body toward a session log. Re-derive from the diff.

### Check the title against your scope sentence

Run the self-test from `## PR titles` against the existing title. If it fails, follow the protocol there — surface a recommended rewrite, don't change the title autonomously.

## Anatomy

Three layers, in order. Each layer is optional past the first; only include a layer if it earns its place.

### 1. Lede paragraph (always)

1–4 sentences in plain prose. What the change does, why it exists, in language a peer would use. Trust the principle on length — write what's needed and stop.

The lede answers the reviewer's first question: *what am I about to read, and why does it exist?* It does not list files, restate the title, or narrate the diff.

### 2. Substantive details (when needed)

For non-trivial PRs, the observations a reviewer needs to read the diff fluently. One observation per *thing that isn't obvious from the diff*.

An observation earns its place if it carries one of:
- A non-obvious design decision and why it was made
- A subtlety the reader is likely to miss while reading the code
- A behavioural difference (before vs after) that the diff doesn't make legible on its own
- A constraint, invariant, or assumption the change rests on
- A diff-shape signal that would surprise a reviewer if not flagged (e.g. unusually large churn from a mechanical reshape, a test file restructured for a non-obvious reason, a vendored file regenerated)

An observation does *not* earn its place if it:
- Lists files that changed (the diff has this)
- Restates an identifier rename / move ("renamed X to Y")
- Says "Adds tests for X" (the test files are visible)
- Recapitulates the lede in different words

If you can't write the observation without typing identifier names or file paths, that's a signal it doesn't belong in the body — it belongs in the diff or the commit message.

**Prefer paragraphs over bullets once an item runs past one or two sentences.** Reach for bullets only for three-plus genuinely parallel short items. The medium anchor below is the model — paragraphs with line breaks, no bullets.

#### A worked borderline example

Imagine a PR adding new builder options to a library, with a paragraph in the proposed body that reads:

> The validation in the `With…` options panics on misconfiguration (empty name, non-positive numeric arguments, unknown enum values). That's deliberate and matches the existing patterns in this package: wiring bugs should fail at startup, not as malformed records in prod.

Cut it. It looks like it satisfies "non-obvious design decision and why" — fail-at-startup vs fail-at-runtime is a real choice. But the bar isn't "non-obvious to anyone, ever"; it's "non-obvious to *a reviewer reading this diff*." A reviewer who sees `panic("empty name")` understands the intent in two seconds without prose. The fail-at-startup rationale belongs in a code comment, where a future engineer touching the option type would actually look. The PR body is for things the reviewer can't recover from the diff itself.

The test: imagine the reviewer reading the PR with the body collapsed. Which paragraphs would they reach for to make sense of what they're seeing? Those are the ones that earn their place.

### 3. Sidecars (only when load-bearing)

Add a sidecar section *only* if it carries information the reviewer must know and that doesn't fit in the lede or substantive bullets. Common ones:

- **Deployability** — when the PR has a rollout dependency, migration ordering constraint, or merge gate.
- **Stack** — when the PR is part of a stack and order matters.
- **Differences from #N** — when the PR re-bases or re-baselines an earlier sibling.
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

## Anchor examples

These are the model. Read them before drafting.

All anchor examples below are illustrative — synthesized to demonstrate structural patterns, not lifted from any real PR. Don't treat the wording as templates to copy; treat the *shape* as the lesson.

### Small PR (lede only is enough)

> Narrows the scope of pre-commit self-checks (lint, type-check) so they target only changed packages instead of the full repo. The repo-wide pass is slow and CI runs it anyway — the local pass exists for fast iteration, not coverage.

That's the whole body. The diff is a build-config change and a contributing-docs update — the reviewer doesn't need anything more to read it fluently.

### Medium PR (multi-paragraph prose lede)

> Adds an `Idempotency-Key` header on `POST /checkout` so a retrying client lands on the same charge instead of creating a new one. The gateway records the first request's response under that key and replays it for matching subsequent requests.
>
> The store is keyed on `(merchant_id, idempotency_key)` and expires after 24 hours — long enough to cover client retry policies, short enough that the table stays bounded.
>
> Replays return the original status and body, with a `Idempotent-Replayed: true` header so a merchant's retry tooling can distinguish a fresh charge from a deduplicated one in their logs. That visibility is the only behavioural difference between a replay and a first-time request.
>
> The implementation matches the documented header semantics most of our merchants are migrating from. The test suite covers the cases an integration written against that pattern relies on; it does not try to cover every edge case in the upstream documentation.

Multiple short paragraphs, no bullets, no headings. Each paragraph is one observation a reviewer needs. The closing sentence is load-bearing — it tells the reviewer the bar this PR clears, and what's deliberately out of scope.

### Larger PR (lede + sidecar)

> Switches the scheduled-job runner from in-process timers to a Postgres-backed leader-elected scheduler. A single instance acquires the lease and dispatches due jobs; other instances stay idle and only take over if the lease lapses. Existing job code is unchanged — only the dispatch surface moves.
>
> The interesting subtlety is in the lease semantics: leases are renewed every 10s and expire after 30s, so a leader that goes silent (network partition, pause-the-world GC) loses dispatch authority before any other instance picks it up. During that gap, scheduled jobs may briefly miss their slot — the scheduler is "at-most-once per slot", not "exactly-once". Jobs that need at-least-once semantics already wrap themselves in idempotent retries; the scheduler does not try to add a layer on top.
>
> ## Background
>
> The previous in-process timer fired on every instance, and we relied on each handler's own dedupe to collapse the duplicate runs into one. That worked when there were three instances; under the current autoscaling profile (up to thirty), the dedupe write contention itself became the dominant cost. Moving dispatch to a single leader removes the contention entirely.
>
> ## Stack
>
> Stacked on #N. Merges after the lease-table migration in #N is applied to all environments.

Background earns its place because it explains why the prior approach stopped scaling — that's the reasoning that motivates the whole PR, and it's not in the commits. Stack earns its place because order matters for merging.

## Drafting flow

1. Read the full diff against base and the commit storyline before writing anything.
2. State what the change is, in one sentence. Don't start drafting until the sentence holds.
3. Write the lede. For most PRs, this is the whole body.
4. If the PR is non-trivial, add only the substantive observations a reviewer needs to read the diff fluently. Apply the "earns its place" filter to each.
5. Add sidecars only if load-bearing.
6. Reread. Cut anything that hits a Red flag.

## Red flags — STOP

| Thought | Reality |
|---|---|
| "Let me start with `## Summary`" | The lede is prose, not a heading. Don't open with bullets. |
| "I'll add a Test plan checkbox list" | If the change has behaviour a reviewer would reproduce, write `## How to test` instead — concrete steps, no checkboxes. Rewrite an existing checkbox plan as `## How to test` if the steps are already concrete; drop entirely if every step is a generic command (`task test`, `go vet`) — that's compliance theatre, not reproduction. |
| "Let me list every changed file" | The diff has that. The body shouldn't. |
| "I should add a Background section to be thorough" | Only if it carries info the commits don't. |
| "I'll restate the title in the first sentence" | Cut it. The reader has the title. |
| "Let me name the types and packages I touched" | Plain language unless an identifier is a non-obvious touchpoint. |
| "I'll add the 🤖 attribution" | Don't. |
| "I'll add a `## Human overview` section to frame the change for the reviewer" | That heading is a provenance claim about the human, not you. Authoring under it is the violation. Put your framing in the lede. |
| "The existing human overview reads a bit rough — let me tighten it while I'm here" | Don't. It's the user's own words; leave it byte-for-byte. Edit only the surrounding agent-authored content. |
| "Comprehensive / robust / seamless / elegant fits here" | Marketing register. Cut. |
| "This needs more structure to feel complete" | A short prose body *is* complete. Don't default to bullets-and-headings. |
| "Let me describe how the approach evolved" | The body describes the net diff, not the session. Reverts and intermediate states didn't happen as far as the reviewer is concerned. |
| "I'll start writing once I've read the recent commits" | Read the full diff against base first. Recent-commit bias skews the body toward what was done last instead of what the PR is. |
| "The title's a bit off but I'll just rewrite it while I'm here" | Don't change the title autonomously. Surface a recommended rewrite (`current → proposed`) to the user. Title churn makes the PR hard to recognise across review cycles. See `## PR titles`. |

**Violating the letter of these rules is violating the spirit of them.**
