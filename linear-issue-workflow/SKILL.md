---
name: linear-issue-workflow
description: >-
  Create, revise, split, consolidate, name, or discuss Linear issues. Use when
  turning product, design, investigation, or implementation work into Linear
  issues; deciding whether new detail belongs in an existing issue; or
  referring to issues in reader-facing discussion. Skip implementation work
  for an already selected issue when neither its Linear content nor the
  reader-facing discussion of issues changes.
---

# Linear Issue Workflow

Treat a Linear issue as the running record for one delivery unit. Let its
description become more concrete as discovery, design, and implementation
decisions settle.

This skill owns issue identity, decomposition, naming, evolution, and
reader-facing issue references. Product, design, and engineering guidance owns
the decisions recorded in an issue. Writing guidance, when available, owns the
quality of the prose. A handoff between those disciplines does not establish a
new issue boundary.

## Select the delivery unit

Before creating or splitting an issue:

1. Identify the product or system outcome that will exist when the work is
   complete.
2. Identify how a reviewer can accept that outcome.
3. Inspect the active issue and relevant parent, child, sibling, or related
   issues when they may already own the outcome.
4. Decide whether the new scope can be completed and accepted independently.

Use the following evidence to select the action:

| Situation | Action |
|---|---|
| The discussion adds behavior, presentation, implementation detail, or acceptance criteria to the same outcome | Update the existing issue. |
| The discussion resolves or introduces open decisions for the same outcome | Update the existing issue and keep the decisions visibly settled or open. |
| The proposed work has a separately meaningful outcome that can be completed and accepted independently | Create a separate issue. |
| The proposed work produces a named document, contract, study, or decision artifact that is itself the requested deliverable | Create a separate issue for that artifact when separate tracking is useful. |
| The discussion has not established a stable outcome and no existing issue owns it | Keep the work in the discussion or a suitable design artifact. Do not create a placeholder issue solely to hold the discussion. |

When the user explicitly chooses an issue boundary, follow it. When the
boundary remains materially ambiguous, explain the plausible actions and ask
before creating another issue. During a continuous discussion of one feature,
default to updating its existing issue.

Do not infer a separate delivery unit from any of these facts alone:

- the work moved from behavior to visual presentation;
- another skill or discipline now owns the next reasoning step;
- the specification became more detailed;
- implementation follows design;
- the work crosses frontend and backend code;
- a new title can describe the narrower discussion topic; or
- the existing issue still contains open decisions.

## Create and evolve issues

When the user requests a ticket before every detail is settled, create one
issue for the known outcome. Record unresolved details as open decisions or
implementation-readiness gates. Update that issue as decisions settle.

Keep the description as the current contract for the delivery unit:

- state the outcome and scope before supporting detail;
- distinguish settled requirements from proposals and open decisions;
- add implementation constraints and acceptance criteria when they become
  known;
- replace superseded requirements instead of preserving contradictory versions
  in the description; and
- use comments for material decision history only when that history remains
  useful to collaborators.

Do not create an issue whose only output is a more detailed version of its own
description. Use the delivery issue itself, or create a named external artifact
when producing that artifact is the actual task.

Before creating an issue, search the likely owning issue and its nearby issue
set when the current context suggests overlap. After creating, splitting, or
consolidating issues, verify the resulting titles, descriptions, statuses, and
relationships.

## Name the delivered result

Name an issue after the functionality, behavior, system change, or persisted
artifact being delivered. Make the subject and outcome recognizable without
opening the issue.

Avoid titles led by process verbs such as `Define`, `Explore`, `Decide`,
`Specify`, or `Refine` when those verbs describe the current phase of thinking
rather than the delivered result.

Use a definition-oriented title only when the work produces a named persisted
artifact with its own completion condition and downstream use. Name that
artifact in the title when practical.

Examples:

- Prefer `Show review responsibility on TaskRun cards` to `Define TaskRun card
  responsibility` when the issue delivers the card behavior.
- Use `Publish the TaskRun state-transition contract` when the requested output
  is a reviewed contract stored outside the issue.

Retitle an evolving issue when its current title no longer describes the
delivery unit. Do not preserve a phase-oriented title only because the issue
started during discovery.

## Refer to issues with recognizable titles

In reader-facing discussion and persistent prose, make every issue reference
recognizable without requiring the reader to open it.

- On the first mention in a standalone response or artifact, write the issue
  identifier followed by its full current title.
- On later mentions in the same response or artifact, write the identifier
  followed by a short, recognizable fragment of the title.
- Put the title or fragment after the identifier even when the reference is a
  link.
- Retrieve the current title before writing when it is not already established
  by reliable issue data. Do not guess it from a branch name or memory.

Use these forms:

```markdown
[AI-1420: Show review responsibility on TaskRun cards](https://linear.example/AI-1420)
[AI-1420: TaskRun responsibility](https://linear.example/AI-1420)
```

Do not write a bare identifier such as `AI-1420` in reader-facing prose after
the title can be retrieved. Machine fields, tool arguments, commands, branch
names, and source identifiers do not need the reader-facing form.

## Compose the issue text

If `writing-persistent-content` is available, use it for the issue title,
description, and comments after selecting the correct issue action. Otherwise,
write for collaborators who know the product or codebase but did not
participate in the drafting conversation. Keep the issue self-contained,
separate settled requirements from open decisions, and omit session history
that does not affect delivery.
