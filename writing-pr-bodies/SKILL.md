---
name: writing-pr-bodies
description: >
  Rules and guidelines for writing easily readable and accurate PR titles and 
  descriptions. TRIGGER before any `gh pr create`, `gh pr edit --body`, 
  `gs branch submit`, `git-spice branch submit`, or any other command that opens
  or updates a pull request body, including autonomous PR creation where the
  user didn't specifically give direction about the PR body or the PR itself.
  SKIP for non-body PR operations (e.g. `gh pr ready`, `gh pr merge`, label
  or reviewer changes) and for commit messages.
---

# Writing PR Bodies

These rules and guidelines are to be followed when writing PRs, titles, and bodies.

## Audience

The primary reader is a senior software engineer with a focus on productivity, accuracy, and precision. Software engineers working with coding agents today process hundreds of PRs built by themselves, their coworkers, and AI agents. They suffer from constant context switching and mental overload. They need clear oversight and need to grep changes in a glance so they can make a quick judgements. The engineer that reads your writing probably has 13 pull requests open in their browser right now, so poor writing and communication costs them time and money.

## Core requirements

A reviewer landing on your PR needs to be able to read, scan, or skim to grep the changes in ten seconds. The title and the PR body are crucial. They can see the detail in the diff and commit log, but that could be dozens of commits and tens of thousands of lines. Your writing must be optimised for **cold-read scannability**, it should be *salient*, *didactic*, and *accessible* to read quickly.

You must communicate *the net change* of the PR and its motivation or justification.

On a large change the body has a second job: helping the reviewer *perform* the review, not only grasp the net change. A diff spanning dozens of files is a wall of code. The body can map the change's structural shape so the reviewer can judge whether the new architecture is well-placed. Conditional on size; see *Shape*.

- DO state the change and its motivation immediately in the first paragraph, sentence, or heading
- DO explain the design and its trade-offs
- DO explain how design decisions are justified
- DO explain the before/after state for behavioural changes or fixes
- DO point out flow-on effects
- DO list out side-effects or incidental changes that made it into the branch
- DO use headings, paragraphs, and lists to make the content easily scannable
- DO NOT repeat the diff, the reader has access to the "files changed" tab
- DO NOT list out files UNLESS they are the crucial subject of the change
- DO NOT recap routine lockfile or generated-file changes (`pnpm-lock.yaml`, `package-lock.json`, `go.sum`, regenerated clients, snapshot updates). They follow mechanically from the real change and are visible in the diff
- DO NOT narrate changes over the lifecycle of the branch. A PR is merged atomically and intermediate states never get deployed
- DO amend or correct the PR to ensure it matches the final net changes after a pivot or deviation from the original intent or design
- DO NOT write out 'test checklists'. Tests MUST be done in the code, CI workflows, and manually before marking the PR ready so there is no use tracking them in the PR body.
- DO NOT use a "summary" title. The PR body **IS** the summary of the changes in the PR

## Functional vs non-functional changes

Any change to a codebase is either functional or non-functional. You'll already understand this concept, it's the same as deciding between "feat" "fix" "improvement" vs "chore" "docs" "refactor" style commits.

In a PR for a functional change, that functional change is the main subject.

- DO use when the party impacted by the change is the end user
- PRIORITISE the change in behaviour of the system over code level changes
- DO frame the change in terms of user visible behaviour
- DO contrast past and new behaviour when the change is subtle or occurs under specific conditions or edge cases
- DEPRIORITISE changes and subtleties in the code or components

A non-functional change usually changes code organisation, architecture, or tooling. In this case changes and subtleties in the code or components is the main subject.

- DO use when the party impacted by the change is the system or the developers maintaining the system.
- DO describe the transition and code level changes at an appropriate level of detail
- DO use code-level language, identifier names, file paths, and structural terms
- DO NOT characterise components as actors performing the change ("Code generation moves to the pre-build stage")
- DO use a named subject when describing post-change behaviour ("Code generation now runs after dependency install")
- DO call out flow-on effects that might affect functionality and end users

Classify the PR as functional or non-functional. Stay in that register through the lede. A PR that touches both kinds of work still gets one classification; pick the one that names what the change *is*. Don't interleave registers in the lede.

The same animation change in two registers:

