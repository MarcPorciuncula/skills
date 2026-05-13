---
name: writing-pr-bodies
description: >
  Rules and guidelines for writing easily readable and accurate PR titles and 
  descriptions. TRIGGER before any `gh pr create`, `gh pr edit --body`, 
  `gs branch submit` `git-spice branch submit`, or any other command that opens
  or updates a pull request body, including autonomous PR creation where the
  user didn't specifically give direction about the PR body or the PR itself.
  SKIP for non-body PR operations (e.g. `gh pr ready`, `gh pr merge`, label
  or reviewer changes) and for commit messages.
---

# Writing PR Bodies

These rules and guidelines are to be followed when writing PRs, titles, and bodies.

## Audience

The primary reader is a senior software engineer with a focus on productivity, accuracy, and precision. Software engineers working with coding agents today process hundreds of PRs built by themselves, their coworkers, and AI agents. They suffer from constant context switching and mental overload. They need clear oversight and need to grep changes in a glance so they can make a quick judgements. This isn't hyperbole, it's reality. The engineer that reads your writing probably has 13 pull requests open in their browser right now, so poor writing and communication costs them time and money.

## Core requirements

A reviewer landing on your PR needs to be able to read, scan, or skim to grep the changes in ten seconds. The title and the PR body are crucial. Yes, they can see the detail in the diff and commit log, but that could be dozens of commits and tens of thousands of lines. Your writing must be optimised for **cold-read scannability**, it should be *salient*, *didactic*, and *accessible* to read quickly.

You must communicate *the net change* of the PR and its motivation or justification.

- DO state the change and its motivation immediately in the first paragraph, sentence, or heading
- DO explain the design and its trade-offs
- DO how design decisions are justified
- DO explain the before/after state for berhavioural changes or fixes
- DO point out flow on effects
- DO list out side-effects or incidental changes that made it into the branch
- DO use headings, paragraphs, and lists to make the content easily scannable
- DO NOT repeat the diff, the reader has access to the "files changed" tab
- DO NOT list out files UNLESS they are the crucial subject of the change
- DO NOT narrate changes over the lifecycle of the branch. a PR is merged atomically and intermediate states never get deployed
- DO amend or correct the PR to ensure it matches the final net changes after a pivot or deviation from the original intent or design
- DO NOT write out 'test checklists'. Tests MUST be done in the code, CI workflows, and manually before marking the PR ready so there is no use tracking them in the PR body.
- DO NOT use a "summary" title. The PR body **IS** the summary of the changes in the PR

## Functional vs non-functional changes

Any change to a codebase is either functional or non-functional. You'll already understand this concept, it's the same as deciding between "feat" "fix" "improvement" vs "chore" "docs" "refactor" style commits.

In a PR for a functional change, that functional change is the main subject.

- DO use when the party impacted by the change is the end user
- PRIORITISE the change in behaviour of the system over code level changes
- DO use active present or active past tense when describing the change "Adds new page", "Added a new page"
- DO frame the change in terms of user visible behaviour
- DO contrast past and new behaviour when the change is subtle or occurs under specific conditions or edge cases
- DEPRIORITISE changes and subtleties in the code or components

A non functional change usually changes code organisation, architecture, or tooling. In this case changes and subtleties in the code or components is the main subject.

- DO use when the party impacted by the change is the system or the developers maintaining the system.
- DO describe the transition and code level changes at an appropriate level of detail
- DO use code-level language, identifier names, file paths, and structural terms
- DO NOT characterise components as actors "Code generation moves to the pre-build stage"
- DO use passive voice when describing components being moved or otherwise affected "Code generation has been moved to the pre-build stage" "Code generation now runs after dependency install"
- DO call out flow on effects that might affect functionality and end users

Sometimes a PR can carry both kinds of change, but will generally lead more towards one side than the other. Use the appropriate framing for the appropriate change.

## Writing style

