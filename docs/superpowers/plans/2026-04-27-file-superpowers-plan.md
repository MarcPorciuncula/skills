# file-superpowers — Implementation Plan

Spec: docs/superpowers/specs/2026-04-27-file-superpowers-design.md

## Task 1: Bootstrap directory and copy dex-free phase docs
- [x] Status

### Scope
Create the `file-superpowers/` directory at the repo root and populate it with the eight files that need no content changes from `dex-superpowers/`. Apply the targeted three-line edit to `code-review.md` and place it alongside.

Does NOT include: `SKILL.md`, `brainstorming.md`, `execution.md`, `implementer-prompt.md`, `reviewer-prompt.md`, `plan-reviewer-prompt.md` — those are authored in subsequent tasks.

### Approach
1. Create directory `file-superpowers/` at the repo root (sibling of `dex-superpowers/`).
2. Copy these eight files from `dex-superpowers/` to `file-superpowers/` byte-for-byte (use `cp`, not Read/Write, to preserve content exactly):
   - tdd.md
   - debugging.md
   - verification.md
   - finishing.md
   - parallel-dispatch.md
   - root-cause-tracing.md
   - defense-in-depth.md
   - condition-based-waiting.md
3. Copy `dex-superpowers/code-review.md` to `file-superpowers/code-review.md`, then apply three line edits:
   - Line 39: replace ``Dex task description (`dex show <id> --full`)`` with `The verbatim task section from the plan file (header through Done criteria sub-section)`
   - Line 53: replace `[Just completed dex task abc123: Add verification function]` with `[Just completed Task 5: Add verification function]`
   - Line 62: replace `PLAN_OR_REQUIREMENTS: dex task abc123` with `PLAN_OR_REQUIREMENTS: <pasted Task 5 section from docs/superpowers/plans/<plan>.md>`
4. After edits, grep for any remaining "dex" references in `file-superpowers/code-review.md` — there should be none.

### Files
- file-superpowers/tdd.md (new, byte-identical copy of dex-superpowers/tdd.md)
- file-superpowers/debugging.md (new, byte-identical copy)
- file-superpowers/verification.md (new, byte-identical copy)
- file-superpowers/finishing.md (new, byte-identical copy)
- file-superpowers/parallel-dispatch.md (new, byte-identical copy)
- file-superpowers/root-cause-tracing.md (new, byte-identical copy)
- file-superpowers/defense-in-depth.md (new, byte-identical copy)
- file-superpowers/condition-based-waiting.md (new, byte-identical copy)
- file-superpowers/code-review.md (new, copy of dex-superpowers/code-review.md with three-line edit)

### Done criteria
- All nine files exist in `file-superpowers/`
- `diff dex-superpowers/<file> file-superpowers/<file>` returns no output for each of the eight verbatim files
- `grep -i dex file-superpowers/code-review.md` returns no matches
- `git diff --no-index dex-superpowers/code-review.md file-superpowers/code-review.md` shows exactly the three-line replacement specified above

### Result
Created `file-superpowers/` with the eight verbatim phase doc copies (each `diff` clean against its `dex-superpowers/` source) and `code-review.md` with the three specified line replacements (`git diff --no-index` shows exactly those three substitutions). Note: `grep -i dex` on the resulting `code-review.md` returns two false-positive matches against the substring "index" inside `conversation index` / `verifyIndex()` / `repairIndex()` — these are example-payload lines that exist verbatim in the source and are not real dex references; rewording them was outside the task spec's scope. Commit: 2578b4e

## Task 2: Author SKILL.md
- [x] Status

### Scope
Create `file-superpowers/SKILL.md` from scratch as the phase router. The file must read as standalone — no references to dex anywhere.

### Approach
Section structure (in order):

1. **Frontmatter block** — match the format of `dex-superpowers/SKILL.md`'s frontmatter (`---name: ... description: ... ---`). Description should reflect file-based persistence (specs at `docs/superpowers/specs/`, plans at `docs/superpowers/plans/`, checkbox-tracked tasks).

2. **Title and intro paragraph** — title `# file-superpowers`, then a one-line description: "Unified development workflow skill. Each phase has its own document — read the right one before acting."

3. **Persistence model paragraph** — exactly: "Specs live at `docs/superpowers/specs/`. Plans live at `docs/superpowers/plans/`. Tasks are checkbox-tracked sections inside the plan file. Progress is recorded by flipping a task's checkbox and appending a `### Result` sub-section, both amended into the task's implementation commit."