> **Non-functional register (wrong for a functional PR):** Renders the threads list as a single `AnimatePresence` with section headers and rows as direct siblings. Each row keyed by session id stays mounted across the Inbox / Recents partition, so when `unread` flips the same `motion.div` slides between sections instead of unmounting.

> **Functional register (right for a functional PR):** When a thread flips between Inbox and Recent, the row slides between sections rather than disappearing and reappearing. Titles animate into their new position.

The non-functional paragraph describes DOM lifecycle, library choice, keying. The functional paragraph describes the change as users experience it. In a functional PR, the second belongs in the lede.

Before moving non-functional prose out of the lede into its own section, run two checks:

1. Is this implementation detail, or a non-obvious design decision the reviewer needs? Implementation detail doesn't belong in the lede regardless.
2. Would a reviewer be surprised to learn this is how it was implemented if it weren't flagged? If not, cut it entirely. A section earns its place only when the design choice it describes is non-obvious from the diff.

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
- DO right-size detail to the diff. State what the reader needs to act on or be aware of; trust the code for the line-by-line detail.
- DO NOT include verbatim code chunks in the description
- DO include illustrative and abridged code chunks when the subject matter is code architecture, refactors, interfaces, or APIs

**It's not an essay**.

- DO NOT signpost upcoming content or structure
- DO NOT describe the structure of the PRs body's own prose
- DO NOT use formal, persuasive, or marketing-style language
- DO NOT reach for marketing or corporate register ("comprehensive", "seamless")
- DO NOT express unsolicited opinions
- DO NOT "sell"

**Only use bullets for genuine lists**

- DO use bullets when items are parallel, when you are **listing out** items of a repeating structure or topic matter. 
- DO NOT use bullet lists to mask unrelated content as "list items"
- DO NOT add useless bullet list lead-ins. eg. "Two changes:" "The flow is two-legged"
- DO NOT put large paragraphs in bullet lists.
- DO NOT use bullet lists to "inventory" the changes or the diff

**The PR is the implicit subject**

Like standard commit messages, default to **subjectless present active** voice. eg. ~~This PR~~ "Factors out a shared helper".

- DO lead with the action the PR performs on the codebase ("Adds X", "Moves Y", "Switches A to B")
- DO NOT lead with the action the feature performs when invoked ("Pins a conversation to the top of the inbox"); recast that behaviour as the object of the PR's action ("Adds conversation pinning")
- DO NOT default to "X is excluded", "Y was added", "Z has been moved" when the PR is the obvious actor
- DO name a subject when it carries information ("Source files now key the build cache", "Each file shows its own progress bar")
- DO use passive only when the actor is genuinely unimportant or awkward to name
- DO NOT animate code constructs as actors performing the change

The same feature lede with the wrong subject and with the PR as the subject:

> **Wrong (the feature is the implicit subject):** Pins a conversation to the top of the inbox. A user marks a thread and it stays above unread items until they unpin it.

> **Right (the PR is the implicit subject):** Adds conversation pinning. A user marks a thread and it stays above unread items until they unpin it.

`Pins` is what the feature does when a user invokes it, not what the PR does. Subjectless present active makes the PR the subject, so the wrong lede is either false (the PR pins nothing) or silently swaps in the user and stops signalling a change. The right lede leads with the PR's action; the feature's behaviour follows as its object.

**It must be accessible**

Accessible writing is the key to fast, clear comprehension.

- DO use plain sentence shapes and forms
- DO use sentence fragments when they save words ("Follow-up to #1209" not "This is a follow-up to #1209")
- DO use dot points to list legitimately parallel items
- DO NOT use dot points to dump unrelated content quickly
- DO NOT use em dashes or threaded clauses even if they are more "correct" sentence forms.
- DO NOT use "technical prose". DO use technical terms for subject matter.
- DO NOT use long, winding clauses
- DO NOT use verbs to evoke literary animation
- DO NOT waste words to bridge paragraphs
- DO NOT hard-wrap prose lines mid-paragraph as you would in code comments or terminal output. Markdown wraps automatically; manual wraps can break list continuations and render awkwardly in the GitHub UI

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
| "the load-bearing decision is X" / "the key decision here is X" | how much weight X carries |
| "Notably, …" / "In particular, …" / "As mentioned, …" | the prose's weighting or backward-reference |
| "At the same time, On the other hand, That said" (when nothing contrasts) | a relationship between sentences that doesn't exist |
| "Let me explain how this works" / "Let's walk through" | the next sentence |
| "## Summary" + bullets of changed files | the document's own inventory |

