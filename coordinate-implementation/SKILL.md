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

Keep user intent, consequential decisions, and acceptance in the coordinator.
Let a managed implementer investigate the repository and own the local code
realization.

At the start, tell the user that implementation is delegated and interaction
remains in the coordinator.

## Responsibility boundary

Send the implementer the outcome and decisions that matter outside the
implementation. Let it choose how to realize them in the codebase.

| Coordinator | Managed implementer |
|---|---|
| User communication, priorities, and scope | Repository and dependency investigation |
| Domain semantics and observable behavior | Implementation approach within those decisions |
| Architecture, ownership, and compatibility | Naming, imports, function boundaries, and local patterns |
| Rollout and cross-system tradeoffs | Debugging and routine implementation fallout |
| Product and domain acceptance | Proportional tests, validation, and self-review |
| Worktree, branch, PR, and external collaboration | Commits only when the handoff authorizes them |

Read code when it helps answer the user, make a domain or architectural
decision, or assess the delivered behavior. Do not investigate code merely to
prepare an exhaustive file, symbol, dependency, or command inventory for the
implementer.

When a code-level representation defines domain semantics or invariants, reason
about it in the coordinator. Identity, ordering, graph structure, persistence,
and concurrency semantics can be coordinator concerns even when expressed in
low-level code.

Keep edits, routine fixes, tests, and code-quality cleanup in the implementer.
Send a focused correction when a change looks small instead of taking over the
edit.

## Create the managed implementer

Read [references/harness-routing.md](references/harness-routing.md) before the
first dispatch.

Run one managed implementer at a time against a worktree. Reuse it while the
worktree and implementation outcome remain coherent. Do not run competing
workers against the same files.

Use the model the user requests. Otherwise choose the lowest-cost role suited
to the judgment the implementer must exercise:

| Implementation work | Model role |
|---|---|
| Already-exact transformation with deterministic verification | Throughput |
| Specified behavior with routine engineering judgment | Balanced |
| Intentionally delegated diagnosis or consequential design | Reasoning |

When the role is not evident from known context, use balanced. Do not
investigate code merely to justify throughput. File count, diff size,
importance, and blast radius broaden verification; they do not independently
require a stronger model.

Read [references/throughput-handoff.md](references/throughput-handoff.md) before
a throughput dispatch.

Before dispatch, tell the user which surface and concrete model will implement
the work.

## Send a concise handoff

Send a self-contained handoff with enough context to act independently. It may
be a short paragraph. Include only the parts that apply:

- The required outcome
- User, product, or domain context it cannot recover from the repository
- Decisions and constraints already established
- Genuine scope boundaries
- A known starting point when one is useful
- Commit authority

Ask the implementer to inspect the repository, choose the local implementation,
make the changes, run proportional verification, self-review, and report the
result.

Known files, symbols, commands, and implementation ideas are leads unless they
are genuine constraints. Leave naming, imports, use of existing dependencies,
function decomposition, and routine refactoring to the implementer unless the
user is concerned with them or they carry domain or architectural meaning.

Keep pushes, PR changes, review replies, issues, and other external messages in
the coordinator unless the user explicitly delegates them.

## Collaborate through the work

1. Resolve only the coordinator-owned decisions needed to state the outcome.
2. Create or resume the managed implementer and send the concise handoff.
3. Wait through the harness event mechanism. An unchanged state is not a
   blocker or completion.
4. When the implementer asks a consequential question, provide the missing
   decision or constraint. Ask it to investigate alternatives when more code
   facts are needed.
5. When the result misses the intent, explain the mismatch and send a focused
   correction to the same implementer.
6. Use the implementer's report, focused diff inspection, CI, and user-facing
   evidence as appropriate for acceptance. Do not repeat routine investigation
   or tests without a concrete reason.
7. Complete coordinator-owned commits, pushes, PR changes, review replies, and
   other external collaboration after the implementation is accepted.

Ask the implementer to report what changed, verification performed, remaining
concerns, and commit or worktree state. Structured status vocabulary is
optional.

## Escalation boundary

The implementer asks the coordinator before choosing an option that changes:

- Observable behavior or domain meaning
- Architecture or ownership boundaries
- Public compatibility or rollout behavior
- Agreed scope or user priorities
- A safety or security property not already decided

The implementer makes reversible code-local choices directly. Multiple valid
names, imports, local structures, or existing patterns are ordinary
implementation judgment. Report notable choices after implementation when they
help the coordinator assess the result.

When a consequential decision appears, preserve useful work and return the
location, observed facts, and evident options. The coordinator may decide,
involve the user, or deliberately delegate the decision to a stronger model.
