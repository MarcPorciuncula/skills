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

Before drafting, load `writing-persistent-content` and select its internal
technical profile. That profile owns the prose register and context assumptions;
this skill owns the PR body's evidence, reader model, composition, and posting
workflow.

Write for a senior engineer who knows the codebase but has not read the ticket,
branch history, diff, or implementation discussion.

A useful PR body is a standalone review brief. It gives the reader one coherent
model of the change at the level that matters for review. Select that model
before choosing sections or explaining implementation.

Optimize for a human reviewer's scan, not for preserving every fact as future
context. Put the load-bearing model in the opening, headings, diagrams, and
bullet leads. Use concise connective prose to show how those parts relate and
why they matter. Leave supporting detail in the diff or linked specification.

## Classify the primary change

Classify the PR before drafting. Diff size and implementation complexity do not
decide the classification.

| Primary change | Main subject of the body |
|---|---|
| Functional | Changed surfaces, affordances, states, and user journeys |
| Non-functional | Changed system boundaries, responsibilities, flows, developer interfaces, or operational behaviour |
| Mixed | The functional or non-functional change that explains why the PR exists |

Keep the selected register throughout the body. For a mixed PR, use the primary
register and add material from the other only when it affects behaviour, review
risk, compatibility, safety, rollout, or a meaningful product limitation.

Do not turn a functional PR into implementation narration after a user-facing
opening. A product inventory of changed surfaces and affordances is orientation;
an inventory of files, types, state objects, parsing steps, or serialization is
not.

## Reader contract

Every body must let a cold reader answer:

- What changes when this merges?
- Why does the change exist?

For a functional change, it must also let the reader answer:

- Which screens, commands, APIs, or other user-facing surfaces change?
- What can the user do on each surface?
- Which important states, transitions, or limitations affect that experience?

For a non-functional change, it must also let the reader answer:

- What are the major components, and how do control or data move between them?
- Which component owns each important responsibility or invariant?
- How does this path reuse, replace, or differ from the nearest existing path?
- What rollout, compatibility, permission, safety, or operational constraint matters?

Right-size the answer. A small, obvious change can satisfy the contract in one
or two paragraphs without headings.

## Establish the evidence

Use each source for the question it can answer:

| Question | Authority |
|---|---|
| What changes atomically? | The base-to-head diff and final commits |
| Why does it exist? | The task conversation, author brief, ticket, issue, or design discussion |
| How does it fit the system? | The diff and the relevant surrounding or sibling implementation |
| What external state affects it? | The live PR, dependencies, deployment state, and linked work |
| What must survive a revision? | The current PR body, especially human-authored or tool-delimited content |

Read enough surrounding code to understand the boundary the change establishes
or crosses. Do not infer motivation from implementation when author context
provides it. Ask the author when material motivation is absent from every
available source.

Describe the final net change, not the branch's sequence of experiments.
Intermediate commits belong only when they reveal a constraint that remains
true after merge.

## Publish in two stages

Once the repository's PR workflow authorises creation, open the PR promptly
with a concise initial body. State what changed and why. Put any genuine merge
or deploy blocker at the top. This workflow does not change the repository's
rules for whether a PR may be created or marked ready.

Do not invoke the cold-reader critic or wait for completion review before
posting the concise initial body. The repository's PR workflow owns the
transport checkpoint; this skill owns the body placed on it.

When planned implementation remains after that push, make the concise body an
explicit WIP checkpoint. Begin with `Work in progress`, state both the current
branch truth and intended endpoint, and add one `Remaining work` list only when
it helps. Do not inventory files or commits, and keep the intended final title
instead of adding a `WIP` prefix. Replace the WIP body after the last planned
code push and before readiness.

The concise body is final when the change is small and introduces no new
responsibility boundary, external system, persistence or permission model,
rollout, migration, parallel implementation, or non-obvious mechanism.

## Maintain an existing body

Use the maintenance path when the title, intended takeaway, retained facts,
primary register, and consequential constraints remain unchanged:

1. Re-read the live title, body, and head.
2. Patch only claims made stale by the code or review discussion.
3. Verify the changed claims against the diff and author context.
4. Preserve protected content, post through a file, and verify the live body.

Do not create a new reader model or invoke a critic for maintenance. Use the
final-body workflow when the revision changes the body model named above.

