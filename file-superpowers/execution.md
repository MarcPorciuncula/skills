# Subagent-Driven Execution

Execute the tasks in a plan file by dispatching subagents, with a unified review after each batch.

**Why subagents:** You delegate tasks to specialized agents with isolated context. By precisely crafting their instructions and context, you ensure they stay focused and succeed at their task. They should never inherit your session's context or history — you construct exactly what they need. This also preserves your own context for coordination work.

**Subagent preparation:** Subagents do not inherit your skills or session context. Every subagent prompt you construct MUST include an instruction to read the relevant skill files from this directory before starting work. At minimum, implementer subagents must read `tdd.md`. Include the absolute path to this skill directory in the prompt so the subagent can find the files. See `implementer-prompt.md` for the required prep section.

**Core principle:** Batch related tasks → single implementer → unified review (spec + quality in one pass) = high quality, less overhead

## Setup

Before dispatching any subagent:

1. **Read the plan file once.** The upstream phase (brainstorming Phase 4d) hands you the plan file path. Read the file in full into your context. This is the only time you read the whole plan; everything afterward is excerpting.
2. **Identify the unchecked frontier.** Scan the plan top-to-bottom for tasks whose `- [ ] Status` is unchecked AND whose declared `Depends on:` dependencies (if any) are all checked. Tasks without a `Depends on:` line are sequential — they become ready as the preceding task is checked.
3. **Group unchecked frontier tasks into batches** (see Batching below).
4. **Record the plan file path.** Pass it to every subagent you dispatch — implementers need it to flip the checkbox and append `### Result`; reviewers do not (they should not read the plan).

**Don't re-read full task descriptions into your own context after the initial scan** — when you dispatch, you'll excerpt the relevant task section(s) from the plan file directly into the subagent prompt. Treat the in-memory copy you built at setup as a map, not a payload to relay.

## Per-Batch Flow

For each batch, in order:

1. **Mark in-progress.** No-op for binary checkboxes — tasks remain `- [ ]` until completion; there is no in-progress sentinel. The plan file is unchanged at this step; in-flight status lives only in your orchestration notes.
2. **Record base SHA:** `git rev-parse HEAD` — you'll need this for the reviewer.
3. **Excerpt the task spec(s).** Copy each task section verbatim from the plan file: the `## Task N: <title>` header line, the `- [ ] Status` checkbox, the optional `Depends on:` line, and all four sub-sections (`### Scope`, `### Approach`, `### Files`, `### Done criteria`). Stop at the next `## Task` heading. Wrap the result in a `<task-spec>` block. For multi-task batches, paste each task's section in order inside the same `<task-spec>` block.
4. **Dispatch implementer subagent** using the template in `implementer-prompt.md` with:
   - The `<task-spec>` block(s) pasted in (the authoritative scope)
   - The plan file path (for checkbox flip + Result append only)
   - The spec file path (for design context, on demand)
   - Brief scene-setting context about where these tasks fit in the broader feature
5. **Handle implementer status** (DONE / DONE_WITH_CONCERNS / NEEDS_CONTEXT / BLOCKED — see "Handling Implementer Status" below).
6. **Dispatch reviewer subagent** using `reviewer-prompt.md` with:
   - The same `<task-spec>` block(s) given to the implementer
   - The spec file path
   - The implementer's status report (verbatim)
   - Base SHA (from step 2) and head SHA (current HEAD after the implementer committed)
   - The reviewer runs `git diff <base>..<head>` itself — do NOT read the diff into your own context
7. **Loop and verify.** If the reviewer finds issues: re-dispatch the implementer to fix, then re-dispatch the reviewer. Once approved, verify the plan file: each task in the batch has its checkbox flipped to `- [x]` and a `### Result` sub-section appended. The implementer was instructed to do this — this step is a sanity check. If something is missing or a sibling task was touched, revert and re-dispatch with a stronger reminder.

## Context Pre-Curation

**Your job as orchestrator is to point, not to read** — with one inversion: at the implementer hop you pre-read each task's section from the plan file and paste it verbatim into the subagent prompt. This keeps subagents focused on one task at a time without sibling-task interference. The rest of the discipline holds: do not read diffs, file contents, test output, or codebase into your own context to relay to subagents.

