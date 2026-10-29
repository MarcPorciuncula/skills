# Subagent Prompt Templates for `dex`

Use these templates when orchestrating implementer, reviewer, or plan-audit subagents over a `dex` task tree. Pass `dex` IDs and commit SHAs rather than pasting full task descriptions or diffs into the prompt.

## 1. Plan-audit subagent prompt

Use after decomposing a complex epic to verify boundaries and `--add-blocker` edges before dispatching implementers:

```text
Audit the dex task tree under epic <epic-id> against its parent design.

1. Run `dex show <epic-id> --full` and `dex show <epic-id> --expand`.
2. Run `dex show <id> --full` for each child task.

Check four dimensions:
- Dependency accuracy: Every `blocked-by` edge reflects a true build, schema, or type dependency; flag missing blockers or false linear chains that prevent parallel work.
- Unresolved design forks: Flag any task that defers an architectural, contract, or library decision ("choose an appropriate X", "TBD").
- Boundary & file isolation: Confirm sibling tasks that can run in parallel do not overlap on the same files or functions, and each task has explicit Scope, Approach, Files, and Done criteria.
- Completeness: Confirm every requirement, migration, and contract in the epic is covered by at least one task.

Return PASS or a concise list of defects grouped by dimension. Do not edit tasks yourself.
```

## 2. Implementer subagent prompt

Use for a single task or a batch of 2 to 4 co-located unblocked tasks:

```text
Implement dex task(s): <task-id-list> (parent: <parent-id>).

1. Load context:
   - Run `dex show <id> --full` for each assigned task and `dex show <parent-id> --full` for parent context. Do not browse unrelated tasks.
   - If the `testing` skill is available, load it before editing tests or production code and record its test-admission decision.
2. Scene-setting:
   <1 to 2 sentences of architectural or worktree context, if needed>
3. Execute:
   - Implement the exact scope specified in the assigned task(s). If a task mandates updating callers of a changed contract, update all affected callers.
   - Run the narrowest tests and checks that exercise the touched files and packages.
   - Commit the changes (do not include dex task IDs in the commit message).
   - Stop and report if you hit an unresolved architectural, contract, or scope question instead of guessing.

Return:
- Status: DONE, DONE_WITH_CONCERNS, NEEDS_CONTEXT, or BLOCKED
- Summary of changes and commit SHA(s)
- Test admission decision and verification commands run
- Any concerns or blockers
```

## 3. Batch or branch reviewer subagent prompt

Use to verify a completed batch (`<base-sha>..<head-sha>`) against the assigned `dex` task(s):

```text
Review the implementation in `git diff <base-sha>..<head-sha>` against dex task(s) <task-id-list> (parent: <parent-id>).

1. Run `dex show <id> --full` for each task (and `<parent-id>` if needed).
2. Run `git diff <base-sha>..<head-sha>` and inspect surrounding code only where needed to verify boundaries or callers.
3. If evaluating test coverage, apply the `testing` skill's admission criteria (if available).

Evaluate:
- Spec compliance: Every required behaviour, contract, and caller update in the task description is implemented; no unrequested scope reduction or speculative extras.
- Code quality & boundaries: Clean responsibility boundaries, error handling, compatibility, and admitted test coverage.

Return:
- Spec compliance: PASS or exact missing/divergent requirements (`file:line`)
- Findings: Critical, Important, or Minor issues with `file:line`, failure consequence, and suggested fix
- Verdict: APPROVED or NEEDS_FIXES
```
