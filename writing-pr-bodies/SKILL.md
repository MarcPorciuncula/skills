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

Write for a senior engineer who knows the codebase but has not read the ticket, branch history, diff, or implementation discussion.

A useful PR body is a standalone review brief. Its opening makes the net change and motivation legible. When the change introduces meaningful architecture, its remaining sections explain the implementation shape, responsibility boundaries, and relationship to the existing system. A reviewer should not need to reconstruct those relationships from a list of files, identifiers, or disconnected design bullets.

## Reader contract

Every body must let a cold reader answer:

- What changes when this merges?
- Why does the change exist?

When applicable, it must also answer:

- What are the major components, and how do control or data move between them?
- Which component owns each important responsibility or invariant?
- How does this path reuse, replace, or differ from the nearest existing path?
- What rollout, compatibility, permission, safety, or operational constraint matters?

Right-size the answer. A small, obvious change can satisfy the contract in one or two paragraphs without headings. A substantial change should orient the reader before discussing individual implementation choices.

## Establish the evidence

Use each source for the question it can answer:

| Question | Authority |
|---|---|
| What changes atomically? | The base-to-head diff and final commits |
| Why does it exist? | The task conversation, author brief, ticket, issue, or design discussion |
| How does it fit the system? | The diff and the relevant surrounding or sibling implementation |
| What external state affects it? | The live PR, dependencies, deployment state, and linked work |
| What must survive a revision? | The current PR body, especially human-authored or tool-delimited content |

Read enough surrounding code to understand the boundary the change establishes or crosses. Do not infer motivation from implementation when the author context provides it. If material motivation is absent from every available source, ask the author instead of inventing it.

Describe the final net change, not the branch's sequence of experiments. Intermediate commits may explain the code to you; they do not belong in the body unless they reveal a constraint that remains true after merge.

## Publish in two stages

Once the repository's PR workflow authorises creation, open the PR promptly with a concise initial body. State what changed and why. Put any genuine merge or deploy blocker at the top. This workflow does not change the repository's rules for whether a PR may be created or marked ready.

When planned implementation remains after that push, make the concise body an explicit WIP checkpoint. Begin with `Work in progress`, state both the current branch truth and intended endpoint, and add one `Remaining work` list only when it helps. Do not inventory files or commits, and keep the intended final title instead of adding a `WIP` prefix. Replace the WIP body after the last planned code push and before readiness.

The concise body is final when the change is small and introduces no new responsibility boundary, external system, persistence or permission model, rollout, migration, parallel implementation, or non-obvious mechanism.

For a substantial PR, use an isolated drafting agent when delegation is available. Isolation gives the draft a fresh reader's perspective and reduces fixation on the implementation sequence. Dispatch it after the last planned code push, when the base-to-head change is stable enough to describe as final. The primary agent supplies context the isolated agent cannot recover from the diff:

- the problem or capability;
- the motivation and important rationale;
- the intended responsibility boundary;
- material rollout, compatibility, or release constraints;
- the PR URL, base and head branches, the current head commit, and relevant ticket or spec.

If the harness supports persistent background agents, run the isolated drafter as a non-blocking background task and continue the primary workflow. Otherwise run it synchronously before final handoff. Do not mark the body complete or mark the PR ready until the full draft is posted. An isolated drafter created by this workflow writes the body directly; it does not delegate again.

The isolated drafter must:

1. Read this skill, the author brief, the live PR, the base-to-head diff, and relevant surrounding code.
2. Draft the body from the reader contract, not by expanding the concise body section by section.
3. Re-read the live PR immediately before posting. If the head commit differs from the handoff, refresh the diff and repeat from step 2; if the body changed, stop and return the draft rather than overwrite concurrent work.
4. Run the final cold read. If the title no longer matches the scope, return the body draft and a proposed title to the primary agent instead of posting.
5. Preserve human-authored or tool-delimited content, post the body, and verify the live artifact.

The primary agent owns the title and concise initial body. It must not edit the body while the isolated drafter is active. A later code change that alters the PR's scope, architecture, or rationale requires another body update.

Use this compact handoff shape:

```text
Draft and post the full body for <PR URL> at head <commit> using the
writing-pr-bodies skill. Do not change the title.

Author brief
- Problem or capability: ...
- Motivation and rationale: ...
- Responsibility boundary: ...
- Release, compatibility, or known constraints: ...

Read the base-to-head diff and the nearest existing implementation. Treat the
brief as the authority for motivation. Confirm the live head and body before
posting, and preserve human-authored or tool-delimited content.
```

## Compose the body

### Opening

Lead with the change or, for a fault, the concrete prior-state problem. Explain why it matters or why this approach exists within the opening paragraph or two. The title and first paragraph should be enough for a reviewer scanning a queue to decide what context they need next.

For a user-visible change, lead with the externally observable behavior. For a refactor, tool, or architectural change, lead with the code or system boundary being changed. Implementation details belong in the opening only when that boundary is the subject of the PR.

Prefer subjectless present-active language when the PR is the implicit subject: `Adds`, `Moves`, `Switches`, `Removes`, `Prevents`. Use a named subject when it carries information: `Each upload now reports its own progress`.

Do not use a `Summary` or `What changed` heading. The opening is the summary.

### Implementation shape

Add architecture only when the reader contract calls for it, regardless of diff size. Explain the system at the level of components and responsibilities:

1. where input enters;
2. which components own orchestration, state, policy, or external integration;
3. how control and data move between them;
4. where output, errors, or durable state end up.

Use subject-specific headings such as `Runtime flow`, `Responsibility boundary`, `Permission model`, `Compatibility`, or `Release path`. Avoid a generic `Design` section that becomes a bucket for unrelated facts.

When three or more components interact, prefer a small flow diagram, table, or numbered sequence over prose that makes the reader reconstruct the topology. Keep one abstraction level in each visual.

Name packages, types, functions, or files only when they identify a boundary or help the reviewer find a load-bearing concept. Do not inventory implementation details that the diff already exposes.

### Relationship and rationale

When the PR adds a sibling, replacement, or parallel path, compare it with the nearest existing implementation. State what is shared, what differs, and why the difference exists. Put rationale beside the boundary or mechanism it explains instead of collecting choices as unrelated bullets.

Call out an alternative only when it clarifies a consequential decision. A decision is useful when another plausible design would establish a different ownership, runtime, compatibility, or operational boundary.

### Release and review constraints

State rollout order, migration behavior, version skew, permissions, safety properties, known limitations, or unusual generated churn only when they change how the PR can be reviewed, merged, deployed, or operated.

Use `How to test` only for PR-specific reproduction or review steps. Routine CI commands and test inventories do not belong in the body.

For stacks, external references, Linear triggers, dependencies, deploy blockers, human-authored content, and detailed posting mechanics, read [references/mechanics.md](references/mechanics.md). Load only the sections that apply.

## Style

- Use precise domain language after introducing the concept.
- Prefer plain sentences, short paragraphs, and concrete subjects.
- Use bullets only for genuinely parallel items.
- Use before/after snippets when a small API delta is clearer than prose.
- Mention secondary changes only when they have a behavioral, API, review, or release consequence.
- Omit file inventories, identifier inventories, generated-file recaps, routine test lists, diff statistics, process narration, and branch history.
- Avoid marketing language, generic reassurance, literary transitions, and padding.
- Do not add AI attribution to the PR title or body.

Read [examples.md](examples.md) for positive examples of a small body, an architectural body, and a compatibility-focused body.

## Titles

Use a specific imperative verb and object: `Add X`, `Fix Y when Z`, `Move A out of B`, `Drop X`, `Switch X to Y`. Name the affected behavior or boundary, not only the area or an internal implementation detail.

The title must match the final one-sentence scope and remain useful in review lists, search, notifications, and the squash commit. Follow established repository conventions for prefixes, ticket IDs, and stack numbering.

When revising a body, update the title in the same edit only if the PR's scope or headline changed. Otherwise leave it alone unless the user asked for a title rewrite.

## Final cold read

Before posting the full body, read the draft once as someone seeing the work for the first time. Confirm that:

1. the title and opening match the final base-to-head change;
2. the opening explains both what and why;
3. each substantial boundary, flow, or comparison is understandable without reading the ticket;
4. material release or compatibility constraints are visible;
5. every section adds orientation or review value beyond the diff.

Remove a section that only restates the title, opening, or diff. Post the revised draft, then verify that the live body matches it. Do not narrate this check or report each edit it caught.
