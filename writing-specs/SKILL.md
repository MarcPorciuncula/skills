---
name: writing-specs
description: >
  Write, revise, or review software specifications, architecture documents,
  RFCs, and substantive technical design tickets at spec altitude. TRIGGER when
  the user asks to write a spec, draft a design doc or RFC, specify an
  architectural or contract boundary in the repository or a ticket, or update
  an existing specification. SKIP routine implementation without a requested
  spec, pull request bodies (use writing-pr-bodies), and lightweight issue
  triage.
---

# Writing Specifications and Design Documents

If `writing-persistent-content` is available, load it and select its internal technical profile for prose register. This skill owns what belongs in a technical specification, how to define architectural and contract boundaries, and how to scope delivery slices so an engineer or agent can implement the design without guessing or re-litigating foundational choices.

Write a repository specification file only when the user asks to persist one or when an architectural contract needs a durable home in the codebase. Never commit single-use, file-by-file implementation task checklists (`plans/*.md`); use `dex` or Linear for task breakdown.

## 1. Resolve domain and codebase facts before drafting

- **Discover codebase facts directly:** Inspect the existing code, schemas, callers, and adjacent specs yourself. Never ask the user questions that the repository already answers.
- **Lock product and domain semantics before code mechanics:** When a design has genuine forks (domain model, user-visible behaviour, authority, or failure semantics), surface the minimum foundational questions with concrete options, a recommendation, and the deciding trade-off.
- **Never silently cut correctness or scope:** Recommend deferring speculative features when appropriate, but let the user decide. Do not drop edge cases or correctness invariants under "YAGNI" or "v1 simplicity".

## 2. Frame the outcome, delivery graph, and slice horizon

Open every spec by situating the reader in the system and the delivery sequence:

- **Outcome and current-state problem:** Lead with what the change delivers and the concrete limitation, collision, or failure mode in the current system (citing exact existing services, tables, or routes where relevant).
- **Delivery-graph position:** State how this spec relates to adjacent work: what it `Builds on` or is `Blocked by`, what it is `Independent of` (and can run in parallel with), and what child or sibling tickets it `Splits out`.
- **Target architecture vs. current vertical slice:** When specifying a foundational system, present the enduring architectural model so boundaries are future-proof, then explicitly bound the **Initial implementation slice** (and how the slice can be exercised end-to-end, such as via a development harness or synthetic progression RPCs before upstream/downstream dependencies exist). Keep future extensions in a clearly labelled `Future features / Deferred` section so they inform boundaries without becoming current acceptance criteria.
- **Maturity and compatibility posture:** State whether the surface is an unreleased/greenfield sandbox (where breaking schema/event changes are accepted and speculative upcasters are omitted) or a live production contract requiring expand-and-contract migration and rolling-version compatibility.

## 3. Specify architectural boundaries, authority, and invariants

Scale the structural sections to the complexity of the system. For a focused feature, a discriminator table and scope list suffice; for a stateful or cross-domain system, specify these five boundaries explicitly:

### Domain and responsibility boundaries

Separate what each component or domain owns and what may cross the boundary between them:

- **Discriminator and comparison tables:** Use a table (`Dimension | Concept A | Concept B`, `Term | Meaning | Scope`, or `Component | Responsibility`) to separate adjacent concepts or services.
- **Cross-domain isolation and adapters:** When two domains interact (for example, `Workflow` and `Task`, or `Inbox` and domain services), draw the handoff in an ASCII diagram and state the type-isolation rule: which side owns which contract, whether cross-domain identifiers are opaque strings, and which imports or direct mutations are forbidden.

```text
Workflow domain              Integration binding                 Task domain

IssueTask effect ----------> map to StartTask -----------------> TaskRun
(Workflow-native values)     (opaque correlation strings)        (Task-owned state)
```

### Authority vs. derived projections

When state is stored or cached in more than one place, state which record is **authoritative** and which records are **derived/disposable projections**:

- Use an ownership table (`Value | Owner`) to show whether a field belongs on the definition, an immutable revision, a run snapshot, or the event history.
- State the projection rules: whether a projection can be deleted and rebuilt from authoritative history, how staleness is resolved (history wins), and that handlers/adapters never mutate derived projections directly.

### Transactional envelope, concurrency, and failure treatment

Do not stop at naming an operation; specify its concurrency guard, transaction boundary, and post-commit behaviour:

- Show the execution envelope as an indented call tree (for example: acquire per-run row lock -> load pinned revision and history -> evaluate pure transition -> append history delta and update projection atomically -> commit -> dispatch outbound effects post-commit).
- Define idempotency and failure handling in a compact table rather than leaving error paths implicit:

| Failure or edge case | Treatment |
|---|---|
| Duplicate or already-applied completion input | No-op (or return existing result) without appending duplicate history |
| Invalid correlation or domain invariant violation | Reject before commit without side effects |
| Concurrent input for the same entity | Serialise on the authoritative row lock and evaluate against latest state |
| Post-commit effect dispatch failure | Preserve committed state; surface error for adapter/job retry without rolling back domain history |

### Core invariants

Distill the non-negotiable rules of the design into a numbered **Invariants** list (for example: *"1. Every WorkflowRun is pinned to one immutable revision. 2. A StepRun completes at most once; duplicate completion is a no-op. 3. The reducer performs no database, queue, or network I/O."*).

### Alternatives considered

Include a compact `Alternative | Decision` table recording plausible designs that were rejected and the concrete structural reason they fail (such as coupling failure domains, violating single-source-of-truth authority, or requiring cross-table unions on replay). This prevents implementers and reviewers from re-proposing rejected shortcuts.

## 4. Calibrate contract precision and implementation latitude

Give the implementer exact shapes where boundaries meet, while preserving freedom over local code mechanics:

- **Binding contracts vs. indicative shapes:** Provide exact protobuf/RPC declarations, JSON payloads, SQL/ent schema trees, or discriminator tables when they define a cross-component contract, migration, or UI-to-backend boundary. When showing a Go signature or internal struct to illustrate data flow, label it as an **indicative shape** and state what is binding (*"The sequencing and ownership above are the contract; exact method splits are implementation decisions"*).
- **Worked state or history traces:** When specifying a state machine, reducer, or multi-step protocol (such as join arrival deduplication or event-sourced prefix reduction), include a short step-by-step trace (`1. Event A -> state X`) showing how concrete inputs advance the state.
- **UI surfaces and affordances:** When the spec covers a user-facing screen or workflow, state the primary user task, include an affordance tree (`map-ui-affordances`) or a `User need | Affordance | Consequence if absent` table, and map domain states to derived UI presentation states (`Domain state | Presentation`).
- **Use codebase paths as grounding anchors, not edit scripts:** Cite existing files, functions, or rules (`ent/rules/filter_task.go`, `meetings.go:1455`) to ground where a boundary lives today or which existing pattern to mirror. Never turn a spec into a line-by-line edit script.

## 5. Keep scope splits, open questions, and acceptance clean

- **Explicit `Out of scope` and `Open questions`:** List excluded capabilities (linking to the follow-up ticket that owns them) and unresolved design questions (with recommended defaults) in dedicated sections. Never hide `TBD` inside a settled requirement.
- **Focused acceptance direction, not a second copy of the spec:** Keep `Acceptance criteria` (or `Acceptance direction`) to a tight list of observable end-to-end properties and boundary proofs (such as idempotency under duplicate delivery, permission enforcement, or zero cross-domain imports). Do not append a 15-bullet checklist that merely repeats every paragraph of the spec body.
- **Re-synthesize when updating a living spec:** When decisions evolve, integrate the new design directly into the governing sections and remove superseded claims instead of stacking `Update:` notes at the bottom.