These patterns waste words describing the text itself and not the PR.

- DO NOT write these problematic patterns
- DO delete or rephrase them out of the text
- DO NOT count prose
- DO preserve counts when counting actual code shape. Example: "There are four affected CatalogService RPCs (list / create / update / delete)"

### HARD RESTRICTION: DO NOT CHARACTERISE OR ANIMATE THE CHANGE

RECOGNISE these literary characterisation and animation patterns.

| REJECT | PREFER | WHY |
|---|---|---|
| "Go compilation moves into the Dockerfile" | "Moves Go compilation into the Dockerfile" | "Go compilation" is being characterised as the actor. Recast with the PR as the implicit subject and the construct as the object. |
| "Two additional fixes fell out of this change" | "Includes two additional fixes" | "fell out" is used as literary animation, this is hard to grep. Be explicit. |
| "The previous attempt at fixing this defeated keyed cache reuse" | "A previous attempt broke keyed cache reuse" | "defeated" is literary animation. Be explicit. |

These patterns dilute the information and require readers to process through layers of indirection.

- DO NOT write these problematic patterns
- DO delete or rephrase them out of the text
- DO NOT describe the change as a narrative
- DO downlevel to plain, accessible language

### HARD RESTRICTION: DO NOT PAD WORDS THAT CARRY NO INFORMATION

RECOGNISE these common padding patterns.

| Pattern | What it's doing |
|---|---|
| "just, simply, really, actually" | hedge or filler |
| "basically, essentially, fundamentally" | hedge or vague emphasis |
| "quite, rather, somewhat, fairly, particularly" | weak intensifier |
| "clearly, obviously" (when not announcing emphasis) | empty intensifier |
| "This change does X" / "This PR adds Y" | redundant self-reference. Drop the subject ("Adds Y"). |

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
- The structural shape of a change too large to review as a unit (see *Shape*)

DON'T INCLUDE CONTENT THAT:

- Lists files that changed
- Restates trivialities of a refactor, rename or move
- Says "Adds tests for X"
- Restates the lede in different words

NEVER write a `## SUMMARY` section. The PR body **is** the summary.

### Lede

The untitled opening of the body.

Its **first sentence** is the headline change written as "Adds X", "Moves Y", "Switches A to B": what the PR does to the code, not what the feature does when someone uses it (see *The PR is the implicit subject*).

Everything after it, up to the first heading, is **elaboration**: the consequence, the before/after, or a non-obvious effect of that change, phrased naturally (the feature, the user, or the affected code as the subject).

Right-size to the PR. A small diff is one sentence with no elaboration. A complex change gets a few sentences or a short second paragraph.

- DO put the change in the first sentence, as what the PR does
- DO let the elaboration follow as a consequence of that sentence
- DO use the prior state only as a comparison point, when it clarifies
- DO right-size to the PR
- DO NOT bury the change behind preamble or context
- DO NOT open a second headline change in the elaboration, or inventory the diff there

> Adds upload progress indicators to the attachment picker. Instead of a single spinner that hides everything in flight, each file shows its own progress bar and a cancel button. Failed uploads stay in the picker with a retry option rather than disappearing silently.

First sentence: the change, with the PR as the subject. The rest: what the reader now sees, with the feature as the subject. One paragraph, right-sized.

### Problem / Change

A heading-pair structure that supplements or replaces the lede when a bug fix benefits from framing the problem before the change. Two headings, `## Problem` and `## Change`, make the contrast between what was wrong and what the PR does legible at a glance.

Heading pairs can be `## Problem` / `## Change`, `## Issue` / `## Fix`, or any pair that fits.

- DO use for genuine bugs or faults closed by this PR
- DO use when the problem requires at least a paragraph to explain
- DO NOT use when "Fixes an issue where xyz..." as a lede would suffice
- DO NOT use for improvements, refactors, or feature additions. They aren't bug fixes even if the prior state was undesirable

> ## Problem
>
> The include resolver fetches each `asset://<id>/v<N>` reference at the *pinned* version on every render. When a user edits the source between renders, the page silently keeps showing stale content.
>
> ## Change
>
> A new pass in the same resolver walks the in-page references, asks the asset store what's current, and adds a short note listing the changed paths. The renderer decides whether to refetch; the note is informational, not a directive.

