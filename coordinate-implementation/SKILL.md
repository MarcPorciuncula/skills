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

Retain user intent, domain and architecture decisions, and acceptance in the coordinator while delegating repository investigation, local code structure, and edits to a separate implementer subagent.

At the start, inform the user how the implementer will be created (including its concrete model, role tier, and reasoning effort) and whether the coordinator remains responsive while the implementer runs.

## 1. Responsibility boundary

| Coordinator owns | Implementer subagent owns |
|---|---|
| User communication, priorities, and scope | Repository and dependency discovery |
| Domain semantics, observable behaviour, and UI affordance trees | Local implementation approach, naming, imports, and function decomposition |
| Architecture, ownership, compatibility, and rollout boundaries | Code edits, debugging, and routine fixes caused by the change |
| Product and domain acceptance | Narrow tests and checks for the touched scope, plus self-review |
| Worktree setup, git pushes, PRs, review replies, and Linear issues | Local commits only when authorized by the coordinator in the handoff |

- **Inspect code only for coordinator decisions:** Read repository files only to answer the user, settle a domain or architectural boundary, or assess acceptance. Do not pre-read files solely to compile an exhaustive file, symbol, or command inventory for the implementer.
- **Keep all code edits in the implementer:** Run at most one implementer at a time against a worktree and reuse that same agent for follow-ups. Even when a follow-up fix looks small, send a focused correction to the implementer instead of editing the worktree directly in the coordinator.
- **Keep transport checkpoints on schedule:** When the repository's PR workflow requires an early draft PR after the first push, complete the coordinator-owned push and draft PR at that checkpoint without waiting for final product acceptance.

## 2. Select the implementer tool and model role

Read [references/harness-routing.md](references/harness-routing.md) to verify subagent capabilities (explicit model/effort selection, isolated context, worktree access, follow-up resumption, and interruptible event waiting) before creating the implementer.

Unless the user requests a specific model, select the lowest-cost role that matches the unguided engineering judgment required; never upgrade the model tier merely because a change touches many files or call sites:

| Implementation work | Model role |
|---|---|
| Exact, deterministic transformation with prescribed before/after mapping (read [references/throughput-handoff.md](references/throughput-handoff.md)) | **Throughput** |
| Specified behaviour and boundaries requiring routine local engineering judgment | **Balanced** (default when uncertain) |
| Intentionally delegated diagnosis or open design/architectural judgment | **Reasoning** |

## 3. Send a self-contained handoff with explicit stop conditions

Include only the context the implementer cannot recover from the repository:

- **Outcome and settled constraints:** The target behaviour, architectural/compatibility boundaries, worktree path, and whether the implementer may commit.
- **Settled requirements vs. suggestions:** Distinguish binding requirements from illustrative starting points (such as candidate file paths, rough layouts, or unconfirmed copy). For user-facing UI, pass the settled affordance tree (`map-ui-affordances`), explicit exclusions, and approved terminology.
- **Execution expectations:** Instruct the implementer to read applicable repository guidance, make the changes, run narrow verification on the touched scope, self-review, and report what changed, verification run, remaining concerns, and worktree/commit state (without requiring rigid status keywords).
- **Mandatory stop conditions:** Authorize reversible local code choices, but require the implementer to **stop, preserve work, and report options** before making any choice that alters:
  - Observable user or domain behaviour
  - Component ownership or architectural boundaries
  - Public API contracts, stored data schemas, or rollout compatibility
  - Agreed scope or security/permission invariants

## 4. Wait passively and collaborate through acceptance

When the harness supports non-blocking dispatch, wait via an event mechanism that new user input can interrupt:

- **Do not poll or supervise:** While waiting, act only on implementer completion/exception events, harness errors, or new user input. Treat a wait timeout as a no-op and re-enter the wait; do not read implementer transcripts, inspect worktree diffs, or run checks mid-flight unless the user asks for an update or intervention.
- **Resolve escalations at the right tier:** When the implementer stops on an open decision, resolve it in the coordinator (or with the user) and resume the same implementer. If a throughput implementer stops, classify the cause using [references/throughput-handoff.md](references/throughput-handoff.md) before considering a model upgrade.
- **Verify acceptance without duplicating work:** Assess the implementer's report, focused diff, and user-facing behaviour, then complete coordinator-owned pushes, PR updates, and issue handoffs.
