# file-superpowers — Design

A composite phase-routed skill that mirrors the structure and tuned content of the existing `dex-superpowers` skill in this repo, with all task-tracking persistence moved from the dex CLI to plain markdown files at `docs/superpowers/specs/` and `docs/superpowers/plans/`. The skill stands fully independent: an agent reading it has no need to know dex exists.

## Goals

- Preserve the tuned content and process improvements of `dex-superpowers` (phased brainstorming with gates, subagent-driven batched execution with unified spec + quality review, prompt templates, supporting refs).
- Replace dex-based persistence with file-based persistence so contributors who use the official `superpowers:*` plugin can collaborate against the same on-disk artifacts.
- Match the directory and naming convention the official `superpowers:writing-plans` skill already produces, so spec and plan files are interoperable.

## Non-goals

- Aligning content with the official `superpowers:*` skills. Where dex-superpowers diverges from official superpowers in process or wording, file-superpowers keeps the dex-superpowers version.
- Maintaining backwards compatibility with dex. The new skill makes no reference to dex.
- Producing a thin wrapper. file-superpowers ships its own copies of all phase docs and supporting refs; it does not defer to other skills mid-workflow.

## Skill identity

- Name: `file-superpowers`
- Location in this repo: `file-superpowers/` (root-level, peer to `dex-superpowers/`)
- Sync target: `~/.claude/skills/file-superpowers/` on each machine
- Entry point: `SKILL.md` (phase router)

## Persistence model

### Spec files

- Path: `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`
- One spec per feature.
- Contents: the validated design produced by the brainstorming skill — architecture, components, data flow, error handling approach, testing strategy.
- Lifecycle: written once during Phase 4 of brainstorming. Read-only thereafter. Subagents read it on demand by path when they need design context for a task.

### Plan files

- Path: `docs/superpowers/plans/YYYY-MM-DD-<topic>-plan.md`
- One plan per feature.
- Contents: the implementation breakdown into tasks. Single source of truth for "what work exists" and "what's done".
- Lifecycle: written once during Phase 4 of brainstorming. Mutated during execution: implementer subagents flip checkboxes and append `### Result` sub-sections to their own task; the orchestrator may edit other portions if requirements change mid-flight.

### Spec-to-plan link

The plan file links back to the spec via a top-level pointer line, immediately under the title:

```
# <Topic> — Implementation Plan

Spec: docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md
```

Subagents are given both paths but read the spec only on demand; the plan task excerpt should be self-sufficient for implementation.

### Plan file structure

```
# <Topic> — Implementation Plan

Spec: docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md

## Task 1: <title>
- [ ] Status

### Scope
What this task does and doesn't cover.

### Approach
How to implement it. Key decisions, design rationale, anything the implementer
needs in order to execute without re-reading the whole spec.

### Files
- path/to/file/a.ts (new)
- path/to/file/b.ts (modify)
- path/to/file/a.test.ts (new)

### Done criteria
- Unit tests pass
- <observable behavior>

## Task 2: <title>
- [ ] Status
Depends on: Task 1

### Scope
...
```

Per-task elements:

- Header line: `## Task N: <title>`. N is monotonically increasing within the plan.
- Status checkbox: `- [ ] Status` (binary; flips to `- [x] Status` on completion).
- Optional `Depends on:` line, only when the task depends on a non-immediately-preceding task. Sequential tasks need no `Depends on:` line.
- Four required sub-sections in fixed order: `### Scope`, `### Approach`, `### Files`, `### Done criteria`.
- After completion, an additional `### Result` sub-section is appended (see Result recording below).

