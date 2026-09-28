---
name: pr-overview
description: >
  TRIGGER: Use only when the user invokes `pr-overview` by name or slash
  command, or explicitly asks for an overview of a PR or branch. SKIP: Do not
  use for a direct question about a PR, including its behaviour or
  implementation, or for correctness review, PR status, review comments, or
  implementation work unless the user also explicitly asks for an overview.
---

# PR overview

## Check applicability after loading

If the user did not explicitly ask for an overview of a PR or branch and did
not invoke `pr-overview`, ignore the rest of this skill. Answer direct questions
about a PR with the guidance applicable to the question.

Investigate the requested PR or branch and provide the overview the user asked
for. When the request includes a question or area of focus, answer it directly
and add only the context needed to understand it. When there is no focus,
explain the change as a whole.

## Assess the PR body

When a PR body exists, read it before inspecting the diff in depth. Treat it
as an attempted explanation and one source of evidence, not as the outline or
authority for your explanation. Identify what the body makes clear and what
remains unclear so the investigation can focus on those gaps.

Assess whether the body provides:

- the net change and why it exists;
- prerequisite context before relying on it;
- a coherent before-and-after model;
- the important behaviour, relationship, responsibility, or invariant;
- the actual shape of any changed contract;
- proportionate emphasis on consequential details; and
- claims that agree with the implementation.

Keep this assessment internal. Do not announce what the body explains or omits
unless the user asks about the body itself.

## Investigate the change

Use the base-to-head diff and relevant surrounding code as the authority for
what changes. Use the ticket, PR discussion, design material, and author context
for motivation and constraints. Use commits for navigation, not as the
structure of the explanation.

Read enough to explain the requested scope accurately. Follow dependencies or
adjacent paths when they establish context, ownership, compatibility, or an
invariant needed by the answer. A focused question does not require a survey of
unrelated parts of the PR.

Classify the primary change before writing:

- For a functional change, explain the affected surfaces, behaviour, states,
  transitions, and limitations.
- For a non-functional change, explain the changed contracts, responsibilities,
  boundaries, control or data flow, and operational consequences.
- For a mixed change, use the change that explains why the PR exists as the
  primary frame.

When the PR changes an interface, request or response, data schema, event,
state model, protocol, or developer contract, show the relevant before-and-after
shape. When a changed contract is the PR's primary change or the user's
question, make its declaration a primary part of the explanation. Show its
relevant before-and-after members even when this closely mirrors the diff.

Name the central changed contracts and make their fields, methods, types,
ownership, and invariants visible. Use a compact snippet, field map, table, or
diagram. Select the smallest set of contracts that exposes the net change and
omit unchanged members when that keeps the comparison clear.

A table of conceptual areas and prose summaries does not show a contract. Do
not make the reviewer reconstruct member-level changes from prose or the diff.
For every central contract named in the explanation, show its relevant
signature or members. A contract name in a diagram or paragraph does not count.
Group related declarations when several contracts form one boundary.

## Write the explanation

Lead with the answer to the user's question or the behavioural shape and reason
for the PR. Supply prerequisite context before implementation detail. Connect
the behaviour to code and architecture where that helps the reviewer understand
or navigate the change.

Choose the smallest form that communicates the model:

- prose for cause, comparison, rationale, and implications;
- bullets or a table for parallel facts and before-and-after fields;
- a plain-text diagram for topology, ownership, branching flow, or lifecycle;
- a concrete example when abstract names hide the behaviour.

Use headings only when they help the reader scan distinct questions. A small
change may need one or two paragraphs and no headings. Do not repeat one model
in several representations.

Return one self-contained explanation in chat. Do not create a report file or
append investigation logs, commit lists, diff statistics, routine test results,
PR status, or a file inventory.

## Check sufficiency before answering

Reinvestigate before answering when any applicable check fails:

- The user's question is answered directly, or the whole change has a coherent
  model when no question was supplied.
- The explanation shows what changes, why, and how the important before-and-after
  behaviour or boundary differs.
- Every consequential claim is supported by the diff, surrounding code, or
  explicit author context.
- When a contract is the primary change or question, the explanation includes
  its relevant before-and-after declaration, not only a conceptual summary.
- For every central changed contract, the reviewer can identify the relevant
  signature, members, types, ownership, or invariants without reopening the
  diff; naming the contract alone does not satisfy this check.
- The explanation contains enough context to stand alone without turning into
  a general diff recap.

When evidence remains unavailable, state the exact limitation beside the
affected claim. Do not add an `Honesty` section or recount what you read.

## Surface only consequential concerns

Surface a concern only when independent evidence reveals an urgent
contradiction, regression, or plausible bug that the PR body or other
documentation does not clearly address. Explain the evidence and consequence
directly.

Do not add a `Worth flagging` section when no such concern exists. Pending
review feedback, mundane implementation details, repeated facts, and the PR
body's explanatory gaps do not belong here.

## Input forms

Accept a PR number, PR URL, branch name, or any combination of them. Resolve a
PR to its head branch when local source inspection is needed. When only a
branch exists, explain the branch without manufacturing PR-specific context.