### Before/After code blocks

When a refactor's value is the API delta, two short Before/After code blocks at the call-site level are the most legible artifact a reviewer can have.

```go
// Before
queue.RegisterHandler(TaskEmail, HandlerOptions(2)...)
emailWorker := NewEmailWorker(queue)
```

```go
// After
emailWorker := EmailTask.Bind(queue)
```

- DO show one or two representative call sites, not the full type-signature surface
- DO cut boilerplate, unrelated setup, untouched members
- DO use `// Before` and `// After` headers without further commentary
- DO NOT exceed ~15 lines per side

### How to test

Concrete reproduction steps for the reviewer. Goes at the bottom of the body.

- DO write PR-specific steps with specific commands, buttons, or user actions
- DO NOT use checkboxes
- DO NOT include if every step is a generic CI command (`task test`, `go vet`)
- DO NOT list unit tests as a 'how to test' instruction

```
## How to test

1. Start the API server locally with `task dev`.
2. In another terminal, find the API process: `pgrep -f 'myapp server'`.
3. Send `kill -TERM <pid>` and watch the logs. Expect "graceful shutdown: draining" followed by a clean exit within ~8s.
4. Repeat with `kill -INT <pid>`. Expect "fast shutdown: dropping in-flight connections" and immediate exit.
```

### External references

Linear tickets, related PR numbers, parent or stacked PRs. Write them as a Markdown list. GitHub unfurls an issue, PR, or discussion reference to its title and live state **only when the reference is a list item**; the same reference inline renders as a bare `#1235` with no title. The bulleted form is what makes these scannable at a glance.

- DO always include when external references exist
- DO write the references as a bulleted list, one reference per line
- DO use a bare `#1235` or `owner/repo#1413` list item for GitHub PRs and issues (it unfurls to title + open/merged/closed state)
- DO use full URLs for systems GitHub doesn't unfurl (Linear, Jira, Notion, Sentry, Google Docs, dashboards)
- DO put the ticket title in the link text for non-GitHub references, since they never unfurl
- DO use `@username` for a GitHub user
- DO include the design spec or doc a reviewer would consult, if one exists
- DO NOT link author-facing implementation plans or task-tracking docs
- DO ask the user when you don't know the workspace slug, URL shape, or ticket title
- DO NOT use inline references here (`Follow-up: #1235`). Inline never unfurls, so it stays a bare number with no title or state
- DO NOT include bare unclickable IDs ("Linear: AI-1234")

```
- Closes [AI-1297 Add upload progress to the attachment picker](https://linear.app/<workspace>/issue/AI-1297)
- #1235
- owner/repo#1413
- Design: [docs/specs/2026-04-17-dev-entrypoint-design.md](docs/specs/2026-04-17-dev-entrypoint-design.md)
```

### Linear ticket trigger words

Linear's GitHub integration scans PR titles, descriptions, commit messages, and branch names for keywords paired with a ticket ID (e.g. `AI-1234`). The keyword you pick determines what Linear does to the ticket on merge.

**Closing keywords** move the ticket to "In Progress" on branch push and "Done" when the PR merges to the default branch:

- `close`, `closes`, `closed`, `closing`
- `fix`, `fixes`, `fixed`, `fixing`
- `resolve`, `resolves`, `resolved`, `resolving`
- `complete`, `completes`, `completed`, `completing`
- `implements`, `implemented`, `implementing`

**Non-closing keywords** link the PR to the ticket without changing its state:

- `ref`, `refs`, `references`
- `part of`
- `related to`
- `contributes to`
- `toward`, `towards`

Pick the keyword based on the PR's relationship to the ticket.

- DO use a closing keyword when the PR fully addresses the ticket and the ticket should close on merge (`Closes AI-1234`, `Fixes AI-1234`, `Resolves AI-1234`)
- DO use a non-closing keyword for a partial implementation, a follow-up, or an incidental relationship (`Part of AI-1234`, `Refs AI-1234`)
- DO prefix the Linear list item in External references with the keyword so the trigger and the reference stay in one place (`- Closes [AI-1297 …](url)`)
- DO list multiple tickets after one keyword with commas (`Fixes AI-123, AI-256`)
- DO NOT use a closing keyword on a PR that only addresses part of a ticket. The ticket will close prematurely
- DO NOT separate the keyword from the ID. Linear binds them only when adjacent. Write `Closes AI-1234`, not `Closes the ticket AI-1234`
- DO NOT invent keywords (`addresses`, `tackles`, `handles`). Linear only recognises the keywords listed above