Quality requirements (carried over from dex-superpowers' subtask description rules):

- No placeholders ("TBD", "TODO", "implement later", "fill in details").
- No vague instructions ("add appropriate error handling", "write tests for the above").
- No cross-references without content ("similar to Task N" — repeat what's needed).
- Exact file paths in the Files section.
- Done criteria must be observable / verifiable.

### Status and result recording

- Status is binary: `- [ ]` (pending) or `- [x]` (done). No in-progress sentinel.
- On completion, the implementer subagent appends a `### Result` sub-section to its task containing 1-3 sentences (what was implemented, key decisions, test results) ending with `Commit: <sha>`.
- Plan-file edits (checkbox flip + Result append) are amended into the task's implementation commit, so each task is exactly one commit and `git log` reads as one entry per task.

### Dependency / readiness model

- Plans are sequential by default. Tasks are dispatched top-to-bottom.
- A task may declare a non-adjacent dependency with a `Depends on: Task N[, Task M]` line.
- The orchestrator's "ready frontier" at any moment is: the unchecked tasks whose declared dependencies are all checked.
- Batching for parallel dispatch is decided at execution time from the unchecked frontier (orchestrator may group 2+ unblocked tasks for a single implementer when they share files or context).

## Skill directory layout

```
file-superpowers/
├── SKILL.md                       Phase router. Header, plan file quick reference,
│                                  routing table.
├── brainstorming.md               Phases 1-4. Phase 4 writes spec + plan files.
├── execution.md                   Subagent-driven execution. Orchestrator excerpts
│                                  task sections from the plan into subagent prompts.
├── tdd.md                         Red-green-refactor process.
├── debugging.md                   Systematic debugging process.
├── verification.md                Verification before claiming completion.
├── code-review.md                 Unified spec + quality review template.
├── finishing.md                   Branch-completion options (merge, PR, etc.).
├── parallel-dispatch.md           Multi-agent dispatch for independent tasks.
├── implementer-prompt.md          Subagent template invoked by execution.md.
├── reviewer-prompt.md             Subagent template invoked by execution.md.
├── plan-reviewer-prompt.md        Subagent template invoked by brainstorming.md.
├── root-cause-tracing.md          Backward call-stack tracing technique.
├── defense-in-depth.md            Multi-layer validation pattern.
└── condition-based-waiting.md     Replace timeouts with condition polling.
```

All fifteen files live in the same directory. Cross-references between phase docs use relative names (e.g., `tdd.md`, `root-cause-tracing.md`); none use absolute paths.

## Per-file design

### SKILL.md (new authoring)

- Header naming the skill, stating that specs live at `docs/superpowers/specs/` and plans at `docs/superpowers/plans/`, and that tasks are checkbox-tracked sections inside the plan file.
- `<HARD-GATE>` directing the agent to read the relevant phase doc before acting.
- "Plan File Quick Reference" code block showing the shape of a plan file and a single task section.
- Phase routing table with the same eight rows as dex-superpowers (brainstorming → execution → tdd → debugging → verification → code-review → finishing → parallel-dispatch).
- "Supporting References" table listing the six on-demand refs (root-cause-tracing, defense-in-depth, condition-based-waiting, implementer-prompt, reviewer-prompt, plan-reviewer-prompt).

No mention of dex anywhere.

### brainstorming.md (Phase 4 rewrite; Phases 1-3 verbatim)

Phases 1-3 (Domain Interview, Design, Implementation Choices) carry over verbatim from dex-superpowers. They concern the conversation, not persistence.

Phase 4 (Decomposition) is rewritten:

```
Phase 4 — Decomposition
  ├── 4a. Write spec file
  ├── 4b. Write plan file
  ├── 4c. Plan review (subagent)
  ├── 4d. User reviews plan
  └── Gate: user approves → load execution.md
```

- **4a. Write spec file.** Save the validated design to `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`. Spec contents = architecture, components, data flow, error handling, testing strategy. Commit.
- **4b. Write plan file.** Create `docs/superpowers/plans/YYYY-MM-DD-<topic>-plan.md` following the structure above. Apply the quality requirements. Commit.
- **4c. Plan review (subagent).** Dispatch a reviewer using `plan-reviewer-prompt.md`, passing the plan file path and spec file path. Reviewer reads both files in full. Fix any issues found. No re-review (the user gate follows immediately).
- **4d. User reviews plan.** Prompt:
  > "Plan written and committed to `<path>`. Please review it and let me know if you want to make any changes before we move to execution."

  Wait for approval. On approval, load `execution.md`.

### execution.md (substantial rewrite of setup and per-batch flow)

Setup section is rewritten to read the plan file once into orchestrator context, identify the unchecked frontier (tasks whose declared deps are all checked), and group into batches.

Per-batch flow:

```
1. Record base SHA: git rev-parse HEAD
2. Excerpt: copy each task section verbatim from the plan file —
   header line, checkbox, optional Depends on: line, and all four sub-sections.
   Stop at the next "## Task" heading. This is the <task-spec> block.
3. Dispatch implementer subagent (implementer-prompt.md) with:
   - <task-spec> block(s) pasted in
   - Plan file path (for checkbox + Result update only)
   - Spec file path (for design context, on demand)
   - Brief scene-setting context
4. Handle implementer status (DONE / DONE_WITH_CONCERNS / NEEDS_CONTEXT / BLOCKED)
5. Dispatch reviewer subagent (reviewer-prompt.md) with:
   - Same <task-spec> block(s)
   - Spec file path
   - Implementer's status report
   - Base SHA + head SHA (reviewer runs git diff itself)
6. If reviewer finds issues: implementer fixes, reviewer re-reviews
7. Verify checkboxes flipped + Result appended for each task in the batch
```

Context Pre-Curation principle, modified table:

| Artifact | Orchestrator reads? | Subagent reads? |
|---|---|---|
| Plan file (whole) | Yes (once, at setup) | No |
| Plan file (own task section) | Yes (to excerpt) | Only to write back checkbox + Result |
| Plan file (sibling tasks) | Read but never relayed | No — never |
| Spec file | Pointer only | On demand, by path |
| Diff | No | Yes (`git diff <base>..<head>`) |
| Codebase | No | Yes |

Plan-file inversion rationale (in the skill text): the plan-file read inverts the "point, don't read" principle for one hop because the orchestrator must control which task spec the subagent sees, to keep subagents focused on one task at a time without sibling interference.

After all batches: dispatch a final reviewer subagent over the full branch diff (cross-cutting integration review), then load `finishing.md`. Unchanged from dex-superpowers in shape.

Batching guidance, model selection, status handling, red flags, advantages: all carry over from dex-superpowers with terminology swapped (task IDs → task numbers, `dex show` → "the task spec in your prompt", `dex complete` → "checkbox flip + Result append").

### implementer-prompt.md (rewrite)

Sections (in order):

1. Header explaining the role and that the task spec(s) below are the authoritative scope.
2. **Required reading**: absolute paths to `tdd.md`, `verification.md`, optionally `condition-based-waiting.md`.
3. **Your task(s)**: a `<task-spec>` block where the orchestrator pastes one or more verbatim `## Task N` sections from the plan.
4. **Plan file (for status update only)**: plan file path. Instructions: after implementing/testing/committing, open the plan file, locate the task by header, flip `- [ ] Status` to `- [x] Status`, append a `### Result` sub-section (1-3 sentences ending with `Commit: <sha>`), amend the plan changes into the task implementation commit (`git add <plan>; git commit --amend --no-edit`), do NOT read or modify any other task section.
5. **Spec file (design context, on demand)**: spec file path. Read only when the task spec references something whose design context is needed.
6. **Scene-setting**: orchestrator pastes a brief paragraph.
7. **Status reporting**: must report DONE / DONE_WITH_CONCERNS / NEEDS_CONTEXT / BLOCKED with summary, test results, self-review notes, commit SHA(s).
8. **Process**: follow TDD per `tdd.md`; verify per `verification.md` before reporting DONE.

### reviewer-prompt.md (rewrite)

Sections:

1. Header explaining unified spec + quality review against the task spec(s) and the diff.
2. **Required reading**: absolute path to `code-review.md`.
3. **Task(s) under review**: `<task-spec>` block (orchestrator pastes the same sections given to the implementer).
4. **Spec file (design context, on demand)**: spec file path. Same on-demand rule.
5. **Implementer's status report**: orchestrator pastes verbatim.
6. **Diff to review**: instruction to run `git diff <base-sha>..<head-sha>`. Base and head SHAs supplied.
7. **Output format**: per-task spec compliance (✅/⚠️/❌ with findings), code quality (✅/⚠️/❌), assessment (Approved / Approved with fixes / Needs rework), per-issue severity + location + fix.

Explicit instruction: do NOT read the plan file beyond the task excerpt provided.

### plan-reviewer-prompt.md (rewrite)

Sections:

1. Header explaining the role: review a freshly written implementation plan against its spec.
2. **Required reading**: absolute path to `brainstorming.md` (Phase 4 quality requirements).
3. **Files to review**: plan file path, spec file path. Read both completely (this is plan review, not task review — siblings are the point).
4. **Per-task checks**: header line includes checkbox and optional `Depends on:`; all four sub-sections present and non-empty; no placeholders; no vague instructions; no cross-references without content; exact file paths; done criteria observable.
5. **Cross-plan checks**: tasks collectively cover the spec; no task overlaps another's scope; dependencies form a DAG (no cycles); decomposition sizing reasonable.
6. **Output**: per-task findings, cross-plan findings, overall Approved / Needs revision.

### code-review.md (targeted edit)

Three small replacements; rest of file copied verbatim:

- Line 39: `Dex task description (`dex show <id> --full`)` → `The verbatim task section from the plan file (header through Done criteria sub-section)`.
- Line 53: `[Just completed dex task abc123: ...]` → `[Just completed Task 5: ...]`.
- Line 62: `PLAN_OR_REQUIREMENTS: dex task abc123` → `PLAN_OR_REQUIREMENTS: <pasted Task 5 section from docs/superpowers/plans/<plan>.md>`.

### Files copied verbatim

These have no dex references and require no edits:

- `tdd.md`
- `debugging.md`
- `verification.md`
- `finishing.md`
- `parallel-dispatch.md`
- `root-cause-tracing.md`
- `defense-in-depth.md`
- `condition-based-waiting.md`

## Data flow

End-to-end happy path:

```
User idea
    │
    ▼
brainstorming.md  Phases 1-3: domain → design → implementation choices
    │
    ▼
brainstorming.md  Phase 4a:   write docs/superpowers/specs/<topic>-design.md
brainstorming.md  Phase 4b:   write docs/superpowers/plans/<topic>-plan.md
brainstorming.md  Phase 4c:   plan-reviewer-prompt.md (subagent reads both files)
brainstorming.md  Phase 4d:   user approves plan
    │
    ▼
execution.md      Setup:      orchestrator reads plan file once
execution.md      Per batch:  excerpt task section(s) → implementer-prompt.md
                              implementer flips checkbox, appends Result, amends commit
                              reviewer-prompt.md reviews diff against task excerpt
execution.md      Final:      reviewer-prompt.md over full branch diff
    │
    ▼
finishing.md      Branch completion options
```

Phase docs `tdd.md`, `debugging.md`, `verification.md`, `code-review.md`, `parallel-dispatch.md` are loaded on demand by the implementer/reviewer subagents (per their required-reading sections) or directly by the user when working in those modes.

## Error handling

- **Task spec missing a sub-section**: caught in plan review (4c) before execution begins. If discovered during execution, the implementer reports `BLOCKED` with the missing section identified; the orchestrator edits the plan file to add it, then re-dispatches.
- **Implementer modifies sibling task section**: the orchestrator's batch-completion sanity check (step 7 of per-batch flow) reads the plan file and verifies only the dispatched task(s) flipped checkboxes and gained Result sub-sections. Unauthorized edits surface as a verification failure; the orchestrator reverts and re-dispatches with a stronger reminder.
- **Plan and spec drift**: if execution surfaces a design question not answered by the spec, the orchestrator pauses execution and re-enters brainstorming Phase 1 or Phase 2 (per the back-transition rules already in brainstorming.md), updates the spec, then resumes.
- **Reviewer finds spec compliance failure**: implementer fixes, reviewer re-reviews (existing dex-superpowers loop, unchanged).

## Testing strategy

Skill correctness is exercised by using the skill on a small real feature end-to-end. No automated tests; the skill is markdown read by an agent. Validation criteria:

- The agent can route from any phase doc back to SKILL.md and from SKILL.md to any phase doc using only the routing table.
- An implementer subagent given a `<task-spec>` block + plan path + spec path can complete a task without ever reading the plan beyond its own section.
- A reviewer subagent given a `<task-spec>` block + base/head SHAs produces a verdict without reading the plan or spec unless the task spec references something needing design context.
- A plan-reviewer subagent given a plan file + spec file flags missing sub-sections, vague instructions, and decomposition issues.

## Open questions

None at design time. The implementation plan will surface tactical questions (e.g., exact wording in SKILL.md's quick reference); those are decided during writing-plans, not now.
