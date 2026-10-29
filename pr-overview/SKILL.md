---
name: pr-overview
description: >
  TRIGGER: Use only when the user invokes `pr-overview` by name or slash
  command, or explicitly asks for an overview of a PR or branch. SKIP: Do not
  use for a direct question about a PR, including its behaviour or
  implementation, or for correctness review, PR status, review comments, or
  implementation work unless the user also explicitly asks for an overview.
---

# PR Overview

Give the user a clear, verified mental model of a pull request or branch, especially when the existing PR body is poorly written, overly detailed for an agent rather than a human reviewer, or out of sync with the code.

If the user did not invoke `pr-overview` and asked a specific question about a PR rather than requesting an overview, ignore this skill and answer the question directly. When the user requests an overview with a specific area of focus, center the overview on that focus and include only the prerequisite context needed to understand it.

## 1. Treat the PR body as an unverified claim

Read the existing PR body (along with linked tickets or discussion) before reading the full diff to understand the author's stated motivation and spot gaps. Treat the base-to-head diff and surrounding code as the sole authority for what actually changes:

- Do not use a poorly structured PR body as the outline for your overview.
- Do not critique what the PR body explains or omits unless the user asks about the PR body itself.
- Describe the final net change on the branch, not the chronological history of intermediate commits.

## 2. Classify and structure the overview

Match the lead and structure to the primary nature of the change:

| Primary change | How to lead and structure the overview |
|---|---|
| **Functional** (changes user- or consumer-visible behaviour, UI surfaces, or public/developer API contracts) | Lead with what changes for the user or consumer and why: affected surfaces, affordances, observable contracts, states, and limitations. Put consequential internal architecture in a separate section after the functional account. |
| **Non-functional** (changes internal boundaries, storage, execution flow, or operations while preserving consumer-visible behaviour) | Lead with the changed architecture, ownership boundary, storage schema, or runtime flow and why it was restructured. |
| **Mixed** | Lead with whichever side explains why the PR exists, keeping product behaviour and internal mechanics in separate sections. |

Scale the overview to the change: a small, single-idea PR needs only 1 to 2 short paragraphs and no headings. Do not append diff statistics, commit lists, file inventories, or routine test/CI pass recaps.

## 3. Foreground exact contracts, schemas, and execution handoffs

Never hide changed contracts or runtime boundaries behind vague prose summaries or high-level conceptual tables:

- **Show exact contract and schema deltas as `diff` blocks:** Whenever the PR adds, modifies, or removes RPC methods/messages, public API payloads, persisted job/event payloads, or database tables/columns/indexes, render a compact before/after `diff` or ASCII schema block (`+`, `-`, `~`) showing the exact method, field, and column names, types, and adjacent `#` or `//` comments for semantics, lookup keys, and lifecycle.
- **Trace consequential execution paths from producer to consumer:** When the PR adds or changes how work is dispatched, show where dispatch or fan-out occurs, how consumers are wired, and whether execution is synchronous, notification-driven, or queued (including transaction timing, ordering, and retry/failure semantics when they affect correctness).
- **Explain only consequential internal choices:** Include internal architecture when a plausible alternative could deliver the same feature with a different ownership, persistence, permission, compatibility, or rollout boundary. Omit routine helpers, local state hooks, and boilerplate wiring.

## 4. Choose the clearest representation

Use one representation per question; do not repeat the same model in a diagram, table, and prose walkthrough:

| Information | Representation |
|---|---|
| Changed RPCs, API/message fields, or job/event schemas | Compact `diff` snippet with exact field/method names, types, and comments |
| Changed database tables, columns, indexes, or projections | ASCII schema `diff` block (`+`, `-`, `~`) with adjacent `#` comments |
| Parallel UI surfaces, affordances, or component ownership | Compact table or 2 to 6 bold-stem bullets (`- **Surface:** ...`) |
| Ordered runtime sequence | Numbered list (1 to 5 steps) |
| Branching topology, fan-out, convergence, or state machine | Plain-text ASCII diagram |
| Motivation, tradeoffs, compatibility, or implications | Short prose (1 to 3 sentences) |

## 5. Surface only genuine contradictions or regressions

Add a closing concern note only when the code contradicts the stated intent or introduces a concrete regression or bug that the PR body and discussion do not address. Omit a concerns section when no such defect exists; do not list pending review nits or minor explanatory gaps in the PR description.