### Stack

When the PR's branch is stacked on another branch in the same repo: branched off that branch instead of the base, so its diff includes the parent's commits and git ancestry enforces the merge order. The git-spice / Graphite / ghstack case.

- DO name the parent PR this branch is stacked on
- DO NOT use for an independent branch that merely depends on another PR landing. Cross-repo dependencies are always that case, never a stack. Use Dependency.

```
Stacked on #N.
```

### Dependency

When the PR's branch is independent (branched off the base, shares no git history with the other PR) but cannot merge or deploy until another PR lands. Common across repos: a regenerated client depends on a proto or schema a backend PR ships.

- DO name the PR this one depends on and what the dependency is
- DO state the merge-order or deploy-order constraint
- DO use the cross-repo `owner/repo#N` form and carry the same link in External references
- DO lead the body with a Deployability `> [!WARNING]` when merging before the dependency lands breaks production
- DO NOT call this a stack or write "stacked on"

```
Depends on owner/repo#N, which ships the proto the regenerated client here builds against. Merges after #N lands on the base branch.
```

### Differences from previous PRs

When re-baselining an earlier sibling PR that was closed or superseded.

- DO summarise what's changed between the previous attempt and this one
- DO NOT include for fresh PRs without precedent

### Also in this PR

For secondary changes included in the PR such as dead code cleanup, a tooling fix or small refactor to unblock the main objective etc. Include it in an 'also in this PR' section.

- DO use one bullet per item, naming the behavioural or API consequence
- DO use this heading verbatim
- DO NOT include docs updates or renames. These can be easily read from the diff.
- DO NOT include lockfile bumps or regenerated/generated-file churn. They follow mechanically from the real change

### Design / Key design decisions

The non-obvious decisions a reviewer needs and the diff doesn't show. Title it `## Design`, `## Key design decisions`, or whatever fits the PR. The design spec itself goes in External references, not here.

Prefer one sentence in the lede elaboration. Promote to this section only when several decisions each pass the gate.

A bullet qualifies only if **another option existed** and the choice shapes the rest of the design. Same gate as moving prose out of the lede (see *Functional vs non-functional changes*): would a reviewer be surprised to learn it was done this way if it weren't flagged? If not, cut it; it's the diff.

Shape each bullet as the decision, a colon, then why this option over the alternative. One line. No paragraphs. No weighting labels in the text ("the key decision is", "load-bearing"); the heading already says these are the key decisions.

The same decisions as one prose paragraph, then as bullets:

> **Wall (reject):** An upload is carried on the existing multipart envelope, the same one inline attachments use, with no re-encode; a resumable upload reuses the `tus` endpoint with a `?partial` marker so resumable and one-shot parts stay distinguishable through the shared parser, the part round-trips through the gateway's buffer-and-forward path, and a per-request middleware modelled on the auth rewrite replaces every upload part with one header block while the auth rewrite skips `?partial` parts so the two middlewares own disjoint slices of the request.

> **Bullets (accept):**
> - Uploads are included in the existing multipart envelope, not a new endpoint: the gateway already buffers and forwards it, so the hot path is unchanged
> - Resumable vs one-shot split by a `?partial` marker on the existing endpoint, not a second one: one parser still handles both

The wall mixes the two decisions with mechanism the diff already shows; the bullets keep only the decisions.

### Shape

A map of the architecture a large change introduces: each new component, where it sits in the codebase, and how it relates to existing structure. Title it `## Shape`, `## Structure`, or whatever fits. It primes a reviewer to judge whether the new architecture is well-placed, not to locate files.

Gate it on diff size, the way Design gates on non-obvious decisions: include it only when the diff is too large to review as a unit. Below that, the diff is its own map and the section is padding.

Each entry names a new architectural piece: what it is, where it lives, and how it relates to what is already there. Structure alone is a table of contents; what the code does internally is diff narration.

Distinct from Design: Design is one decision where another option existed; Shape is the overall composition. A large PR can warrant both.