## Build the final body

For a substantial PR, use an isolated cold-reader critic when delegation is
available. Keep the critic blind to the implementation for its entire task. Do
not use the critic to draft the initial body or give it the PR URL, diff,
ticket, author brief, intended model, task history, repository access, or tools.
Start the critic without inherited parent turns or conversation history.

1. **Write the reader model.** Record the primary impact, one-sentence intended
   takeaway, three to five facts the reader should retain, and consequential
   constraints. Do this before writing PR prose.
2. **Draft from the model.** Write the title and body together. Use the body
   shape for the primary classification. Draft through a file so the exact
   artifact can be reviewed and posted.
3. **Run the blind read.** Give an isolated critic only the proposed title and
   body plus the complete request below. When delegation is unavailable,
   produce the same report yourself as a mechanical review artifact.
4. **Check the evidence.** The primary agent checks the reader model and body
   against the author brief, live PR, base-to-head diff, and relevant
   surrounding code. Correct unsupported claims and consequential omissions
   without restoring detail merely because it exists in the diff.
5. **Revise and recheck.** Address every failed cold-read check. Return the
   revision to the still-blind critic for a final verdict. Do not post the final
   body while it still fails.
6. **Protect concurrent work.** Re-read the live head, title, and body before
   posting. Refresh and repeat from drafting when the head changed. Stop and
   return the draft instead of overwriting a concurrently changed title or
   body.
7. **Post and verify.** Preserve human-authored or tool-delimited content, post
   the title and body, and verify the live artifact.

Use this reader-model shape:

```text
Primary impact: functional | non-functional | mixed (<primary>)
Intended takeaway: <one sentence>

Reader should retain:
- <fact 1>
- <fact 2>
- <fact 3>

Consequential constraints:
- <only when applicable>
```

Use this complete cold-read request without adding implementation context:

```text
Cold-read the proposed PR title and body using only the artifact and rubric in
this message. Do not inspect a repository, PR, ticket, diff, file, or skill. Do
not use tools.

Return:
- scan-only takeaway after reading the title, opening, headings, diagrams, and
  bullet leads without reading prose paragraphs in full;
- full-read interpretation of the net change and motivation;
- the three to five facts or relationships you retained;
- the apparent functional or non-functional register;
- blocking issues as: location, reader effect, and failed rubric check;
- duplicated ideas, diff-level details, and context-dependent terms;
- PASS or FAIL.

Rubric:
1. A scan reveals the net change, motivation, and core model.
2. A full read teaches one coherent model in one primary register.
3. Functional bodies identify changed surfaces and principal affordances;
   non-functional bodies identify flow, ownership, and consequential constraints.
4. Every section answers a distinct reviewer question without duplication.
5. Terms and claims are understandable without ticket or branch history.
6. Details visible in the diff are omitted unless they change review strategy.

Identify what is unclear, redundant, unsupported by the body, or dependent on
missing context and explain its reader effect. Do not propose a title, replacement
wording, a revised section structure, or exact edits. The author owns all
editorial decisions.
```

The primary agent owns the title and body. The critic reports and verifies; it
does not post or inspect implementation evidence. Check code against the user
requirements and accepted behaviour, not against the PR body as an acceptance
specification. When body and code differ, correct the body unless an independent
requirement shows the code is wrong.

A later code change requires another title and body check only when it
invalidates a body claim or changes the reader model. Use the maintenance path
for a factual correction that leaves the model unchanged.

## Compose the body

### Opening

Lead with the change or, for a fault, the concrete prior-state problem. Explain
why it matters or why this approach exists within the opening paragraph or two.
The title and opening should let a reviewer scanning a queue decide what context
they need next.

For a functional change, lead with externally observable behaviour. For a
non-functional change, lead with the code or system boundary being changed.
Implementation belongs in the opening only when that boundary is the subject.

Prefer subjectless present-active language when the PR is the implicit subject:
`Adds`, `Moves`, `Switches`, `Removes`, `Prevents`. Use a named subject when it
carries information: `Each upload now reports its own progress`.

Do not use a `Summary` or `What changed` heading. The opening is the summary.

### Functional body

Inventory the changed surfaces and the main affordances, states, or transitions
on each. Use parallel bullets or a compact table when several surfaces change.
Organise them as a product model or user journey, not as the order in which the
code processes data.