The writing style is crucial to how fast a reader greps the changes in the PR. The CORE GOAL of this text is to communicate the changes as EFFECTIVELY, CLEARLY, and QUICKLY as possible. The text must be written in a TECHNICAL + ACCESSIBLE register.

**Its subject matter is inherently technical**

- DO use precise technical terms and concepts
- DO use the same domain language and symbols that the code uses
- DO NOT colloquialise technical terms
- DO preserve accuracy and avoid or hedge unchecked or unsubstantiated claims

**It's not an essay**.

- DO NOT signpost upcoming content or structure
- DO NOT describe the structure of the PRs body's own prose
- DO NOT use formal or persuasive language
- DO NOT express opinion
- DO keep it factual

**It must be accessible**

Accessible writing is the key to fast, clear comprehension.

- DO use plain sentence shapes and forms
- DO use sentence fragments when they save words ("Follow-up to #1209" not "This is a follow-up to #1209")
- DO use dot points to listing legitimately parallel items
- DO NOT use dot points to dump unrelated content quickly
- DO NOT use em dashes or threaded clauses even if they are more "correct" sentence forms.
- DO NOT use "technical prose". DO use technical terms for subject matter.
- DO NOT use long, winding clauses
- DO NOT use verbs to evoke literary animation
- DO NOT waste words to bridge paragraphs

**The change of a PR is atomic**

- DO describe all changes in the PR as if they would land all at once
- DO update the PR when a recent commit affects the *net-change* of the whole PR
- DO NOT describe pivots in design or intermediate states of the branch's changes
- DO NOT reference which commits contain which changes


### HARD RESTRICTION: DO NOT WASTE WORDS DESCRIBING THE TEXT'S OWN STRUCTURE

RECOGNISE these common literary signposting patterns.

