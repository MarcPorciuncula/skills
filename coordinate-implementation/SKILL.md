---
name: coordinate-implementation
description: >-
  TRIGGER: Use when the user invokes `coordinate-implementation` or explicitly
  asks the current agent to remain the coordinator while a separate lower-cost
  model implements code. SKIP ordinary implementation requests, planning,
  bounded research or review delegation, and parallel subagent work that does
  not establish a coordinator/implementer relationship.
---

# Coordinate Implementation

Keep requirements and decisions in the coordinator. Route code investigation,
edits, tests, and routine self-review through the cheapest capable managed
implementer.

## Iron law

**NO IMPLEMENTER DISPATCH WITHOUT AN EXPLICIT MODEL, CONTROL SURFACE, AND
STOPPING CONDITIONS.**

Do not let the model inherit silently. Do not substitute an easier-to-launch
surface that lacks model control, follow-up, or observable status.

At the start, announce that the coordinator/implementer workflow is active and
that user interaction remains in the coordinator. Before dispatch, announce the
selected surface, concrete model, task class, and reasoning effort when the
surface supports it.

## Responsibilities

| Coordinator | Managed implementer |
|---|---|
| User communication and scope | Task-local codebase investigation |
| Architecture and behavior decisions | Code edits and mechanical fallout |
| Compatibility and deployment boundaries | Proportional tests and validation |
| Worktree, branch, and PR ownership | Routine self-review and fixes |
| Model and control-surface selection | Structured evidence or escalation |
| Focused diff and CI inspection | Commits only when the brief authorizes them |

The coordinator does not implement code because a change looks small. Send
corrections to the managed implementer. Keep pushes, PR changes, review replies,
and other external collaboration in the coordinator unless the user explicitly
delegates them.

## Qualify the control surface

Use a delegation surface only when it provides all of these capabilities:

- An explicit concrete model selection and, when available, reasoning effort
- The tools and permissions required for implementation
- Isolated implementation context
- Access to the assigned checkout or worktree
- Follow-up or resume support
- Observable progress and completion status
- Coordinator control without direct user steering

Read [references/harness-routing.md](references/harness-routing.md) before the
first dispatch. Match tools to these capabilities instead of relying on names
such as `subagent`, `thread`, `task`, or `session`.

In Codex, always use a separate controlled top-level task or thread. Never use a
scoped Codex subagent as the managed implementer. If the required top-level task
tools are unavailable, report the blocker instead of substituting a subagent.

Run one managed implementer at a time in a worktree. Reuse it while the worktree
and implementation outcome remain coherent. When a harness fixes the model for
the lifetime of a worker, hand off sequentially; do not run competing workers
against the same files.

## Choose the model from residual decisions

Resolve architecture, compatibility, and intended behavior in the coordinator.
Classify what remains after those decisions:

| Remaining work | Model role | Default effort |
|---|---|---|
| Exact transformation with deterministic verification | Throughput | Low for one-step work; medium for multi-file propagation |
| Specified behavior with routine coding judgment | Balanced | Medium or high |
| Diagnosis, unresolved semantics, or architecture | Reasoning, or resolve it in the coordinator first | High or above |

Inspect the live tool schema, model catalogue, and configured agent definitions
before resolving a role to a concrete model. Prefer a stable family alias when
the harness supports one. When no reliable ordering is available, ask the user
for the model ladder. Never use the parent or default model merely because the
ordering is unknown.

### Throughput gate

Use the throughput role when all of these are true:

- The before-and-after transformation is exact.
- Compatibility and deployment decisions are complete.
- Every new argument or value has a prescribed source.
- No behavioral or architectural choice remains.
- Search, compilation, generation, or targeted tests can verify completeness.
- The throughput model has the necessary tools and context capacity.

Before selecting throughput, complete this statement in the implementation
brief: `No semantic choices remain because every affected case follows this
rule: <rule>.`

File count, call-site count, diff size, test duration, consumption, importance,
and blast radius do not justify a stronger model. Increase verification scope
when risk is broad. Increase model capability only for a named unresolved
decision.

For a symbol rename, exact API replacement, or already-decided signature
change, default to throughput even when the change touches many files. Before a
signature or API migration, confirm whether it crosses a process, transport,
persisted-data, generated-client, plugin, or rolling-deployment boundary.

## Build the implementation brief

Read [references/implementer-brief.md](references/implementer-brief.md) and fill
every required section before dispatch.

Use a throughput read-only preflight before editing when a signature or API
migration may not apply uniformly. Require the implementer to enumerate
consumers, confirm the prescribed source exists, and report exceptions.

## Coordinate the work

1. Inspect only enough repository and external state to make coordinator-owned
   decisions and prepare the brief.
2. Classify the residual work and choose the concrete model and effort.
3. Qualify the harness surface and create or resume the managed implementer.
4. Send the complete brief. Do not rely on conversation context the implementer
   cannot see.
5. Wait through the harness's event or wait mechanism. An unchanged state is
   not completion or a blocker.
6. Answer questions with a concrete decision or a revised rule. Do not take
   over the edit.
7. Keep routine fixes, tests, and self-review in the implementer context.
8. On completion, use the structured report as evidence. Inspect focused diff
   sections or CI when useful; do not repeat routine investigation or tests
   without missing, inconsistent, high-risk, user-required, or repo-required
   evidence.
9. Complete coordinator-owned git and PR operations after the implementation
   evidence is sufficient.

## Stop and escalate

The implementer returns `NEEDS_DECISION` at the first case where the prescribed
rule is undefined or ambiguous. It preserves the worktree state and does not
invent a default, pass `nil`, create a background context, make a parameter
optional, add an adapter, expand scope, or redesign the API.

Handle the report by cause:

| Cause | Coordinator action |
|---|---|
| A deterministic instruction was omitted | Add the rule and resume throughput |
| An already-decided localized exception was omitted | Add the exception and resume throughput |
| Ordinary implementation judgment remains | Continue the controlled work on the balanced role |
| Architecture or compatibility is invalid | Resolve it in the coordinator; involve the user when behavior or scope changes |
| Tools, permissions, or environment failed | Fix the environment without upgrading the model |
| The worker ignored a clear instruction | Tighten or split the brief before considering an upgrade |

Upgrade only the work that needs additional reasoning. Return remaining
mechanical propagation to throughput when the harness supports model changes or
sequential handoff.

## Red flags

| Thought | Required response |
|---|---|
| "There are too many call sites for the cheapest model." | More identical call sites increase consumption, not reasoning. Use throughput. |
| "The API is important, so a balanced model is safer." | Resolve compatibility in the coordinator and strengthen verification. |
| "A large diff needs a smarter implementer." | Name the unresolved semantic decision or use throughput. |
| "The worker must run tests and repair fallout." | Prescribed fallout remains mechanical until a new decision appears. |
| "The throughput worker stopped, so it needs a stronger model." | Read the cause. Missing rules and environment failures do not justify an upgrade. |
| "Using a scoped Codex subagent is close enough." | The Codex route requires a controlled top-level task or thread. |
| "This fix is small enough for the coordinator to do directly." | Keep implementation context in the managed implementer and send a focused correction. |

**Violating the letter of these rules is violating the spirit of them.**
