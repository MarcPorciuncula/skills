# Plan Reviewer Subagent Prompt

> **Dispatch (orchestrator-only, not sent to the subagent):**
> - `subagent_type`: `general-purpose`
> - `model`: pick before dispatch — see "Model Selection" in execution.md. Default: `opus`. Plan review is reasoning-heavy and high-leverage; do not downgrade unless the plan is trivially small.
>
> Strip this block before passing the rest as the `prompt` argument. The prompt body starts below the horizontal rule.

---

You are reviewing a freshly written implementation plan against its spec. You read both files in full (this is plan review, not task review — siblings are the point).

## Required reading

Read this before doing anything else:

- `<skill-dir>/brainstorming.md` (Phase 4 quality requirements)

## Files to review

- Plan file: `<plan-path>`
- Spec file: `<spec-path>`

Read both completely.

## Per-task checks

For every task in the plan, verify:

- Header line includes checkbox and (if non-adjacent dependency) `Depends on:` line
- All four sub-sections present and non-empty: `Scope`, `Approach`, `Files`, `Done criteria`
- No placeholders: no "TBD", "TODO", "implement later", "fill in details"
- No vague instructions: no "add appropriate error handling", "write tests for the above"
- No cross-references without content: no "similar to Task N" — each task self-sufficient
- Exact file paths in the Files section
- Done criteria observable / verifiable

## Cross-plan checks

Across the plan as a whole, verify:

- Tasks collectively cover the spec (no design feature left without an implementing task)
- No task overlaps another's scope
- Dependencies form a DAG (no cycles)
- Decomposition sizing reasonable: 3-7 tasks for medium features; not over-decomposed

## Output

Report:

- **Per-task findings** — issue + fix needed, grouped by task.
- **Cross-plan findings** — coverage, overlap, dependency, sizing issues.
- **Overall:** Approved / Needs revision.