- DO include only when the diff is too large to review as a unit
- DO name each new architectural piece: what it is, where it lives, its role
- DO say how a new piece relates to existing structure: what it reuses, extends, or sits behind
- DO name the responsibility boundaries the change draws or crosses
- DO flag the piece whose placement most warrants scrutiny
- DO weight entries by architectural significance, not code volume
- DO NOT describe what a component does step by step; that is the diff
- DO NOT enumerate every changed file; name the new structure, not the diff
- DO NOT let the section grow with the diff; it grows with new architecture, which stays small
- DO NOT argue the change is good; give the reviewer what they need to judge it

The same large change as a component inventory, then as a shape:

> **Inventory (reject):**
> - `pkg/domains/foo/`: new domain service. `Service.Create` looks up the parent folder, loads its state, makes a model call, normalises the result, then applies edits transactionally.
> - `foo_create` tool: validates the input, calls `Service.Create`, maps the returned error.
> - `foo-usage.md`: a Markdown doc; teaches path conventions, per-scope section rules, and the parallel-read rule.
> - Filestore: adds `ModuleFoo`, an `org_subject_id` column, a trigger branch, two provisioning hooks, and a benchmark fixture update.

> **Shape (accept):**
> - `pkg/domains/foo/`: a new domain package, the home for `foo` write logic. Sits alongside the existing domain packages, behind a service interface.
> - `foo_create`: a new tool in the agent tool layer. A thin wrapper over the domain package; holds no logic of its own.
> - `foo-usage.md`: a new schema doc, embedded in the agent's prompt stack.
> - Filestore: a new `ModuleFoo` and an `org_subject_id` column, reusing the existing node and permission machinery rather than a parallel store. The permission wiring is worth the closest look.

The inventory narrates what each piece does internally and enumerates its diff. The shape says what each piece is, where it sits, and how it relates to existing structure, so a reviewer can judge whether the change is built in the right shape.

### Background

For context the commits don't carry. Only include when the PR's motivation or constraints aren't legible from the PR scope alone.

- DO use when the why isn't obvious from the change
- DO NOT use as filler for "thoroughness"

### Deployability

For rollout dependencies, migration ordering, or merge gates.

- DO use when the PR's safety depends on external state (a migration applied, a feature flag flipped)
- DO NOT use for self-contained PRs

When merging or deploying this PR before another change lands breaks production, lead the body with a GitHub alert, placed above the lede so the blocker is seen before a reviewer reaches the merge button:

```
> [!WARNING]
> Do not merge before owner/repo#1413 deploys. The regenerated SDK here calls a proto that PR ships; merging first breaks request handling in production.
```

- DO use `> [!WARNING]` and place it at the very top of the body, above the lede
- DO state both the blocking condition and the unblock condition (which PR must land or deploy, which migration must run)
- DO carry the gating reference as an unfurling list item in External references
- DO use only for a genuine merge or deploy gate. A reviewer who ignores it can break production
- DO NOT use it for notes, context, caveats, or risk commentary. A banner that cries wolf gets ignored
- DO remove the banner in the same PR once the blocker clears

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

- **Specific verb + object**: `Add X`, `Fix Y when Z`, `Move A out of B`, `Drop X`, `Switch X to Y`. Not `Update`, `Improve`, `Refactor stuff`.
- **Names the affected behaviour, not just the area**. "Stop unmounting markdown editor on save" beats "Markdown editor lifecycle".
- **Matches the one-sentence scope**, not broader, not narrower.
- **Stable across the PR's life**. Won't need rewriting if the implementation evolves.
- **Conventional prefix when the team uses one**: `fix(scope): …`, `feat(scope): …` per recent merged PRs.
- **Imperative-mood subject line.**

### What doesn't belong in titles

- **Phase numbers** outside an active stack (see below). Phase signal goes in the body.
- **Exhaustive scope qualifiers**, long parenthetical lists.
- **Implementation details**: type names, function names, file paths.
- **Ticket IDs**. See *Ticket IDs* below; conditional.

### Stack numbering: when it *does* belong

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
- **Team convention overrides**. Match recent merged PRs.

Decision test: *would a teammate landing on the ticket and looking for "the PR that did this" expect to find this one via title prefix?* Yes → prefix. No → body only.

### Self-test

Apply each before accepting a title:

1. Specific verb + object (not `Update`, `Improve`, `Refactor`)?
2. Names the affected behaviour, not just the component or area?
3. Matches the one-sentence scope?
4. Carries no info that belongs in the body?
5. Could a reviewer skimming 50 PRs identify this one in five seconds?