4. **`<HARD-GATE>` block** — mirror the dex-superpowers wording: "Read the sub-document for your current phase before taking action. Do not proceed from memory of what a workflow skill used to say — read the current document in this directory."

5. **Phase Routing section** — a markdown table with two columns (`You are about to...` | `Read this first`) and exactly these eight rows:
   | You are about to... | Read this first |
   |---------------------|-----------------|
   | Start new feature work, explore requirements, design something | `brainstorming.md` |
   | Execute tasks with subagents | `execution.md` |
   | Write or run tests (TDD red-green-refactor) | `tdd.md` |
   | Debug a bug, test failure, or unexpected behavior | `debugging.md` |
   | Claim work is done, commit, create a PR | `verification.md` |
   | Request or receive code review | `code-review.md` |
   | Finish a branch (all tasks complete, ready to merge/PR) | `finishing.md` |
   | Work on 2+ independent tasks concurrently | `parallel-dispatch.md` |

6. **Plan File Quick Reference section** — heading `## Plan File Quick Reference`, then a markdown code block showing the shape of a plan file with title, `Spec:` link, and one example task showing the four sub-sections. Example to use:

   ```
   # <Topic> — Implementation Plan

   Spec: docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md

   ## Task 1: <title>
   - [ ] Status

   ### Scope
   What this task does and doesn't cover.

   ### Approach
   How to implement it. Key decisions, design rationale.

   ### Files
   - path/to/file/a.ts (new)
   - path/to/file/b.ts (modify)

   ### Done criteria
   - Unit tests pass
   - <observable behavior>

   ## Task 2: <title>
   - [ ] Status
   Depends on: Task 1

   ### Scope
   ...
   ```

   Follow the code block with three short bullets:
   - Tasks are sequential by default; `Depends on:` declares non-adjacent dependencies.
   - Status is binary: `- [ ]` (pending) or `- [x]` (done).
   - On completion, append a `### Result` sub-section to the task with 1-3 sentences ending in `Commit: <sha>`, then amend the plan changes into the task's implementation commit.

7. **Supporting References section** — heading `## Supporting References`, intro line "These are loaded on demand by the phase documents that reference them:", then a markdown table with two columns (`Document` | `Purpose`) and exactly these six rows:
   | Document | Purpose |
   |----------|---------|
   | `root-cause-tracing.md` | Trace bugs backward through call stack |
   | `defense-in-depth.md` | Multi-layer validation after finding root cause |
   | `condition-based-waiting.md` | Replace arbitrary timeouts with condition polling |
   | `implementer-prompt.md` | Subagent template for task implementation |
   | `reviewer-prompt.md` | Subagent template for unified spec + quality review |
   | `plan-reviewer-prompt.md` | Subagent template for plan review after task decomposition |

The file must contain no references to dex anywhere.

### Files
- file-superpowers/SKILL.md (new)

### Done criteria
- `grep -i dex file-superpowers/SKILL.md` returns no matches
- File contains all seven sections in order: frontmatter, title+intro, persistence paragraph, HARD-GATE block, Phase Routing, Plan File Quick Reference, Supporting References
- Phase Routing table has exactly 8 rows
- Supporting References table has exactly 6 rows
- Plan File Quick Reference shows at least one task with all four sub-sections (Scope, Approach, Files, Done criteria) and an example second task with a `Depends on:` line

### Result
Authored `file-superpowers/SKILL.md` from scratch with all seven sections in order (frontmatter, title+intro, persistence paragraph, HARD-GATE, Phase Routing with 8 rows, Plan File Quick Reference with the two-task example, Supporting References with 6 rows). `grep -iE '\bdex\b'` returns no matches; the file reads as standalone. Commit: 6676534

## Task 3: Author brainstorming.md
- [x] Status

### Scope
Create `file-superpowers/brainstorming.md`. Phases 1-3 carry over verbatim from `dex-superpowers/brainstorming.md`. The Phase 4 section is rewritten for file-based persistence. The phase diagram at the top of the file is updated to reflect the new Phase 4 sub-phases.

