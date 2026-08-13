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

Retain user intent, domain and architecture decisions, and acceptance in the
coordinator. Delegate repository investigation, implementation details, and
code changes to a separate implementer agent.

At the start, tell the user that implementation is delegated and interaction
remains in the coordinator.

## Responsibility boundary

Use this boundary to decide what to retain and what to delegate:

| Coordinator | Implementer agent |
|---|---|
| User communication, priorities, and scope | Repository and dependency investigation |
| Domain semantics and observable behavior | Implementation approach within those decisions |
| Architecture, ownership, and compatibility | Naming, imports, function boundaries, and local patterns |
| Rollout and cross-system tradeoffs | Debugging and routine fixes caused by the change |
| Product and domain acceptance | Tests and checks appropriate to the change, plus self-review |
| Worktree, branch, pushes, PRs, review replies, and issues | Commits only when the coordinator allows them in the initial message |

Read code only to answer the user, make a domain or architectural decision, or
assess the delivered behavior. Do not inspect code solely to prepare an
exhaustive file, symbol, dependency, or command inventory for the implementer.

When a code-level representation defines domain semantics or invariants, reason
about it in the coordinator. Treat identity, ordering, graph structure,
persistence, and concurrency semantics as coordinator concerns when they define
the system's behavior.

Keep edits, routine fixes, tests, and code-quality cleanup in the implementer
agent. Send a focused correction when a change looks small instead of taking
over the edit.

## Create the implementer agent

Before choosing how to create the implementer, verify that the available tool
provides:

- Explicit concrete model selection
- Explicit reasoning effort when the available tools support it
- The tools and permissions required for implementation
- A context separate from the coordinator
- Access to the assigned checkout or worktree
- Follow-up messages or resuming the same agent
- Observable progress and completion status
- Coordinator control without requiring the user to message the implementer

Read [Choose the implementer tool and model](references/harness-routing.md)
before creating the implementer agent.

Run one implementer agent at a time against a worktree. Reuse the same agent
while it works toward the same requested outcome in that worktree. Do not run
competing agents against the same files.

Use the model the user requests. Otherwise, choose the lowest-cost role suited
to the judgment the implementer must exercise:

| Implementation work | Model role |
|---|---|
| Already-exact transformation with deterministic verification | Throughput |
| Specified behavior with routine engineering judgment | Balanced |
| Intentionally delegated diagnosis or decisions about behavior or architecture | Reasoning |

When the role is not evident from known context, use balanced. Do not inspect
code merely to justify throughput. Broaden verification for a large or
high-impact change. Select a stronger role only for additional judgment, not
for file count, diff size, importance, or the number of affected systems or
users alone.

Read [Throughput handoff](references/throughput-handoff.md) before assigning
work to a throughput implementer.

Before assigning the work, tell the user how the implementer agent will be
created, the concrete model, the model role, and the reasoning effort when the
available tools support it.

## Send a concise handoff

Send a concise, self-contained handoff. Include only the parts that apply:

- The required outcome
- User, product, or domain context it cannot recover from the repository
- Decisions and constraints already established
- For user-facing UI, the primary task, required affordances, explicit
  exclusions, and approved terminology
- Genuine scope boundaries
- A known starting point when one is useful
- Whether the implementer may create a commit

Tell the implementer to:

- Read the applicable repository guidance and inspect the repository
- Choose the local implementation
- Make the changes and repair routine failures caused by them
- Run tests and checks appropriate to the change
- Self-review and report the result

Present known files, symbols, commands, and implementation ideas as useful
starting points. Mark them as requirements only when they are genuine
constraints.

For user-facing UI, map each required affordance to a settled requirement or
user need before delegating. Treat proposed copy, layout, optional fields, and
analogous screens as suggestions unless the user selected them or they carry
settled behaviour. A detailed or complete-looking proposal is not itself a list
of requirements.

Leave naming, imports, use of existing dependencies, function decomposition,
and routine refactoring to the implementer. Specify a local code choice only
when the user requested it or it carries domain or architectural meaning.

Keep pushes, PR changes, review replies, issues, and other external messages in
the coordinator unless the user explicitly delegates them.

When the PR workflow requires a draft transport checkpoint, complete the
coordinator-owned push and draft PR at that checkpoint. Do not wait for product
acceptance. Acceptance gates readiness and final handoff.

Require the implementer to report:

- What changed
- Verification performed
- Remaining concerns
- Commit and worktree state

Do not require fixed status labels such as `DONE` or `BLOCKED`.

## Tell the implementer when to stop

In every handoff, authorize the implementer to make reversible choices that
affect only local implementation details.

Also instruct the implementer to stop before choosing an option that changes:

- Observable behavior or domain meaning
- Architecture or ownership boundaries
- Compatibility for public APIs or stored data, or rollout behavior
- Agreed scope or user priorities
- A safety or security property not already decided

Require the implementer to preserve useful work and report the exact location,
observed facts, and available options when it stops.

When the implementer stops, decide the issue in the coordinator, involve the
user, or deliberately delegate the decision to a stronger model. When more code
facts are needed, ask the implementer to investigate and report them before
deciding.

## Collaborate through the work

1. Resolve only the coordinator-owned decisions needed to state the outcome.
2. Create or resume the implementer agent and send the concise handoff.
3. Wait through the task or agent wait tool. Continue waiting while the status
   is unchanged; do not treat unchanged status as a blocker or completion.
4. When the implementer stops, follow
   [Tell the implementer when to stop](#tell-the-implementer-when-to-stop).
5. When the result misses the intent, explain the mismatch and send a focused
   correction to the same implementer.
6. Use the implementer's report, focused diff inspection, CI, and user-facing
   evidence to assess acceptance. Do not repeat routine investigation or tests
   without a concrete reason.
7. After the implementation is accepted, complete the remaining
   coordinator-owned commits, pushes, PR changes, review replies, issues, and
   other external messages.

## Red flags

| Thought | Required response |
|---|---|
| "There are too many call sites for the cheapest model." | More identical call sites increase cost and time, not reasoning. Use throughput. |
| "The API is important, so a balanced model is safer." | Resolve compatibility in the coordinator and strengthen verification. |
| "A large diff needs a smarter implementer." | Name the unresolved behavior, architecture, or compatibility decision, or use throughput. |
| "The implementer must run tests and fix the resulting failures." | Leave expected fixes with the throughput implementer until a new decision appears. |
| "The throughput implementer stopped, so it needs a stronger model." | Read [Throughput handoff](references/throughput-handoff.md) and classify the cause before changing models. |
| "Using a scoped Codex subagent is close enough." | Use a separate top-level Codex task; do not use a scoped subagent. |
| "This fix is small enough for the coordinator to do directly." | Send a focused correction to the implementer agent. |
| "The implementation is not accepted, so opening a draft PR is premature." | Follow the PR workflow. A draft transport checkpoint does not claim acceptance. |
| "The proposal is detailed enough to copy into the handoff as requirements." | Classify each item as settled behaviour, required affordance, suggestion, or open decision. Require only the first two. |

**Violating the letter of these rules is violating the spirit of them.**