If 1, 2, 3, or 5 fail → strengthen. If 4 fails → trim.

**Borderline case**. Weak verb (`Update`, `Improve`, `Refactor`) rescued by a specific object (`Refactor X around Y`, `Update X to handle Z`): borderline pass. Don't autonomously rewrite, but surface a tighter alternative when the user is open to feedback.

### Protocol

- **Drafting a fresh PR**: write a title that passes the self-test before opening.
- **Editing a PR body that changes what the PR is about**: update the title to match in the same edit. Scope drift, a new headline, or fundamentally different framing all qualify.
- **Editing a PR body that only refines presentation**: leave the title alone.
- **The title fails the self-test on its own merits**: surface a recommended rewrite as `current → proposed`. Don't change autonomously.
- **The user explicitly asked for a title rewrite**: proceed.

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

### 4. Draft to a file

Write the body to a file before posting. Self-review must read from the file, not from composition memory.

1. Write the body and title together from the one-sentence scope.
2. Compose sections from the Body & common sections catalogue, or author your own when none fit.
3. Right-size to the diff.
4. Save the body to a file (e.g. `.claude/pr-body.md`). When revising an existing PR, first pull the current body to the file: `gh pr view <n> --json body -q .body > .claude/pr-body.md`.

- DO NOT pad content to fill a sense of "completeness".
- DO NOT skip the file step. Self-review must operate on a concrete text artifact.

### 5. Self-review

Read the draft file from top to bottom, as if seeing it for the first time. Composition memory is unreliable; the file is the source of truth for what the reviewer will see.

1. Check the body against the HARD RESTRICTIONs (signposting, animation, padding).
2. Check each section against the body-inclusion rules in Body & common sections. Cut sections that don't pass.
3. Check the title against the PR titles self-test. Update or surface a rewrite if it fails.
4. Verify a reviewer with no context grasps the change and motivation within 30 seconds.
5. Check each section: would a reviewer skip it without losing the PR? If yes, cut it.
6. Check the body against the Red flags table. Cut anything that hits.

- DO edit the file in place. Do not redraft from session memory.

### 6. Post

1. Use `gh pr create --body-file <path>` for a fresh PR, or `gh pr edit --body-file <path>` for a revision.
2. Apply the PR titles protocol.

## Red flags: STOP

