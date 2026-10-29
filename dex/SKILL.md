---
name: dex
description: >
  Decompose multi-step engineering work into dex epics, tasks, and dependency
  DAGs, and execute or orchestrate dex task trees. TRIGGER when the user
  invokes `dex` or asks to plan, decompose, track, or execute tasks in `dex`.
  SKIP single-step tasks, Linear issue management, and routine implementation
  when `dex` is not in use.
---

# Task Decomposition and Execution with `dex`

`dex` is a persistent local task tracker (stored in `.dex/` or `~/.dex-data/<project>/`). Treat `dex` tasks as self-contained tickets rather than bare todo items: an agent picking up a task in a fresh session must understand what to build, why, which files and contracts it owns, and how to verify completion from `dex show <id> --full` alone.

Never reference `dex` task IDs (`abc123`) in git commit messages, pull request bodies, or repository documentation; `dex` IDs are ephemeral local state.

## Right-size the hierarchy

Choose the lightest structure that fits the scope (`dex` enforces a maximum depth of 3 levels: `Epic -> Task -> Subtask`):

| Scope | Structure |
|---|---|
| **Small change** (1 to 2 files, single cohesive concern) | Single `dex` task (or skip `dex` if completed immediately in one turn) |
| **Medium feature** (3 to 7 distinct implementation steps across several files or layers) | Parent task (spec-altitude design) with 3 to 7 subtasks |
| **Large initiative** (5+ independent workstreams or multi-session phases) | Epic (spec-altitude design) -> Tasks -> Subtasks |

Keep 3 to 7 children per parent. Do not create 1-line micro-tasks or split tightly coupled changes that must compile and pass tests together.

## Write epics and parent tasks at spec altitude

When creating an epic or parent task (`dex create "<Title>" --description "..."`), write its description as the authoritative architectural contract for all child tasks:

- **Outcome and surfaces:** State the delivered user- or consumer-visible behaviour and why it exists.
- **Exact contract and schema shapes:** Include abridged `diff` or schema blocks for new or modified RPCs, API payloads, database tables/columns, or persisted events so child tasks share exact field and method names.
- **Component ownership and flow:** State which package or service owns each invariant and how data or control moves across boundaries.
- **Settled requirements vs. open decisions:** Separate committed requirements from open questions. Resolve open questions with the user before decomposing dependent subtasks.

Use action-oriented titles that name the delivered capability (`Add webhook signature verification`), not the planning phase (`Define webhook verification`).

## Cut subtask boundaries and dependency DAGs

Slice subtasks so they partition responsibility cleanly, sequence foundational contracts first, and maximize safe parallel execution:

1. **Cut by ownership and file locality:** Assign each subtask a distinct module, layer, or vertical slice with minimal file overlap against sibling tasks. When two steps mutate the same function or file and cannot be tested independently, keep them in one task.
2. **Make every subtask self-contained:** Include four explicit sections in every subtask description:
   - **Scope:** What this task delivers and what it explicitly leaves to siblings.
   - **Approach and contracts:** Key types, signatures, edge cases, and architectural constraints. Never write `TBD`, `add appropriate error handling`, or `similar to Task X`.
   - **Files:** Exact file paths to create or modify, plus test expectations (subject to the `testing` skill's admission criteria).
   - **Done criteria:** Observable behaviour and narrow verification commands.
3. **Wire minimal, true blockers (`dex edit <id> --add-blocker <blocker-id>`):** Add a blocker only when a task genuinely depends on types, schemas, interfaces, or behaviour produced by another task. Do not chain tasks into a false linear sequence (`1 -> 2 -> 3 -> 4`) when tasks `2`, `3`, and `4` only depend on foundation task `1`:

```text
          ┌──▶ Task B: Backend handler & store (touches internal/api/) ──┐
Task A: ──┼──▶ Task C: Worker consumer (touches internal/worker/)       ──┼──▶ Task E: End-to-end wiring
Proto/DB  └──▶ Task D: UI surface (touches src/features/)               ──┘
```

Before starting execution on a complex tree, audit the decomposition across four checks (or delegate the audit to a fresh reviewer subagent):
- **Dependency accuracy:** Every `--add-blocker` reflects a real build, type, or data dependency; no missing blockers and no false serialization.
- **Zero unresolved design forks:** No subtask punts an architectural or library choice to the implementer.
- **Non-overlapping granularity:** Sibling tasks that can run concurrently do not contend on the same files.
- **Full coverage:** Every contract, migration, and behaviour in the parent epic is owned by a task.

## Execute the task tree

### Solo execution

1. Run `dex list --ready` to find unblocked tasks and `dex show <id> --full` (plus `dex show <parent-id> --full` if needed) to load context.
2. Mark the task active with `dex start <id>`.
3. Load `testing` (if available) before behavioural or test edits, implement the scoped change, and run narrow verification for the touched packages.
4. Commit the change (without `dex` IDs in the commit message) and record completion immediately:
   ```bash
   dex complete <id> --result "Implemented X, verified via Y" --commit <sha>
   ```

### Subagent-orchestrated execution (batched or parallel)

When orchestrating subagents across a `dex` tree (see [references/subagent-prompts.md](references/subagent-prompts.md) for dispatch templates):

- **Point, do not relay:** Pass subagents the `dex` task ID(s), parent ID, and git base SHA. Let subagents run `dex show <id> --full` and `git diff` in their own context instead of reading full task descriptions and diffs into the coordinator's context.
- **Batch co-located tasks:** Group 2 to 4 currently unblocked tasks into a single implementer dispatch when they touch the same files or immediate package.
- **Parallelize independent tasks:** When unblocked tasks touch disjoint packages or subsystems, dispatch them concurrently (using separate git worktrees when parallel implementers edit tracked files).
- **Select model tier by judgment required:** Use a fast/throughput model when the task description specifies exact signatures and mechanical changes; use a balanced/general model for standard implementation; use a high-reasoning model when integration judgment or cross-cutting review is required.
- **Verify and complete per batch:** Review the batch diff `<base-sha>..<head-sha>` against `dex show <id> --full` (using `review-findings` if available when issues are surfaced), then run `dex complete <id> --result "..." --commit <sha>`.

## CLI quick reference

```bash
# Create epic or parent task
dex create "Title" --description "Spec-altitude design..."

# Create child task and wire dependency
dex create --parent <parent-id> "Subtask title" --description "Scope / Approach / Files / Done criteria"
dex edit <task-id> --add-blocker <blocker-id>

# Inspect tree and ready frontier
dex list --ready
dex show <epic-id> --expand
dex show <task-id> --full

# Execute and complete
dex start <task-id>
dex complete <task-id> --result "Summary of changes, decisions, and verification" --commit <sha>
dex complete <plan-only-task-id> --result "Design settled" --no-commit
```