### Approach
1. Copy `dex-superpowers/brainstorming.md` to `file-superpowers/brainstorming.md` as a starting point.
2. Update the phase diagram near the top of the file. The current diagram has a Phase 4 — Decomposition entry with sub-items for "Create dex epic" and "Decompose into subtasks". Replace the Phase 4 portion with:

   ```
   Phase 4 — Decomposition
     ├── 4a. Write spec file
     ├── 4b. Write plan file
     ├── 4c. Plan review (subagent)
     ├── 4d. User reviews plan
     └── Gate: user approves → load execution.md
   ```

3. Locate and entirely replace the existing `## Phase 4 — Decomposition` section (in dex-superpowers/brainstorming.md, this section runs from "## Phase 4 — Decomposition" through to the end of the "User Review Gate" subsection, just before "## Key Principles"). Replace it with:

   ```markdown
   ## Phase 4 — Decomposition

   ### 4a. Write Spec File

   Save the validated design to `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`.

   The spec is the authoritative reference for the implementation: architecture, components, data flow, error handling approach, testing strategy. It is read-only after this phase — subagents fetch it on demand for design context, but it is not edited during execution.

   Commit the spec file.

   ### 4b. Write Plan File

   Create `docs/superpowers/plans/YYYY-MM-DD-<topic>-plan.md` with this structure:

   ```
   # <Topic> — Implementation Plan

   Spec: docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md

   ## Task 1: <title>
   - [ ] Status

   ### Scope
   What this task does and doesn't cover.

   ### Approach
   How to implement it. Key decisions, design rationale.

   ### Files
   - path/to/file/a.ts (new)
   - path/to/file/b.ts (modify)

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
   - Header line: `## Task N: <title>` where N is monotonically increasing
   - Status checkbox: `- [ ] Status` (binary; flips to `- [x] Status` on completion)
   - Optional `Depends on: Task N[, Task M]` line, only when the task depends on a non-immediately-preceding task. Sequential tasks need no `Depends on:` line.
   - Four required sub-sections in fixed order: `### Scope`, `### Approach`, `### Files`, `### Done criteria`

   Each task description must include:
   - **Scope:** What this task does and doesn't cover
   - **Approach:** How to implement it (files to create/modify, key decisions)
   - **Files:** Exact paths to create, modify, and test
   - **Done criteria:** What "complete" looks like, observable / verifiable

   Quality requirements:
   - No placeholders: no "TBD", "TODO", "implement later", "fill in details"
   - No vague instructions: no "add appropriate error handling", "write tests for the above"
   - No cross-references without content: no "similar to Task N" — repeat what's needed
   - Complete code context: if a step changes code, describe what changes
   - Exact file paths always

   Decomposition guidelines:
   - Small feature (1-2 files) → Single task
   - Medium feature (3-5 files) → 3-7 tasks
   - Large initiative (5+ independent tasks) → Plan with 5+ tasks
   - 3-7 tasks is optimal. Don't over-decompose.

   Commit the plan file.

   ### 4c. Plan Review (Subagent)

   **Do NOT self-check the plan.** The agent who built the plan sees what it intended, not what it wrote. Dispatch a reviewer subagent using `plan-reviewer-prompt.md`, passing the plan file path and spec file path. The reviewer reads both files completely.

   If the reviewer finds issues, fix them. No need to re-review after fixing — the user review gate follows immediately.

   ### 4d. User Review Gate

   After the plan review, ask the user to review the plan:

   > "Plan written and committed to `<path>`. Run `cat <path>` to review. Let me know if you want to make any changes before we move to execution."

   Wait for the user's response. If they request changes, make them and re-run the plan review subagent. Only proceed once the user approves.
   ```

4. Verify no dex references remain by greping the entire file.
5. Verify Phases 1, 2, 3 are byte-identical to the corresponding sections in dex-superpowers/brainstorming.md.

### Files
- file-superpowers/brainstorming.md (new, copy of dex-superpowers/brainstorming.md with phase diagram updated and Phase 4 section entirely replaced)

### Done criteria
- `grep -i dex file-superpowers/brainstorming.md` returns no matches
- The phase diagram at the top of the file shows the new Phase 4 with sub-items 4a, 4b, 4c, 4d
- Phases 1, 2, 3 sections (from `## Phase 1 — Domain Interview` through the end of `## Phase 3 — Implementation Choices`) are byte-identical to dex-superpowers/brainstorming.md (verify with `diff` scoped to those sections)
- Phase 4 section contains four sub-sections: 4a, 4b, 4c, 4d
- The "Key Principles", "Red Flags — Scope Reduction", and "Explaining With Structure" sections at the end of the file are byte-identical to dex-superpowers/brainstorming.md
- File ends with the same "Explaining With Structure" content as dex-superpowers/brainstorming.md

