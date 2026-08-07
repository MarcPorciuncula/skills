---
name: coordinate-implementation
description: >-
  TRIGGER: Use when the user invokes `coordinate-implementation` or explicitly
  asks the current agent to retain coordination, design, and domain decisions
  while a separate lower-cost model implements code. SKIP ordinary
  implementation requests, planning, bounded research or review delegation,
  and parallel subagent work without a coordinator/implementer relationship.
---

# Coordinate Implementation

Retain user intent, consequential decisions, and acceptance in the coordinator.
Delegate repository investigation and local code realization to a managed
implementer.

At the start, tell the user that implementation is delegated and interaction
remains in the coordinator.

## Iron law

**DO NOT DISPATCH AN IMPLEMENTER UNTIL YOU HAVE SELECTED THE CONTROL SURFACE
AND CONCRETE MODEL AND INCLUDED STOPPING CONDITIONS IN THE HANDOFF.**

Set the model explicitly. Do not substitute a surface that lacks model control,
follow-up, or observable status.

## Responsibility boundary

Use this boundary to decide what to retain and what to delegate:

| Coordinator | Managed implementer |
|---|---|
| User communication, priorities, and scope | Repository and dependency investigation |
| Domain semantics and observable behavior | Implementation approach within those decisions |
| Architecture, ownership, and compatibility | Naming, imports, function boundaries, and local patterns |
| Rollout and cross-system tradeoffs | Debugging and routine implementation fallout |
| Product and domain acceptance | Proportional tests, validation, and self-review |
| Worktree, branch, PR, and external collaboration | Commits only when the handoff authorizes them |

Read code only to answer the user, make a domain or architectural decision, or
assess the delivered behavior. Do not inspect code solely to prepare an
exhaustive file, symbol, dependency, or command inventory for the implementer.

When a code-level representation defines domain semantics or invariants, reason
about it in the coordinator. Treat identity, ordering, graph structure,
persistence, and concurrency semantics as coordinator concerns when they define
the system's behavior.

Keep edits, routine fixes, tests, and code-quality cleanup in the implementer.
Send a focused correction when a change looks small instead of taking over the
edit.

## Create the managed implementer

Use a delegation surface only when it provides:

- Explicit concrete model selection
- Explicit reasoning effort when the harness supports it
- The tools and permissions required for implementation
- Isolated implementation context
- Access to the assigned checkout or worktree
- Follow-up or resume support
- Observable progress and completion status
- Coordinator control without direct user steering

Read [references/harness-routing.md](references/harness-routing.md) before the
first dispatch.

Run one managed implementer at a time against a worktree. Reuse it while the
worktree and implementation outcome remain coherent. Do not run competing
workers against the same files.

Use the model the user requests. Otherwise, choose the lowest-cost role suited
to the judgment the implementer must exercise:

| Implementation work | Model role |
|---|---|
| Already-exact transformation with deterministic verification | Throughput |
| Specified behavior with routine engineering judgment | Balanced |
| Intentionally delegated diagnosis or consequential design | Reasoning |

When the role is not evident from known context, use balanced. Do not inspect
code merely to justify throughput. Broaden verification for a large or
high-impact change. Select a stronger role only for additional judgment, not
for file count, diff size, importance, or blast radius alone.

Read [references/throughput-handoff.md](references/throughput-handoff.md) before
a throughput dispatch.

Before dispatch, tell the user the selected surface, concrete model, model role,
and reasoning effort when the harness supports it.

## Send a concise handoff

Send a concise, self-contained handoff. Include only the parts that apply:

- The required outcome
- User, product, or domain context it cannot recover from the repository
- Decisions and constraints already established
- Genuine scope boundaries
- A known starting point when one is useful
- Commit authority

Tell the implementer to:

- Read the applicable repository guidance and inspect the repository
- Choose the local implementation
- Make the changes and repair routine implementation fallout
- Run proportional verification
- Self-review and report the result

Present known files, symbols, commands, and implementation ideas as leads.
Mark them as requirements only when they are genuine constraints.

Leave naming, imports, use of existing dependencies, function decomposition,
and routine refactoring to the implementer. Specify a local code choice only
when the user requested it or it carries domain or architectural meaning.

Keep pushes, PR changes, review replies, issues, and other external messages in
the coordinator unless the user explicitly delegates them.

Require the implementer to report:

- What changed
- Verification performed
- Remaining concerns
- Commit and worktree state

Do not require structured status vocabulary.

## Set the escalation boundary

In every handoff, authorize the implementer to make reversible code-local
choices directly.

Also instruct the implementer to stop before choosing an option that changes:

- Observable behavior or domain meaning
- Architecture or ownership boundaries
- Public compatibility or rollout behavior
- Agreed scope or user priorities
- A safety or security property not already decided

Require the implementer to preserve useful work and report the exact location,
observed facts, and evident options when it stops.

When the implementer stops, decide the issue in the coordinator, involve the
user, or deliberately delegate the decision to a stronger model. When more code
facts are needed, ask the implementer to investigate and report them before
deciding.

## Collaborate through the work

1. Resolve only the coordinator-owned decisions needed to state the outcome.
2. Create or resume the managed implementer and send the concise handoff.
3. Wait through the harness event mechanism. Continue waiting while the state
   is unchanged; do not treat unchanged state as a blocker or completion.
4. When the implementer stops, apply Set the escalation boundary.
5. When the result misses the intent, explain the mismatch and send a focused
   correction to the same implementer.
6. Use the implementer's report, focused diff inspection, CI, and user-facing
   evidence to assess acceptance. Do not repeat routine investigation or tests
   without a concrete reason.
7. Complete coordinator-owned commits, pushes, PR changes, review replies, and
   other external collaboration after the implementation is accepted.

## Red flags

| Thought | Required response |
|---|---|
| "There are too many call sites for the cheapest model." | More identical call sites increase consumption, not reasoning. Use throughput. |
| "The API is important, so a balanced model is safer." | Resolve compatibility in the coordinator and strengthen verification. |
| "A large diff needs a smarter implementer." | Name the unresolved semantic decision or use throughput. |
| "The worker must run tests and repair fallout." | Leave prescribed fallout with the throughput implementer until a new decision appears. |
| "The throughput worker stopped, so it needs a stronger model." | Read Throughput handoff and classify the cause before changing models. |
| "Using a scoped Codex subagent is close enough." | Use the controlled top-level Codex task required by Harness routing. |
| "This fix is small enough for the coordinator to do directly." | Send a focused correction to the managed implementer. |

**Violating the letter of these rules is violating the spirit of them.**