Add implementation architecture only when it explains an observable behaviour,
review risk, compatibility or safety property, rollout constraint, or meaningful
product limitation. Diff size is not a reason to add it.

### Non-functional body

Explain meaningful architecture at the level of components and responsibilities:

1. where input enters;
2. which components own orchestration, state, policy, or external integration;
3. how control and data move between them;
4. where output, errors, or durable state end up.

When the PR adds a sibling, replacement, or parallel path, compare it with the
nearest existing implementation. State what is shared, what differs, and why.

### Choose the information shape

| Information | Representation |
|---|---|
| Parallel screens, surfaces, or affordances | Bullets or a compact table |
| Component topology, branching flow, or state movement | Plain-text diagram |
| Temporal procedure | Numbered sequence |
| Responsibility ownership | Labels in a plain-text diagram or parallel bullets |
| Parallel guarantees, modes, conditions, or exceptions | Bullets |
| Cause, comparison, implication, or rationale | Short prose |
| Small API delta | Before/after snippet |

Use one primary representation for one model. Do not repeat the same model as a
diagram, table, prose explanation, and test plan. Prose beside a diagram or
table explains its implications instead of narrating it again. Keep one
abstraction level in each visual.

When a heading does not explain why a list, table, or diagram follows, add a
short lead-in that frames the reviewer question or relationship. Do not repeat
the heading in sentence form. A lead-in earns its place by making the material
that follows easier to interpret.

When prose asks the reader to connect three or more components or branching
states, replace it with a plain-text diagram. Use subject-specific
headings such as `Changed surfaces`, `Runtime flow`, `Permission model`,
`Compatibility`, or `Release path`. Avoid a generic `Design` section.

After a diagram, use at most one short prose paragraph to explain its
implication. A lead-in before the diagram does not count against that paragraph.
Put additional responsibilities, guarantees, or constraints into parallel
bullets or a section that answers a different reviewer question. Do not follow
a visual with a prose walkthrough of the same model.

### Include only consequential detail

Include an implementation detail only when it:

- identifies a load-bearing responsibility boundary;
- explains surprising externally visible behaviour;
- changes what a reviewer must verify;
- establishes a safety, compatibility, persistence, permission, or rollout property; or
- distinguishes the change from a plausible existing path.

Omit ordinary parsing, cloning, rendering, serialization, local state handling,
schema traversal, types, functions, and files unless they pass one of those
tests. For each named mechanism, ask what reviewer decision changes because it
is present. Remove it when there is no answer.

Put rationale beside the boundary or behaviour it explains. Mention an
alternative only when another plausible design would establish a different
ownership, runtime, compatibility, product, or operational boundary.

Replace plan-only phase, checkpoint, workstream, or initiative labels with the
concrete capability or boundary they denote. Keep a label only when it is an
established code or product term, and define it on first use. A linked
specification does not make its private vocabulary available to a cold reader.

### Release and review constraints

State rollout order, migration behaviour, version skew, permissions, safety
properties, known limitations, or unusual generated churn only when they change
how the PR can be reviewed, merged, deployed, or operated.

Use `How to test` only for PR-specific reproduction or review steps. Do not use
it to repeat the feature inventory. Routine CI commands and test inventories do
not belong in the body.

For stacks, external references, Linear triggers, dependencies, deploy blockers,
human-authored content, and detailed posting mechanics, read
[references/mechanics.md](references/mechanics.md). Load only the sections that
apply.

## Style

- Use precise domain language after introducing the concept.
- Prefer plain sentences, short paragraphs, and concrete subjects.
- Keep one idea in each paragraph.
- When several paragraphs under one heading make their relationship hard to recover, add connective wording, split a distinct reviewer question into its own section, or recast genuinely parallel facts. Paragraph count alone does not decide the structure.
- When a paragraph functions as an inventory of parallel responsibilities, guarantees, modes, conditions, or exceptions, use bullets or a diagram. Keep causal, comparative, and connective explanation in prose.
- Use bullets only for genuinely parallel items.
- Mention secondary changes only when they have a behavioural, API, review, or release consequence.
- Omit file inventories, identifier inventories, generated-file recaps, routine test lists, diff statistics, process narration, and branch history.
- Avoid marketing language, generic reassurance, literary transitions, and padding.
- Do not add AI attribution to the PR title or body.