| Sentence | What it talks about |
|---|---|
| "Two changes together change that. First, … Second, …" | the upcoming paragraphs |
| "Two changes that together let the binary stop carrying environment information at link time" | the upcoming paragraphs (lede form) |
| "Three failure modes followed:" | the list shape |
| "The flow is two-legged:" | the list shape (stripping the count doesn't rescue it) |
| "The hook is the third writer to the threads cache (after X and Y)" | its position in a sequence |
| "It's worth noting that X" | how much weight X carries |
| "Notably, …" / "In particular, …" / "As mentioned, …" | the prose's weighting or backward-reference |
| "At the same time, On the other hand, That said" (when nothing contrasts) | a relationship between sentences that doesn't exist |
| "Let me explain how this works" / "Let's walk through" | the next sentence |
| "## Summary" + bullets of changed files | the document's own inventory |

These patterns waste words describing the text itself and not the PR.

- DO NOT write these problematic patterns
- DO delete or rephrase them out of the text
- DO NOT count prose
- DO preserve counts when counting actual code shape. Example: "There are four affected GlossaryService RPCs (list / create / update / delete)"

### HARD RESTRICTION: DO NOT CHARACTERISE OR ANIMATE THE CHANGE

RECOGNISE these literary characterisation and animation patterns.

| REJECT | PREFER | WHY |
|---|---|---|
| "Go compilation moves into the Dockerfile" | "Go compilation step has been moved into the Dockerfile" | "Go compilation" is being characterised as the actor. Recast the construct as the object of the change. |
| "Two additional fixes fell out of this change" | "Includes two additional fixes" | "fell out" is used as literary animation, this is hard to grep. Be explicit. |
| "The previous attempt at fixing this defeated keyed cache reuse" | "A previous attempt broke keyed cache reuse" | "defeated" is literary animation. Be explicit. |

These patterns dilute the information and require readers to process through layers of indirection.

- DO NOT write these problematic patterns
- DO delete or rephrease them out of the text
- DO NOT describe the change as a narrative
- DO downlevel to plain, accessible language

### HARD RESTRICTION: DO NOT PAD WORDS THAT CARRY NO INFORMATION

RECOGNISE these common padding patterns.

| Pattern | What it's doing |
|---|---|
| "just, simply, really, actually" | hedge or filler — no information added |
| "basically, essentially, fundamentally" | hedge or vague emphasis — no information added |
| "quite, rather, somewhat, fairly, particularly" | weak intensifier — softens or vaguely emphasises |
| "clearly, obviously" (when not announcing emphasis) | empty intensifier |
| "This change does X" / "This PR adds Y" | redundant self-reference — drop the subject ("Adds Y") |

These patterns consume the reader's processing budget without adding information.

- DO NOT write these patterns
- DO delete or rephrase them out of the text
- DO trust the reader to weight content from the verb and noun
- DO state the bare fact. "Adds X" beats "This change essentially adds X"

## Common PR Structures

Remember the core objectives when structuring your PR. We want to structure for **cold-read scannability**

### Lede

The lede is the opening sentence and paragraph(s), and is the main prose of the PR. You should be able to communicate the high level change and motivation in just the PR title and lede alone.

- DO right-size your writing to the change. A small diff change with a self explanatory title only deserves a couple sentences.
- DO provide the necessary details that the title can't carry

### Problem / Change structure

A `## Problem` heading with 1–3 sentences naming what was wrong, then a `## Change` heading with 1–3 sentences naming what the PR does. Problem / change framing implies something existing was broken and in a state not originally designed. Something can be poorly designed or poorly operating, but "correct" according to its original specification.

- DO use for GENUINE bugs or faults
- DO use for "UX bugs" where the previous state was hard to use or obstructionary
- DO use when the problem itself requires at least a paragraph to explain
- DO NOT use when "Fixes an issue where xyz..." as a lede would suffice.
- DO NOT use for improvements, refactors, feature additions even if they are addressing shortcomings
- DO NOT use the problem / change structure when making an *improvement*. An improvement is NOT a problem / change. The previous state may have been *undesirable* but not *incorrect*

> ## Problem
>
> The file-hydration pass re-fetches each `filestore://<id>/v<N>` reference at the *pinned* version on every turn. When a user edits a file between turns — increasingly common now that the markdown panel auto-saves edits back to filestore — the operator agent silently keeps quoting stale content.
>
> ## Change
>
> A new pass in the same plugin walks in-window refs, asks filestore what's current, and appends a short note to the most recent user turn naming the changed paths. The agent decides whether to re-read; the hint is informational, not a task list.

Heading pairs can be `## Problem` / `## Change`, `## Why` / `## What`, or any pair that names this PR's beats. Don't reach for `## Summary` — it opens the door to bullet-inventory bodies.

**Don't use Problem/Change for `feat:` / `improve:` / `refactor:` work.** The shape forces a "what was broken" frame, and forcing it onto a non-bug pathologises prior decisions that were deliberate. Use *Feature lede* (next) instead.

### Feature lede

For PRs that add new behaviour, improve a UX, or refactor — anything that would naturally be `feat:` / `improve:` / `refactor:` rather than `fix:`. The prior state isn't being treated as a bug; this change adds to it or makes it better.

Lead with what the change *adds* or *improves*, in present tense, with the prior state as a comparison point if useful. The reader experiences the prior state as "what is" (not "what was broken"), and the new state as "what's now possible".

> Adds upload progress indicators to the attachment picker. Instead of a single spinner that hides everything in flight, each file shows its own progress bar and a cancel button. Failed uploads stay in the picker with a retry option rather than disappearing silently.

| Frame | Trigger | Lede |
|---|---|---|
| **Feature** | `feat:` / `improve:` / `refactor:` — work motivated by adding capability | "Adds upload progress indicators to the attachment picker. Each file shows its own progress bar and a cancel button; failed uploads stay in the picker with a retry option." |
| **Bug fix** | `fix:` — work motivated by a bug report | "Fixes the attachment picker so failed uploads no longer disappear silently. Previously a failed upload was removed from the UI with no error; now it stays with a retry button." |

Anchor on the work's motivation (commit prefix, ticket type, what prompted the work), not on a judgment about whether the prior state was good or bad. Almost any prior state has *some* undesirable property — that doesn't make it a bug. If you find yourself reaching for "well, the prior state was actually wrong because…" to justify Problem/Change on improvement work, you're rationalising. The diagnostic: if you naturally write "X became Y" / "Y was lost" / "Z surfaced as a toast" (past tense, pathologising), you're framing as a bug fix; if you naturally write "X creates Y" / "the picker shows Z" (present tense, descriptive), you're framing as a feature. Match the frame to the work's motivation, not to the most prescribed shape.

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

**Verb tense is a framing diagnostic.** Past tense ("X became Y", "Y was lost", "Z surfaced as a toast") narrates a failure — use it for genuine bug fixes (`fix:` work). Present tense ("X creates Y", "the picker shows Z") describes existing behaviour without judging it — use it for feature work (`feat:` / `improve:` / `refactor:`). If you find yourself reaching for past tense to describe behaviour that wasn't a bug, the frame is wrong; switch to *Feature lede*.

**Use user-visible language for user-visible changes.** "Multipart upload to S3 with chunked transfer encoding" describes the data flow; "each file shows its own progress bar as it uploads" describes what the user sees. For UX-affecting PRs, lead with what the user does and notices ("drag a file in", "see the progress bar", "cancel mid-upload") rather than the implementation flow.

State the mechanism in plain language, not type names. "Adds an HTTP endpoint for updating an existing record by ID, with optional version-conflict checking" beats "Implements `PUT /resource/{id}` via `HandleUpdate` calling `UpdateResource`". Reach for identifier names only when the identifier is itself a non-obvious touchpoint a reviewer needs to find.

The same rule applies to **file paths**. Don't write narrative prose like "`pkg/server/webhooks.go` retyped the parameter; meanwhile `pkg/simplejobs/worker/worker.go` was already passing the constructor's return value as of #1209" — that's code archaeology. Name a file path only when the reviewer needs to *find* something the diff doesn't surface.

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
  Linear: [AI-1234](https://linear.app/<workspace>/issue/AI-1234)
  Follow-up: #1235
  ```
  **Use full URLs for systems GitHub doesn't auto-link** — Linear, Jira, Notion, Sentry, Google Docs, internal dashboards. A bare `AI-1234` is unclickable; the reviewer has to copy it into Linear's search to find the ticket, which most won't bother to do, so the reference is dead weight. Cross-repo PRs and issues need the `owner/repo#123` form (or full URL) for the same reason. **GitHub references in the same repo are the exception** — `#1235`, `@username`, and commit SHAs auto-link, so plain forms are fine. If you don't know the workspace slug or exact URL shape for a Linear/Jira ticket, ask rather than printing the bare ID.
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
6. **Accessibility pass.** Read the body back as a tired reviewer skimming at speed between context-switches. Two questions on every sentence:
   - *What is this sentence about?* If it's about the prose itself — its structure, what comes next, how many items follow, a position in a sequence, how much weight a fact carries — cut or rewrite. (See *Focus on describing the system or the change*.)
   - *Does it parse on first read?* If a clause needs re-reading, simplify. Threaded em-dashes, three-clause sentences, animation verbs ("moves into", "lands at") are common offenders. (See *Describe the new state, not the diff*.)
7. Add only observations that earn their place. Add sidecars only if load-bearing.
8. Reread. Cut anything that hits a Red flag.

## Red flags — STOP

| Thought | Reality |
|---|---|
| "Let me start with `## Summary`" + bullets of changed files | Diff inventory. Use a prose lede or `## Problem` / `## Change`. |
| "I'll cram problem and change into one dense lede paragraph" | Headings before the lede aren't forbidden. Split with `## Problem` / `## Change`. The disease is inventory bullets, not headings. |
| "There's a clear before/after, so this is Problem/Change" | Before/after isn't sufficient. Problem/Change is for `fix:` work — closing a bug ticket. If the work would be `feat:` / `improve:` / `refactor:`, use *Feature lede*. Past-tense pathologisation ("X became Y", "Y was lost") is the tell that you've misframed an improvement as a fix. |
| "The prior state had this undesirable property, so it was actually broken, so Problem/Change applies" | Almost any prior state has some undesirable property — that doesn't make it a bug. The criterion is the work's motivation (commit prefix, ticket type), not a retrospective judgment about whether the prior state was good. `feat:` / `improve:` / `refactor:` → *Feature lede*. `fix:` → Problem/Change. |
| "I'll narrate this UX feature in implementation terms — `multipart S3 uploads`, `chunked transfer`, `retry-with-backoff handler`" | UX-affecting PRs read in user-visible language. "Drag a file in", "see per-file progress", "click cancel" — what the user does and notices. Implementation-flow framing is what a system architect would write, not what the reviewer reads first. |
| "Two correctness subtleties worth flagging:" + two long prose paragraphs | Lead-in-then-paragraphs anti-pattern. Parallel items → bullets. Non-parallel → drop the lead-in. |
| "Three failure modes followed: …" / "A few issues remain: …" / "Three new endpoints: …" / "The migration steps: …" / "The flow is two-legged: …" / "The change has the following implications: …" | List preamble doing no work — the clause only announces the list. The colon-bullets case is the most common shape; counts (leading or embedded), vague quantifiers, and label-only headers all qualify. Stripping the count doesn't rescue the preamble. See *Focus on describing the system or the change* and the Cut padding table. |
| "Two changes together change that. First, … Second, …" / "Two changes that together let X stop Y" / "Three things follow from that. First, … Second, … Third, …" | List preamble in prose form — the count announces upcoming paragraphs, doing the same no-work job as the colon-then-bullets version. The fact that the bridge sentence is grammatically a sentence (with a period instead of a colon) doesn't change what it's doing. Cut the bridge; the paragraphs stand on their own. See *Focus on describing the system or the change*. |
| "The hook is the third writer to the threads cache (after X and Y)" / "This is the second consumer of the registry" | Positional descriptor announcing a sequence position the reader didn't ask for. The relevant content is what the hook does and what the other writers exist for — not its ordinal. Drop the count. |
| "Go compilation moves into the Dockerfile" / "The binary stops carrying environment information at link time" / "Build & push is now gated on a probe" / "Logic moves out of the worker into the dispatcher" | Animation verb describing a diff transition the reviewer doesn't see. Name what the new code is or does. *"The Dockerfile compiles Go in a separate builder stage."* *"The binary reads `ALCOVA_ENVIRONMENT` from the process env at start."* *"Before build & push, a probe skips the step when the SHA tag already exists."* See *Describe the new state, not the diff*. |
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
| "Linear: AI-1234" / "Sentry: ABC-42" / "Doc: Architecture overview" — a bare ID or label without a URL | Unclickable reference is dead weight — the reviewer won't paste an ID into a search box. External systems that GitHub doesn't auto-link (Linear, Jira, Notion, Sentry, Google Docs, dashboards) need full URLs. GitHub same-repo refs (`#1235`, `@user`, SHAs) auto-link and don't. If the URL shape is unknown, ask. |
| "I'll add a `## Human overview` section to frame the change" | That heading is a provenance claim about the human, not you. Put framing in the lede. |
| "The existing human overview reads a bit rough — let me tighten it" | Don't. It's the user's words; leave it byte-for-byte. |
| "Comprehensive / robust / seamless / elegant fits here" | Marketing register. Cut. |
| "This needs more structure to feel complete" | A short prose body *is* complete for a small PR. |
| "Plain prose only, no headings" | Overcorrection. Structure that anchors the reader (problem/change, parallel bullets) serves the cold-read test. |
| "Let me describe how the approach evolved" | Net diff, not session. |
| "I'll start writing once I've read the recent commits" | Read the full diff against base first. |
| "The title's a bit off but I'll just rewrite it while I'm here" | Don't change the title autonomously. Surface a recommended rewrite. |

**Violating the letter of these rules is violating the spirit of them.**