### Result
Authored brainstorming.md by copying dex-superpowers/brainstorming.md, updating the Phase 4 portion of the phase diagram, and rewriting the entire Phase 4 section into 4a (write spec) / 4b (write plan) / 4c (plan-reviewer subagent) / 4d (user gate). Plan defect surfaced: the spec's "byte-identical" requirement for Phases 1-3 was unsafe — the source contains two residual dex CLI references in Phase 1 (`dex list` on line 52, `dex epic → subtasks` on line 54). Orchestrator applied two minor wording fixes (`dex list` → `existing plan files at docs/superpowers/plans/`, `dex epic → subtasks` → `spec → plan`) to make the file standalone. `grep -iE '\bdex\b'` returns no matches. Commit: d485e1a

## Task 4: Author execution.md
- [ ] Status
Depends on: Task 1

### Scope
Create `file-superpowers/execution.md`. Substantial rewrite of the Setup, Per-Batch Flow, Context Pre-Curation, and Example Workflow sections. Other sections (Batching, Model Selection, Handling Implementer Status, After All Tasks, Red Flags, Advantages) carry over with terminology swapped (task IDs → task numbers, `dex show` → "the task spec in your prompt", `dex complete` → "checkbox flip + Result append", `dex list` → "scan the plan file's unchecked frontier").

### Approach
1. Use `dex-superpowers/execution.md` as a structural reference; do not copy wholesale. Author each section fresh, drawing terminology and structure from the source.
2. Open with the same intro framing (subagent rationale, batching as core principle, "subagent preparation" note about reading skill files), but rewrite to remove all dex CLI examples. Reference `tdd.md` (unchanged) as the at-minimum required reading for implementer subagents.
3. **Setup section** — author with these steps:
   - Read the plan file (path supplied by upstream phase) once into orchestrator context
   - Identify the unchecked frontier: scan the plan top-to-bottom for unchecked tasks whose declared `Depends on:` deps are all checked
   - Group unchecked frontier tasks into batches (see Batching section below)
   - Record the plan file path; pass it to every subagent for checkbox + Result update
   Include a short note: "Don't re-read full task descriptions into your own context after the initial scan — when you dispatch, you'll excerpt the relevant task section(s) from the plan file directly into the subagent prompt."
4. **Per-Batch Flow section** — exactly seven steps:
   1. Mark tasks in-progress (no-op for binary checkboxes — note this explicitly: "Tasks remain `- [ ]` until completion; there is no in-progress sentinel.")
   2. Record base SHA: `git rev-parse HEAD`
   3. Excerpt: copy each task section verbatim from the plan file — header line, checkbox, optional `Depends on:` line, and all four sub-sections. Stop at the next `## Task` heading. This is the `<task-spec>` block.
   4. Dispatch implementer subagent using the template in `implementer-prompt.md` with: `<task-spec>` block(s) pasted in, plan file path (for checkbox + Result update only), spec file path (for design context, on demand), brief scene-setting context.
   5. Handle implementer status (DONE / DONE_WITH_CONCERNS / NEEDS_CONTEXT / BLOCKED) — same handling table as dex-superpowers' "Handling Implementer Status" section.
   6. Dispatch reviewer subagent using `reviewer-prompt.md` with: same `<task-spec>` block(s), spec file path, implementer's status report, base SHA + head SHA (reviewer runs `git diff` itself).
   7. If reviewer finds issues: implementer fixes, reviewer re-reviews. Then verify checkboxes flipped + Result sub-sections appended for each task in the batch (sanity check; the implementer was instructed to do this).
   Adjust numbering if you collapse some — but the seven-step structure above is the target.