| Artifact                    | Orchestrator reads?         | Subagent reads?                            |
|-----------------------------|-----------------------------|--------------------------------------------|
| Plan file (whole)           | Yes (once, at setup)        | No                                         |
| Plan file (own task section)| Yes (to excerpt)            | Only to write back checkbox + Result       |
| Plan file (sibling tasks)   | Read but never relayed      | No — never                                 |
| Spec file                   | Pointer only                | On demand, by path                         |
| Diff                        | No                          | Yes (`git diff <base>..<head>`)            |
| Codebase                    | No                          | Yes                                        |

The plan-file inversion exists because the orchestrator must control which task spec the subagent sees. Letting a subagent read the plan file directly would expose siblings and invite scope creep; pre-curating the excerpt enforces the one-task-at-a-time boundary. Every other artifact follows the standard rule — the subagent has the tools to read what it needs, so give it pointers, not payloads.

## Batching

Group related tasks into batches to reduce subagent overhead. Each batch goes to a single implementer, then a single reviewer.

**Batch together** tasks that:
- Are all currently on the unchecked frontier (no pending dependencies)
- Touch the same files or closely related files
- Share enough context that one subagent can reason about them together

**Keep separate** tasks that:
- Touch unrelated parts of the codebase
- Have dependencies between them (one must complete and be checked off before the other can start)
- Are individually complex enough to warrant a full subagent's attention

**A batch of one is fine.** Complex or isolated tasks should be their own batch. Batching is an optimization for groups of related small tasks, not a requirement for every task.

**Sizing guidance:**
- 2-4 related tasks touching shared files → good batch
- 5+ tasks or tasks spanning many unrelated files → too large, split
- Single complex task → own batch

## Model Selection

You pick the subagent's model when you build the dispatch. Pick deliberately — the dispatch templates have a `model:` line and you fill it in before issuing the Agent call. Subagents do not pick their own model.

The plan you produced via `brainstorming.md` already does the hard reasoning upfront, so most implementer and reviewer dispatches do not need the highest tier.

| Tier | Use for | Signals |
|------|---------|---------|
| Fast | Mechanical, well-specced changes | Renames, mechanical refactors, single-file edits with a complete spec, glue/wiring, test scaffolding the spec describes line-by-line |
| General-purpose | **Default** for implementer and per-batch reviewer | Multi-file work where the spec already named the files and approach; routine code review of a focused diff |
| High-reasoning | Reasoning-heavy work | Plan review, final cross-cutting review, debugging across subsystems, tasks where the spec leaves design judgment, escalation after a General-purpose BLOCKED |

**Default to General-purpose.** Drop to Fast only when the task is mechanical and the spec is exhaustive. Use High-reasoning when the routing signals call for it or as an escalation tier.

**Mapping to concrete models.** These tiers are model-agnostic. For Anthropic, the families map as Fast → Haiku, General-purpose → Sonnet, High-reasoning → Opus — substitute the concrete model identifier your runtime accepts (e.g. the CLI shorthand `haiku` / `sonnet` / `opus`, or the latest `claude-*` ID). For other providers, map each tier to that provider's equivalent capability class.

**Routing heuristic** when the task doesn't obviously match the table:

| Heuristic | Route to |
|---|---|
| Spec names exact files, exact function signatures, no decisions deferred | Fast |
| Spec names files but the approach is described, not prescribed | General-purpose |
| Spec leaves design judgment, OR task spans 4+ files with integration concerns, OR a lower tier already returned BLOCKED on this task | High-reasoning |

## Handling Implementer Status

Implementer subagents report one of four statuses. Handle each appropriately:

**DONE:** Proceed to review.

**DONE_WITH_CONCERNS:** The implementer completed the work but flagged doubts. Read the concerns before proceeding. If the concerns are about correctness or scope, address them before review. If they're observations (e.g., "this file is getting large"), note them and proceed to review.

**NEEDS_CONTEXT:** The implementer needs information that wasn't provided. Provide the missing context and re-dispatch.