| Thought | Reality |
|---|---|
| "Let me start with `## Summary`" + bullets of changed files | Diff inventory. Use a prose lede or `## Problem` / `## Change`. |
| "There's a clear before/after, so this is Problem/Change" | Before/after isn't sufficient. Problem/Change is for `fix:` work. For `feat:` / `improve:` / `refactor:`, use a regular Lede. |
| "The prior state had this undesirable property, so it was actually broken, so Problem/Change applies" | Almost any prior state has some undesirable property; that doesn't make it a bug. The criterion is the work's motivation, not retrospective judgement. |
| "Let me describe how the animation / cache / upload / handshake is implemented alongside the user-visible effect" | Register mismatch. Implementation prose doesn't belong in a functional PR's lede. Cut it if the diff carries the detail; relocate to its own section only if the design choice is non-obvious. See Functional vs non-functional changes. |
| "I'll write a Design paragraph covering the carrier, the marker, the round-trip and the middleware" / "I'll list every design choice I made" | Diff narration. A key decision is one where another option existed and the choice shapes the design. Cut the rest; the diff carries it. See Design / Key design decisions. |
| "Three failure modes followed: …" / "A few issues remain: …" / "Three new endpoints: …" / "The migration steps: …" / "The flow is two-legged: …" | List preamble doing no work. Drop it; the bullets stand alone. |
| "Two changes together change that. First, … Second, …" / "Three things follow from that. First, … Second, … Third, …" | List preamble in prose form. The count announces upcoming paragraphs. Cut the bridge sentence. |
| "The hook is the third writer to the threads cache (after X and Y)" / "This is the second consumer of the registry" | Positional descriptor announcing a sequence position the reader didn't ask for. Drop the count. |
| "Go compilation moves into the Dockerfile" / "The binary stops carrying environment information at link time" | Animation verb personifying a code construct. Recast the construct as the object of the change. |
| "I'll write '.git is excluded' / 'X has been moved' / 'Y was added'" | Passive or past-tense default when the PR is the obvious actor. Subjectless present active: "Excludes .git", "Moves X", "Adds Y". |
| "The user asked me to revise, so I'll keep most of the original and restructure / polish" | Don't preserve existing prose simply because it's there. Re-derive from the diff. See Procedure stage 2. |
| "The lede is fine, it's only four sentences" | Count beats, not sentences. Multiple beats → heading split. |
| "I've said this once, but let me reframe it from the deletion angle / call-site angle / historical angle" | One beat, three times, is still one beat. Pick the most informative angle. |
| "Let me narrate which files changed and what changed in each" | The diff has it. Name a file path only when the reviewer needs to find something the diff doesn't surface. |
| "It's a 24-line PR but the lede is a 100-word sentence threading five things" | Right-size to the diff. |
| "Just / really / basically / essentially / clearly / it's worth noting that …" | Padding. Cut. |
| "## What's no longer public" / "## What was removed" + identifier list | Diff inventory dressed as a section. Promote any non-obvious removal into a sentence under `## Change`. |
| "I'll add `## Areas touched` / `## Files changed` / `## Paths affected` listing the paths and identifiers this PR covers" | Diff TOC dressed as a section. The reviewer has the files-changed tab. If collision risk is actually actionable, name it in one prose sentence in the lede ("touches all four composition roots; merge order with #N matters"). |
| "I'll describe what each new component does" | That's the inventory. Shape says what each component is, where it sits, and how it relates to existing structure, not how it works. See Shape. |
| "I'll walk through what `Service.Create` does step by step" | That's the algorithm; the diff has it. Shape names placement and boundaries, not behaviour. |
| "Net diff: 53 files, 1081 insertions, 1021 deletions" | Recoverable from the PR header. Cut. |
| "I'll add `## Also in this PR` with 'Docs: new CLAUDE.md walks through …'" | Docs and renames are present in the diff. Reserve Also in this PR for behavioural or API consequences. |
| "Linking the implementation plan / task-tracking doc the author worked from" | Implementation plans are author-facing. Link the spec, not the to-do list. |
| "I'll add a Test plan checkbox list" | Use How to test instead. No checkboxes. Drop entirely if every step is a generic CI command. |
| "I should add a Background section to be thorough" | Only if it carries info the commits don't. |
| "I'll restate the title in the first sentence" | Cut. The reader has the title. |
| "Let me name the types and packages I touched" | Plain language for functional PRs; identifiers and file paths belong in non-functional PRs where they're the subject. |
| "I'll add the 🤖 attribution" | Don't. |
| "Linear: AI-1234" / "Sentry: ABC-42" / "Doc: Architecture overview" (bare ID or label without a URL) | Unclickable reference is dead weight. Use full URLs for systems GitHub doesn't auto-link. |
| "I'll write `Follow-up: #1235` inline, the title will show" | Inline references never unfurl. Put references in a Markdown list so GitHub expands them to title + state. |
| "`[AI-1234](url)` with the bare ID as the link text is enough" | Linear never unfurls. Put the ticket title in the link text so the reference is useful at a glance. |
| "I'll add a `> [!NOTE]` / `> [!TIP]` banner to highlight context or a caveat" | Alerts are only for merge or deploy blockers (`> [!WARNING]` in Deployability). A decorative banner trains reviewers to ignore the real ones. |
| "PR B depends on PR A landing, so B is stacked on A" / "## Stack — Stacked on cross-repo#N" | Stack means shared git ancestry in one repo (B branched off A). An independent or cross-repo ordering dependency is not a stack. Use the Dependency section and carry the link in External references. |
| "I'll add a `## Human overview` section to frame the change" | That heading is a provenance claim about the human. Put framing in the lede. |
| "The existing human overview reads a bit rough, let me tighten it" | Leave it byte-for-byte. |
| "This needs more structure to feel complete" | A short prose body is complete for a small PR. |
| "Plain prose only, no headings" | Overcorrection. Use structure that anchors the reader (Problem/Change, parallel bullets). |
| "Let me describe how the approach evolved" | Net diff, not session. |
| "I'll start writing once I've read the recent commits" | Read the full diff against base first. |
| "The title's a bit off but I'll just rewrite it while I'm here" | If the body edit changes what the PR is about, update the title in the same edit. Otherwise surface a `current → proposed` proposal. See PR titles Protocol. |

**Violating the letter of these rules is violating the spirit of them.**