5. **Context Pre-Curation section** — state the modified principle:
   "Your job as orchestrator is to point, not to read — with one inversion: at the implementer hop you pre-read each task's section from the plan file and paste it verbatim into the subagent prompt. This keeps subagents focused on one task at a time without sibling-task interference. The rest of the discipline holds: do not read diffs, file contents, test output, or codebase into your own context to relay to subagents."
   Include this table:

   ```
   | Artifact                    | Orchestrator reads?         | Subagent reads?                            |
   |-----------------------------|-----------------------------|--------------------------------------------|
   | Plan file (whole)           | Yes (once, at setup)        | No                                         |
   | Plan file (own task section)| Yes (to excerpt)            | Only to write back checkbox + Result       |
   | Plan file (sibling tasks)   | Read but never relayed      | No — never                                 |
   | Spec file                   | Pointer only                | On demand, by path                         |
   | Diff                        | No                          | Yes (`git diff <base>..<head>`)            |
   | Codebase                    | No                          | Yes                                        |
   ```

6. **Batching section** — copy logic from dex-superpowers, swap terminology. Same guidance: batch related tasks touching shared files; keep separate tasks touching unrelated parts; sizing 2-4 tasks per batch good, 5+ too large.
7. **Model Selection section** — copy nearly as-is from dex-superpowers (already model-system agnostic).
8. **Handling Implementer Status section** — copy from dex-superpowers, swap terminology (no dex calls remain in the dex-superpowers version of this section anyway).
9. **After All Tasks section** — copy from dex-superpowers, swap terminology. Final reviewer subagent over full branch diff, then load `finishing.md`.
10. **Example Workflow section** — rewrite using plan file references and task numbers. Use a hypothetical plan with two batches; show plan file path, task excerpt as `<task-spec>` block, base/head SHAs, implementer status report, reviewer verdict.
11. **Red Flags section** — copy from dex-superpowers, swap terminology. Critical rules: never start work on main without consent; never skip review; never read diffs/files into your own context to relay; etc.
12. **Advantages section** — copy from dex-superpowers, swap terminology.
13. After all sections written, grep the entire file for any remaining "dex" references.

### Files
- file-superpowers/execution.md (new)

### Done criteria
- `grep -i dex file-superpowers/execution.md` returns no matches
- All required sections present in this order: intro, Setup, Per-Batch Flow, Context Pre-Curation, Batching, Model Selection, Handling Implementer Status, After All Tasks, Example Workflow, Red Flags, Advantages
- Per-Batch Flow section enumerates the seven steps in order
- Context Pre-Curation section includes the orchestrator/subagent reads table with at least 6 rows (Plan file whole, Plan file own task, Plan file siblings, Spec file, Diff, Codebase)
- Example Workflow uses task number references (e.g., "Task 3", "Task 5") and plan file paths, never dex IDs

## Task 5: Author the three subagent prompt templates
- [ ] Status
Depends on: Task 1

### Scope
Create three template files: `implementer-prompt.md`, `reviewer-prompt.md`, `plan-reviewer-prompt.md`. Each is a markdown file the orchestrator reads and parameterizes by filling in placeholders before dispatching a subagent.

### Approach

**file-superpowers/implementer-prompt.md** — sections in order, with the literal text of each placeholder kept as `<placeholder>` so the file reads as a template:

1. **Header**: "# Implementer Subagent Prompt" then a paragraph explaining that the task spec(s) below are the authoritative scope, and "Do not look elsewhere in the plan file for context; sibling tasks are intentionally hidden."
2. **Required reading**: list with absolute path placeholders:
   - `<skill-dir>/tdd.md`
   - `<skill-dir>/verification.md`
   - `<skill-dir>/condition-based-waiting.md` (if applicable)
3. **Your task(s)** section: a `<task-spec>` block (literal `<task-spec>` and `</task-spec>` tags as placeholders, with a comment line inside saying "[orchestrator pastes one or more verbatim ## Task N sections from the plan]")
4. **Plan file (for status update only)** section: state "Plan file: `<plan-path>`" then numbered instructions:
   1. After implementing, testing, and committing, open the plan file
   2. Locate your task section by header (e.g., `## Task 3: <title>`)
   3. Flip `- [ ] Status` → `- [x] Status`
   4. Append a new `### Result` sub-section under your task with 1-3 sentences (what was implemented, key decisions, test results) ending with `Commit: <sha>`
   5. Amend the plan changes into your task's implementation commit: `git add <plan-path>; git commit --amend --no-edit`
   6. Do NOT read or modify any other task section in the plan