**BLOCKED:** The implementer cannot complete the task. Assess the blocker:
1. If it's a context problem, provide more context and re-dispatch with the same model
2. If the blocker is reasoning (not missing context), re-dispatch one tier up: Fast → General-purpose → High-reasoning. Don't skip tiers. If General-purpose also returns BLOCKED, the spec is probably the problem, not the model
3. If the task is too large, break it into smaller pieces
4. If the task description itself is wrong, escalate to the human (and edit the plan file's task section to correct it before re-dispatching)

**Never** ignore an escalation or force the same model to retry without changes. If the implementer said it's stuck, something needs to change.

## After All Tasks

The end-of-workflow has three distinct roles, in order. Each does one job — don't conflate them.

| Role | What it does | Reads | Runs |
|---|---|---|---|
| Final cross-cutting reviewer | Reads integrated diff, judges integration and quality | Diff | Nothing |
| Adversarial verifier | Probes for breakage in the integrated diff at proportional scope | Diff | Targeted, justified checks |
| CI (on PR open) | Unbounded sweep | Everything | Everything |

1. **Dispatch final cross-cutting reviewer** for the entire implementation (full diff from branch point). Catches integration issues between tasks that per-batch reviews can't see. Use the `reviewer-prompt.md` template with the full branch diff range. For the `<task-spec>` block, paste a brief summary of the tasks completed (or the plan file's headers list); the reviewer's job here is integration, not per-task spec compliance, which the per-batch reviews already covered.
2. **Address any issues** from the cross-cutting review.
3. **Dispatch adversarial verifier** against the integrated branch diff. This is a *targeted, proportional* probe for breakage — the bridge between per-task verification (correctly narrow) and CI (correctly unbounded). Use `adversarial-prompt.md` with the same base/head SHAs and a brief summary of the work. The verifier reads the diff, identifies high-yield places where a fault would surface, and runs justified checks within the change's blast radius. It does NOT re-run the repo-wide suite — CI handles that on PR open.
4. **Address any breakage** the adversarial pass found. Re-dispatch implementer to fix; re-run the adversarial pass against the new HEAD.
5. **Load `finishing.md`** to complete the branch.

## Example Workflow

```
You: I'm executing the plan at docs/superpowers/plans/2026-04-27-widget-pipeline-plan.md.

[Read the plan file once. Identify the unchecked frontier:
  Task 1, Task 2, Task 3 unchecked, no Depends on: lines → all sequential.
  Task 4 unchecked, Depends on: Task 1.
  Task 5 unchecked, Depends on: Task 4.
  Frontier today: Task 1, Task 2, Task 3 (sequentially) and Task 4 once Task 1 ships.]

Batch 1: Tasks 1 + 2 (both touch the widget loader, share files)
[Skip Task 3 from this batch — it touches the unrelated reporting module.]

[Mark in-progress: no-op; checkboxes stay - [ ].]
[Record base SHA: a1b2c3d]

[Excerpt Task 1 and Task 2 sections verbatim from the plan file
 into a single <task-spec> block.]

[Dispatch implementer subagent with:
   - <task-spec> block (Tasks 1 + 2)
   - Plan file: docs/superpowers/plans/2026-04-27-widget-pipeline-plan.md
   - Spec file: docs/superpowers/specs/2026-04-27-widget-pipeline-design.md
   - Scene-setting: "These two tasks bootstrap the widget loader. Task 1 adds
     the loader module; Task 2 wires it into the existing registry."]

Implementer: "Before I begin — should the loader fall back to the legacy
              path when the new manifest is missing, or hard-fail?"

You: "Hard-fail. The migration plan ships the manifest before the loader."

Implementer:
  Status: DONE
  - Task 1: Added widget-loader module, 8/8 tests passing
  - Task 2: Wired loader into registry, 4/4 tests passing
  - Self-review: clean
  - Plan file updated: Task 1 + Task 2 checkboxes flipped, Result appended
  - Committed and amended as f4e5d6c

[Dispatch reviewer subagent with:
   - Same <task-spec> block (Tasks 1 + 2)
   - Spec file path
   - Implementer's status report
   - Base SHA: a1b2c3d, Head SHA: f4e5d6c]

Reviewer:
  Spec compliance:
    Task 1: ✅ Loader module matches spec
    Task 2: ⚠️ Registry wiring works but uses a magic number (100) for
            the progress-report interval
  Code quality: ⚠️ Approved with fixes
  Assessment: Approved with fixes

[Re-dispatch implementer to fix: extract PROGRESS_INTERVAL constant.]
[Implementer fixes, amends into the same commit as g7h8i9j.]

[Re-dispatch reviewer]
Reviewer: ✅ Approved

[Sanity-check the plan file: Task 1 and Task 2 each show - [x] Status and a
 ### Result sub-section ending with "Commit: g7h8i9j". No sibling tasks
 modified. Pass.]

Batch 2: Task 3 (own batch — unrelated reporting module)

[Record base SHA: g7h8i9j]
[Excerpt Task 3 section verbatim into a <task-spec> block.]
[Dispatch implementer subagent with the Task 3 excerpt + plan path + spec path.]

...

[After all batches]
[Dispatch final cross-cutting reviewer for the full branch diff (a1b2c3d..HEAD)]
Final reviewer: ✅ Approved — integration is clean

[Dispatch adversarial verifier with the same diff range + brief work summary]
Adversarial verifier:
  Probes run:
    - `pnpm test pkg/widget` — touched in Task 1+2 — 8/8 pass
    - `pnpm test pkg/registry` — wired in Task 2 — 4/4 pass
    - `pnpm test pkg/reporting` — touched in Task 3 — 6/6 pass
    - typecheck on pkg/widget, pkg/registry, pkg/reporting — clean
    - manual: empty-manifest path (Task 1 changed fallback behavior) — hard-fails as specified
  Coverage note: did not run pkg/cli or pkg/storage — diff doesn't touch their public
    contracts or known callers. CI will sweep those.
  ✅ Clean — no breakage found within proportional scope

[Load finishing.md]
```

