---
name: writing-specs
description: >
  Write, revise, cross-check, or review software specifications, architecture
  documents, RFCs, and substantive technical design tickets at spec altitude.
  TRIGGER when the user asks to write a spec, draft a design doc or RFC,
  specify an architectural or contract boundary in the repository or a ticket,
  update an existing specification, or cross-check a spec. SKIP routine
  implementation without a requested spec, pull request bodies (use
  writing-pr-bodies), and lightweight issue triage.
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

## 4. Calibrate spec altitude and implementation latitude

Select the spec altitude before drafting. Default to architectural altitude unless the user explicitly asks for low-level planning:

| Mode | Trigger | Assumed implementer | Required content |
|---|---|---|---|
| **Architectural spec** *(default)* | Any normal request to write a spec, design doc, or RFC | Capable, codebase-literate implementer that resolves local code mechanics | Required components, ownership, data-model semantics, cross-domain seams, transactional and failure boundaries, invariants, rejected alternatives, behavioural acceptance criteria, and any user-agreed low-level decisions (~150 to 300 lines for a single-PR or single-domain spec) |
| **Detailed / `on-rails` spec** *(opt-in)* | Only when the user explicitly requests a detailed, low-level, or `on-rails` spec, or names a lower-reasoning or high-throughput executor | Executor that needs local implementation decisions pre-resolved | Everything in an architectural spec plus concrete package and file maps, exact proto/DDL/interface signatures, and ordered implementation slices |

Apply these precision rules in the default architectural mode:

- **Include low-level detail only by contract or agreement:** Specify exact wire keys, backwards-compatible column or enum names, cross-domain interfaces, or low-level mechanics when they define an externally locked contract or were explicitly agreed with the user during design discussion. Do not invent low-level mechanics on the user's behalf to put implementation on rails.
- **Specify data-model semantics over full DDL:** State entities, ownership, immutability, uniqueness and concurrency keys, and RLS or visibility rules. Omit unagreed column defaults, `CHECK` constraints, secondary indexes, and full `.proto` or SQL DDL dumps unless they are externally locked contracts.
- **State the delegation boundary explicitly:** Include a one-line clause stating that the boundaries, sequencing, and ownership rules are binding while internal file layout, helper splits, and local DTO shapes are implementation choices. When showing a Go signature or internal struct to illustrate data flow, label it as an **indicative shape**.
- **Keep code blocks minimal:** Restrict code blocks to cross-boundary seams, small wire shapes, and compact ASCII flows.
- **Worked state or history traces:** When specifying a state machine, reducer, or multi-step protocol (such as join arrival deduplication or event-sourced prefix reduction), include a short step-by-step trace (`1. Event A -> state X`) showing how concrete inputs advance the state.
- **UI surfaces and affordances:** When the spec covers a user-facing screen or workflow, state the primary user task, include an affordance tree (using `map-ui-affordances` if available) or a `User need | Affordance | Consequence if absent` table, and map domain states to derived UI presentation states (`Domain state | Presentation`).
- **Ground in codebase anchors without line numbers:** Cite existing packages, files, types, or rules (`ent/rules/filter_task.go`, `pkg/domains/triggers/`) to anchor where a boundary lives today or which pattern to mirror. Do not cite `file:line` numbers, prescribe per-file layouts for new packages, or turn a spec into a line-by-line edit script.

## 5. Keep scope splits, open questions, and acceptance clean

- **Explicit `Out of scope` and `Open questions`:** List excluded capabilities (linking to the follow-up ticket that owns them) and unresolved design questions (with recommended defaults) in dedicated sections. Never hide `TBD` inside a settled requirement.
- **Focused acceptance direction, not a second copy of the spec:** Keep `Acceptance criteria` (or `Acceptance direction`) to a tight list of observable end-to-end properties and boundary proofs (such as idempotency under duplicate delivery, permission enforcement, or zero cross-domain imports). Do not append a 15-bullet checklist that merely repeats every paragraph of the spec body.
- **Re-synthesize when updating a living spec:** When decisions evolve, integrate the new design directly into the governing sections and remove superseded claims instead of stacking `Update:` notes at the bottom.

## 6. Cross-check a spec when requested

Run this cross-check workflow only when the user explicitly asks to cross-check or multi-agent review a spec. Do not run it automatically on every spec.

1. **Dispatch a scoped, read-only reviewer:** Send an independent agent to inspect the spec against the repository. Instruct the reviewer to report only:
   - Missing or violated invariants, security or RLS gaps, or unaddressed concurrency and failure/effect boundaries.
   - Contradictions with real codebase constraints or existing contracts.
   - Unresolved product, UX, scope, or compatibility forks.
   Instruct the reviewer to skip naming, internal file-layout, and local DTO-shape nitpicks, and to preserve low-level decisions explicitly agreed with the user.
2. **Triage every finding in the main agent:** Verify each finding against the codebase and the user's original intent before editing the spec, assigning one disposition:

| Disposition | Criteria | Action |
|---|---|---|
| `Fix` | Verified invariant gap, boundary/security/effect defect, or real codebase contradiction with one clear fix aligned with user intent | Re-synthesize the governing section directly |
| `Lift` | Minor inaccuracy in an unagreed implementation-level detail (such as a helper signature, index, or internal type) that does not affect architecture in default architectural mode | Delete the detail or lift it to a higher-level requirement instead of patching low-level mechanics (in `on-rails` mode, use `Fix` instead) |
| `Escalate` | Genuine fork in product semantics, scope, risk tolerance, or compatibility where multiple valid answers exist | Record in `Open questions` with concrete options, trade-off, and a recommendation for the user |
| `Reject` | Out of scope, speculative hardening, or reviewer preference | Drop with a one-line rationale; do not debate across rounds |

3. **Cap convergence at 3 rounds:**
   - **Round 1:** Full architectural review against the codebase.
   - **Round 2 (only if Round 1 made substantive `Fix` edits):** Targeted re-check of the modified sections and boundaries only, not a fresh open-ended hunt.
   - **Round 3 (only if Round 2 uncovered a new boundary contradiction):** Final convergence check, then stop.
   Stop early whenever a round produces zero `Fix` items. Move any issue still contested after Round 3 to `Escalate` for human decision.
4. **Report a concise handoff:** Present the updated spec link, a brief list of auto-applied `Fix` and `Lift` changes, and any `Escalate` items requiring user input. Do not dump raw multi-round reviewer transcripts.