5. **Spec file (design context, on demand)** section: state "Spec file: `<spec-path>`" then "Read the spec only if your task spec references something whose design context you need. The task spec should be self-sufficient for implementation; the spec is for understanding the broader system the task fits into."
6. **Scene-setting** section: a placeholder block "[orchestrator pastes a brief paragraph about where these tasks fit, anything the implementer should know that isn't in the task spec]"
7. **Status reporting** section: "When done, report exactly one status: DONE / DONE_WITH_CONCERNS / NEEDS_CONTEXT / BLOCKED. Include: summary of work completed, test results, self-review notes, commit SHA(s). For DONE_WITH_CONCERNS / NEEDS_CONTEXT / BLOCKED: what's blocking or unclear."
8. **Process** section: "Follow TDD per `tdd.md`. Verify per `verification.md` before reporting DONE."

**file-superpowers/reviewer-prompt.md** — sections in order:

1. **Header**: "# Reviewer Subagent Prompt" then paragraph: "You are performing unified spec + quality review for one or more completed tasks. You review against the task spec(s) pasted below and the diff between two SHAs. You do NOT read the plan file (siblings are out of scope) and you do NOT read the wider codebase except where the diff or spec leads you."
2. **Required reading**: `<skill-dir>/code-review.md`
3. **Task(s) under review** section: `<task-spec>` block placeholder (orchestrator pastes the same sections given to the implementer)
4. **Spec file (design context, on demand)** section: "Spec file: `<spec-path>`. Read on demand, same rule as the implementer."
5. **Implementer's status report** section: placeholder "[orchestrator pastes the implementer's status block verbatim]"
6. **Diff to review** section: "Run: `git diff <base-sha>..<head-sha>`. Base SHA: `<base-sha>`. Head SHA: `<head-sha>`."
7. **Output** section: "Report: spec compliance per task (✅/⚠️/❌ with specific findings); code quality (✅ approved / ⚠️ approved with fixes / ❌ needs rework); overall assessment (Approved / Approved with fixes / Needs rework); for each issue: severity (Critical / Important / Nit), location (file:line), what's wrong, suggested fix."

**file-superpowers/plan-reviewer-prompt.md** — sections in order:

1. **Header**: "# Plan Reviewer Subagent Prompt" then paragraph: "You are reviewing a freshly written implementation plan against its spec. You read both files in full (this is plan review, not task review — siblings are the point)."
2. **Required reading**: `<skill-dir>/brainstorming.md` (Phase 4 quality requirements)
3. **Files to review** section: "Plan file: `<plan-path>`. Spec file: `<spec-path>`. Read both completely."
4. **Per-task checks** section, bulleted:
   - Header line includes checkbox and (if non-adjacent dependency) `Depends on:` line
   - All four sub-sections present and non-empty: `Scope`, `Approach`, `Files`, `Done criteria`
   - No placeholders: no "TBD", "TODO", "implement later", "fill in details"
   - No vague instructions: no "add appropriate error handling", "write tests for the above"
   - No cross-references without content: no "similar to Task N" — each task self-sufficient
   - Exact file paths in the Files section
   - Done criteria observable / verifiable
5. **Cross-plan checks** section, bulleted:
   - Tasks collectively cover the spec (no design feature left without an implementing task)
   - No task overlaps another's scope
   - Dependencies form a DAG (no cycles)
   - Decomposition sizing reasonable: 3-7 tasks for medium features; not over-decomposed
6. **Output** section: "Per-task findings (issue + fix needed). Cross-plan findings. Overall: Approved / Needs revision."

For all three files: no dex references; placeholders use literal `<placeholder>` notation.

### Files
- file-superpowers/implementer-prompt.md (new)
- file-superpowers/reviewer-prompt.md (new)
- file-superpowers/plan-reviewer-prompt.md (new)

### Done criteria
- All three files exist in `file-superpowers/`
- `grep -i dex file-superpowers/implementer-prompt.md file-superpowers/reviewer-prompt.md file-superpowers/plan-reviewer-prompt.md` returns no matches across all three
- Each file contains its enumerated sections in the order listed
- Placeholders `<task-spec>`, `<plan-path>`, `<spec-path>`, `<skill-dir>`, `<base-sha>`, `<head-sha>` appear in the appropriate templates
- `implementer-prompt.md` includes the explicit instruction to amend plan changes into the task's implementation commit
- `reviewer-prompt.md` explicitly forbids reading the plan file beyond the task excerpt
- `plan-reviewer-prompt.md` explicitly states that reading the full plan and spec is required (siblings are the point)
