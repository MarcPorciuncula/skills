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

**The subject matter is inherently technical**

- DO use precise technical terms and concepts
- DO use the same domain language and symbols that the code uses
- DO NOT colloquialise technical terms
- DO preserve accuracy and avoid or hedge unchecked or unsubstantiated claims

**The change of a PR is atomic**

- DO describe all changes in the PR as if they would land all at once
- DO update the PR when a recent commit affects the *net-change* of the whole PR
- DO NOT describe pivots in design or intermediate states of the branch's changes
- DO NOT reference which commits contain which changes

**It must be accurate, measured, and well scoped**

- DO name what isn't done when related and relevant ("populating the list endpoint is a follow-up", "only xyz service was migrated, other services will need to be migrated going forward")
- DO NOT name "out of scope" items that no one asked about.
- DO scope claims to what the change actually covers
- DO NOT make sweeping claims that overstate the plans
- DO right-size detail to the diff. state what the reader needs to act on or be aware of; trust the code for the line-by-line detail.
- DO NOT include verbatim code chunks in the description
- DO include illustrative and abridged code chunks when the subject matter is code architecture, refactors, interfaces, or APIs

**It's not an essay**.

- DO NOT signpost upcoming content or structure
- DO NOT describe the structure of the PRs body's own prose
- DO NOT use formal, persuasive, or marketing-style language
- DO NOT reach for marketing or corporate register ("comprehensive", "seamless")
- DO NOT express unsolicted opinions
- DO NOT "sell"

**Only use bullets for genuine lists**

- DO use bullets when items are parallel, when you are **listing out** items of a repeating structure or topic matter. 
- DO NOT use bullet lists to mask unrelated content as "list items"
- DO NOT add useless bullet list lead-ins. eg. "Two changes:" "The flow is two legged"
- DO NOT put large paragraphs in bullet lists.
- DO NOT use bullet lists to "inventory" the changes or the diff

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

## Body & common sections

Every PR has a lede. After the lede, compose additional sections the PR needs from this catalogue, or author your own when none of the patterns fit. No section is required, and a useless section is worse than no section.

Add a section only if it carries information the reviewer needs that they couldn't get from the diff or commit messages.

DO INCLUDE:

- A non-obvious design decision and why it was made
- A subtlety the reader is likely to miss while reading the code
- A behavioural difference (before vs after) that the diff doesn't make legible
- A constraint, invariant, or assumption the change rests on
- An unusual diff shape that would surprise a reviewer if not flagged (large mechanical churn, restructured tests, regenerated vendored files)

DON'T INCLUDE CONTENT THAT:

- Lists files that changed
- Restates trivialities of a refactor, rename or move
- Says "Adds tests for X"
- Restates the lede in different words

NEVER write a `## SUMMARY` section. The PR body **is** the summary.

### Lede

The opening sentence or paragraph carrying the PR's headline change. Right-size to the PR. Small diffs warrant one or two short sentences; complex changes get a paragraph or two.

Lead with what the change does. Frame the new state directly. Use the prior state as a comparison point only when it clarifies.

- DO lead with the change itself
- DO right-size to the PR
- DO NOT bury the change behind preamble or context

> Adds upload progress indicators to the attachment picker. Instead of a single spinner that hides everything in flight, each file shows its own progress bar and a cancel button. Failed uploads stay in the picker with a retry option rather than disappearing silently.

### Problem / Change

A heading-pair structure that supplements or replaces the lede when a bug fix benefits from framing the problem before the change. Two headings, `## Problem` and `## Change`, make the contrast between what was wrong and what the PR does legible at a glance.

Heading pairs can be `## Problem` / `## Change`, `## Issue` / `## Fix`, or any pair that fits.

- DO use for genuine bugs or faults closed by this PR
- DO use when the problem requires at least a paragraph to explain
- DO NOT use when "Fixes an issue where xyz..." as a lede would suffice
- DO NOT use for improvements, refactors, or feature additions. They aren't bug fixes even if the prior state was undesirable