## Red Flags

**Never:**
- Start implementation on main/master branch without explicit user consent
- Skip review for any batch
- Proceed with unfixed issues
- Hand subagents more of the plan file than the task(s) in the current batch (they'll wander — siblings are intentionally hidden)
- Skip scene-setting context (subagent needs to understand where the task fits)
- Ignore subagent questions (answer before letting them proceed)
- Accept "close enough" on spec compliance (reviewer found spec issues = not done)
- Skip review loops (reviewer found issues = implementer fixes = review again)
- Let implementer self-review replace actual review (both are needed)
- Move to next batch while review has open issues
- Read diffs or file contents into your own context to relay to subagents (point, don't read)
- Flip checkboxes or write `### Result` sub-sections yourself — the implementer does that as part of its commit so each task is exactly one commit

**If subagent asks questions:**
- Answer clearly and completely
- Provide additional context if needed
- Don't rush them into implementation

**If reviewer finds issues:**
- Implementer (re-dispatched) fixes them
- Reviewer reviews again
- Repeat until approved
- Don't skip the re-review

**If subagent fails task:**
- Re-dispatch with corrected context, a more capable model, or a smaller task scope
- Don't try to fix manually (context pollution)
- If the task spec itself is wrong, edit the plan file's task section before re-dispatching

## Advantages

**vs. Manual execution:**
- Subagents follow TDD naturally
- Fresh context per batch (no confusion)
- Parallel-safe (subagents don't interfere)
- Subagent can ask questions (before AND during work)

**Efficiency gains:**
- Batching reduces cold-start overhead for related tasks
- Unified review (spec + quality) eliminates redundant codebase exploration
- Reviewer starts from `git diff` — focused on the delta, not exploring the repo
- Subagents work from the pasted task excerpt — no plan-file re-reading, no sibling-task confusion
- Orchestrator stays lightweight: task excerpts and SHAs, not full diffs and file contents
- Questions surfaced before work begins (not after)

**Quality gates:**
- Self-review catches issues before handoff
- Unified review checks both spec compliance and code quality
- Review loops ensure fixes actually work
- Spec compliance prevents over/under-building
- Final cross-cutting review catches integration issues between batches
- The plan file's checkbox + `### Result` history is a single source of truth for "what's done", recoverable from `git log` even if the orchestration session is lost