Read [examples.md](examples.md) for positive examples of small, functional,
mixed, architectural, and compatibility-focused bodies.

## Titles

Use a specific imperative verb and object: `Add X`, `Fix Y when Z`, `Move A out
of B`, `Drop X`, `Switch X to Y`. Name the affected behaviour or boundary, not
only the area or an internal implementation detail.

The title must match the final one-sentence scope and remain useful in review
lists, search, notifications, and the squash commit. Follow established
repository conventions for prefixes, ticket IDs, and stack numbering.

Evaluate the title with the body during full drafting. Change an existing title
when another title better communicates the final scope or when the user requests
a rewrite.

## Cold-read checks

Apply these checks to the title and body together. A substantial body cannot be
posted with a failed check.

1. Scan only the title, opening, headings, diagrams, and bullet leads. State the net change, motivation, and core model without reading prose paragraphs in full. Recast the body when load-bearing facts are invisible at scan depth.
2. Read the body in full. Confirm that its sections and representations connect naturally instead of making the reader infer why one follows another. Add concise lead-ins or connective prose when the scan works but the full read feels abrupt.
3. Reconstruct the three to five facts or relationships the full body teaches. They must form one model and match the intended reader model.
4. Confirm that the body keeps the primary functional or non-functional register after the opening.
5. For a functional PR, enumerate the changed surfaces and their principal affordances from the body alone.
6. Name the distinct reviewer question answered by each section. Cut or combine a section with no distinct answer.
7. Replace terminology that depends on the ticket, specification, branch history, or implementation discussion.
8. Remove implementation details that the diff exposes without changing reviewer understanding or review strategy.
9. Consolidate any capability, flow, or boundary explained in more than one place.
10. Replace prose reconstruction of topology or branching state with a plain-text diagram.
11. Recast a diagram followed by multiple explanatory paragraphs. Keep one short implication paragraph and make additional parallel facts scannable.
12. Confirm that release, compatibility, and safety constraints are visible when they affect review or delivery.
13. Remove `How to test` when it only restates the body or routine CI.

When a body exceeds 300 words before references, run an explicit compression
check before posting. Length alone does not require a rewrite. Keep material
that answers a distinct reviewer question or supplies connective context, and
remove material that communicates the same model less directly.

| Failure pattern | Required response |
|---|---|
| Functional opening followed by implementation narration | Rebuild the body from changed surfaces and affordances |
| Many accurate details but no retained model | Recast the body around the reader-model facts |
| The same capability appears in several sections | Keep one representation and remove the repeats |
| Prose makes the reader reconstruct connected components or branching states | Replace it with a plain-text diagram |
| A diagram is followed by several paragraphs of responsibilities or guarantees | Move parallel facts into diagram labels or bullets and keep one implication paragraph |
| Several independent guarantees share one prose paragraph | Convert them to bullets, even when the paragraph is short |
| The scan works but the full read feels abrupt or fragmented | Add a concise lead-in, connect related ideas, or combine sections without hiding parallel facts in prose |
| A phase or checkpoint name only makes sense after reading a linked document | Name the concrete capability or boundary instead |
| A mechanism is named only because it appears in the diff | Remove it |
| Test steps repeat the feature inventory | Remove the section or keep only PR-specific reproduction needs |

## Red flags

| Thought | Reality |
|---|---|
| "This detail may help a later agent understand the branch" | The diff and specification preserve detail. The PR body must first work for a human reviewer. |
| "Each component deserves a paragraph because the architecture is substantial" | Encode connected responsibilities in a diagram or parallel bullets. Paragraph volume does not make the model clearer. |
| "These guarantees fit in one short paragraph" | Length is not scanability. If the reader can enumerate the facts, use bullets. |
| "Lead-ins are padding because the heading already names the topic" | A heading names the topic. Keep a concise lead-in when it explains the question, relationship, or reason for the representation that follows. |
| "The phase name is defined in the linked specification" | The body is standalone. Use the concrete scope unless the term is already established outside the specification. |

**Violating the letter of these rules is violating the spirit of them.**

Post the final body only after the blind report and evidence check pass. This
gate does not delay the concise initial body or draft PR. Verify that the live
title and body match the reviewed artifact. Do not narrate the check or report
each edit it caught in the PR body.