> ## Problem
>
> The file-hydration pass re-fetches each `filestore://<id>/v<N>` reference at the *pinned* version on every turn. When a user edits a file between turns — increasingly common now that the markdown panel auto-saves edits back to filestore — the operator agent silently keeps quoting stale content.
>
> ## Change
>
> A new pass in the same plugin walks in-window refs, asks filestore what's current, and appends a short note to the most recent user turn naming the changed paths. The agent decides whether to re-read; the hint is informational, not a task list.

### Before/After code blocks

When a refactor's value is the API delta, two short Before/After code blocks at the call-site level are the most legible artifact a reviewer can have.

```go
// Before
sjSvc.RegisterKindForDispatch(KindFoo, FooOptions(2)...)
fooDispatcher := NewFooDispatcher(sjSvc)
```

```go
// After
fooDispatcher := FooJob.Bind(sjSvc)
```

- DO show one or two representative call sites, not the full type-signature surface
- DO cut boilerplate, unrelated setup, untouched members
- DO use `// Before` and `// After` headers without further commentary
- DO NOT exceed ~15 lines per side

### Areas touched

For cross-cutting refactors. Names *scope of impact* — subsystems affected, where conflicts with in-flight work are likely, where to watch for regression.

- DO use when a teammate couldn't predict where this PR collides with theirs without opening the diff
- DO NOT use for single-package PRs
- DO NOT substitute file counts or full file lists for scope summaries

```
## Areas touched

- `pkg/foo/*` — internal API reshape; no behaviour change.
- All composition roots (api, worker, periodic-runner) — call-site updates.
- `pkg/{bar,baz}/dispatch.go` — new descriptors; old wrappers removed.
```

### How to test

Concrete reproduction steps for the reviewer. Goes at the bottom of the body.

- DO write PR-specific steps with specific commands, buttons, or user actions
- DO NOT use checkboxes
- DO NOT include if every step is a generic CI command (`task test`, `go vet`)
- DO NOT list unit tests as a 'how to test' instruction

```
## How to test

1. Start the API server locally with `task dev`.
2. In another terminal, find the API process: `pgrep -f 'alcova server'`.
3. Send `kill -TERM <pid>` and watch the logs — expect "graceful shutdown: draining" followed by a clean exit within ~8s.
4. Repeat with `kill -INT <pid>` — expect "fast shutdown: dropping in-flight connections" and immediate exit.
```

### External references

Linear tickets, related PR numbers, parent or stacked PRs.

- DO always include when external references exist
- DO use full URLs for systems GitHub doesn't auto-link (Linear, Jira, Notion, Sentry, Google Docs, dashboards)
- DO use plain `#1234` or `@username` for same-repo GitHub references — they auto-link
- DO use `owner/repo#123` for cross-repo references
- DO ask the user when you don't know the workspace slug or URL shape for a ticket
- DO NOT include bare unclickable IDs ("Linear: AI-1234")

```
Linear: [AI-1234](https://linear.app/<workspace>/issue/AI-1234)
Follow-up: #1235
```

### Stack

When the PR is part of an enforced merge-order stack.

- DO name the PR this one is stacked on and any sequencing dependencies
- DO NOT include for unrelated PR pairings

```
Stacked on #N. Merges after the lease-table migration in #N is applied to all environments.
```

### Differences from previous PRs

When re-baselining an earlier sibling PR that was closed or superseded.

- DO summarise what's changed between the previous attempt and this one
- DO NOT include for fresh PRs without precedent

### Also in this PR

For secondary changes included in the PR such as dead code cleanup, a tooling fix or small refactor to unblock the main objective etc. include it in an 'also in this PR' section.

- DO use one bullet per item, naming the behavioural or API consequence
- DO use this heading verbatim
- DO NOT include docs updates or renames. These can be easily read from the diff.

### Design

Link to a spec when one exists. Not a re-summary.

- DO link to the design spec a reviewer would consult
- DO include multiple distinct artifacts as a short list
- DO NOT link to author-facing implementation plans or task-tracking docs

```
## Design

[docs/specs/2026-04-17-dev-entrypoint-design.md](docs/specs/2026-04-17-dev-entrypoint-design.md)
```

### Background

For context the commits don't carry. Only include when the PR's motivation or constraints aren't legible from the PR scope alone.

- DO use when the why isn't obvious from the change
- DO NOT use as filler for "thoroughness"

### Deployability

For rollout dependencies, migration ordering, or merge gates.

- DO use when the PR's safety depends on external state (a migration applied, a feature flag flipped)
- DO NOT use for self-contained PRs

## Human overview sections

You may be working on a PR alongside a human or on their behalf. They may add, or instruct you to add their own content to the PR.

- DO preserve any 'human overview', 'human notes', or other similarly marked sections or content.
- DO NOT write your own 'human overview'. Human overview means written by humans for humans.
- DO preserve any uploaded screenshots or clips
- DO preserve content inserted by other agents or tools, these will be specially marked with html comments or other delineations
- DO write a human section ONLY WHEN a human directs you to, and preserve their input text verbatim.
- DO NOT make any modification, fix, paraphrasing, or adjustment to human written content even if it appears to be wrong

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
- **Editing a PR body that changes what the PR is about** — update the title to match in the same edit. Scope drift, a new headline, or fundamentally different framing all qualify.
- **Editing a PR body that only refines presentation** — leave the title alone.
- **The title fails the self-test on its own merits** — surface a recommended rewrite as `current → proposed`. Don't change autonomously.
- **The user explicitly asked for a title rewrite** — proceed.

## Procedure

Follow this procedure when drafting or revising a PR body.

### 1. Read & orient

There may be changes in the PR you don't know about. The absolute source of truth for the **net changes** of the PR is the branch's commits and diff, not your own session memory. Read the PR and orient yourself to the changes. You can only skip this if you were the exclusive creator and contributor of the branch.

1. Read `git diff <base>...HEAD`.
2. Read the commit subjects and bodies to understand the changes over time. Keep in mind this is for your understanding of the net change, but you MUST NOT include intermediate states and changes in the history in your final text.
3. When revising, read the existing PR body.

- DO NOT draft exclusively from session memory or partial recollection.

### 2. Audit (revising only)

The existing body is one input, not a baseline to preserve.

1. State the PR's scope from the diff before reading the existing body.
2. Note where the existing body fails this skill: shape, signposting, animation, padding, content that doesn't belong.
3. Identify observations the existing body carries that the diff doesn't (constraints the author flagged, subtleties they identified). Carry them forward only if they pass the body-inclusion rules in Body & common sections.

- DO NOT preserve prose from the existing body simply because it's there.
- DO NOT restructure or polish in place; rewrite from the diff.
- DO NOT modify a `## Human overview` section (see Human overview sections).

### 3. Frame

1. State the change in one sentence.
2. Identify whether the change is functional or non-functional.
3. Pick the body shape: use **Lede** as the default; use **Problem/Change** if the work is a bug fix that benefits from framing the problem before the change.

- DO NOT draft until the one-sentence scope holds. If a changed file doesn't fit the sentence, the sentence is wrong or the PR has stray scope.

### 4. Draft

1. Write the body and title together from the one-sentence scope.
2. Compose sections from the Body & common sections catalogue, or author your own when none fit.
3. Right-size to the diff.

- DO NOT pad content to fill a sense of "completeness".

### 5. Self-review

Apply each check before posting.

1. Check the body against the HARD RESTRICTIONs (signposting, animation, padding).
2. Check each section against the body-inclusion rules in Body & common sections. Cut sections that don't pass.
3. Check the title against the PR titles self-test. Update or surface a rewrite if it fails.
4. Verify a reviewer with no context grasps the change and motivation within 30 seconds.
5. Check each section: would a reviewer skip it without losing the PR? If yes, cut it.
6. Check the body against the Red flags table. Cut anything that hits.

### 6. Post

1. Use `gh pr create` for a fresh PR, or `gh pr edit --body` for a revision.
2. Apply the PR titles protocol.

## Red flags — STOP

| Thought | Reality |
|---|---|
| "Let me start with `## Summary`" + bullets of changed files | Diff inventory. Use a prose lede or `## Problem` / `## Change`. |
| "There's a clear before/after, so this is Problem/Change" | Before/after isn't sufficient. Problem/Change is for `fix:` work. For `feat:` / `improve:` / `refactor:`, use a regular Lede. |
| "The prior state had this undesirable property, so it was actually broken, so Problem/Change applies" | Almost any prior state has some undesirable property; that doesn't make it a bug. The criterion is the work's motivation, not retrospective judgement. |
| "I'll narrate this UX feature in implementation terms — `multipart S3 uploads`, `chunked transfer`, `retry-with-backoff handler`" | Functional PRs read in user-visible language. See Functional vs non-functional changes. |
| "Three failure modes followed: …" / "A few issues remain: …" / "Three new endpoints: …" / "The migration steps: …" / "The flow is two-legged: …" | List preamble doing no work. Drop it; the bullets stand alone. |
| "Two changes together change that. First, … Second, …" / "Three things follow from that. First, … Second, … Third, …" | List preamble in prose form. The count announces upcoming paragraphs. Cut the bridge sentence. |
| "The hook is the third writer to the threads cache (after X and Y)" / "This is the second consumer of the registry" | Positional descriptor announcing a sequence position the reader didn't ask for. Drop the count. |
| "Go compilation moves into the Dockerfile" / "The binary stops carrying environment information at link time" | Animation verb personifying a code construct. Recast the construct as the object of the change. |
| "The user asked me to revise — I'll keep most of the original and restructure / polish" | Don't preserve existing prose simply because it's there. Re-derive from the diff. See Procedure stage 2. |
| "The lede is fine, it's only four sentences" | Count beats, not sentences. Multiple beats → heading split. |
| "I've said this once, but let me reframe it from the deletion angle / call-site angle / historical angle" | One beat, three times, is still one beat. Pick the most informative angle. |
| "Let me narrate which files changed and what changed in each" | The diff has it. Name a file path only when the reviewer needs to find something the diff doesn't surface. |
| "It's a 24-line PR but the lede is a 100-word sentence threading five things" | Right-size to the diff. |
| "Just / really / basically / essentially / clearly / it's worth noting that …" | Padding. Cut. |
| "## What's no longer public" / "## What was removed" + identifier list | Diff inventory dressed as a section. Promote any non-obvious removal into a sentence under `## Change`. |
| "Net diff: 53 files, 1081 insertions, 1021 deletions" | Recoverable from the PR header. Use Areas touched if collision risk matters. |
| "## Also in this PR — Docs: new CLAUDE.md walks through …" | Docs and renames are present in the diff. Reserve Also in this PR for behavioural or API consequences. |
| "Linking the implementation plan / task-tracking doc the author worked from" | Implementation plans are author-facing. Link the spec, not the to-do list. |
| "I'll add a Test plan checkbox list" | Use How to test instead. No checkboxes. Drop entirely if every step is a generic CI command. |
| "I should add a Background section to be thorough" | Only if it carries info the commits don't. |
| "I'll restate the title in the first sentence" | Cut. The reader has the title. |
| "Let me name the types and packages I touched" | Plain language for functional PRs; identifiers and file paths belong in non-functional PRs where they're the subject. |
| "I'll add the 🤖 attribution" | Don't. |
| "Linear: AI-1234" / "Sentry: ABC-42" / "Doc: Architecture overview" — bare ID or label without a URL | Unclickable reference is dead weight. Use full URLs for systems GitHub doesn't auto-link. |
| "I'll add a `## Human overview` section to frame the change" | That heading is a provenance claim about the human. Put framing in the lede. |
| "The existing human overview reads a bit rough — let me tighten it" | Leave it byte-for-byte. |
| "This needs more structure to feel complete" | A short prose body is complete for a small PR. |
| "Plain prose only, no headings" | Overcorrection. Use structure that anchors the reader (Problem/Change, parallel bullets). |
| "Let me describe how the approach evolved" | Net diff, not session. |
| "I'll start writing once I've read the recent commits" | Read the full diff against base first. |
| "The title's a bit off but I'll just rewrite it while I'm here" | If the body edit changes what the PR is about, update the title in the same edit. Otherwise surface a `current → proposed` proposal. See PR titles Protocol. |

**Violating the letter of these rules is violating the spirit of them.**
