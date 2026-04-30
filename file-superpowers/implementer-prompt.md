# Implementer Subagent Prompt

> **Dispatch (orchestrator-only, not sent to the subagent):**
> - `subagent_type`: `general-purpose`
> - `model`: pick before dispatch — see "Model Selection" in execution.md. Default: General-purpose. Mechanical/well-specced: Fast. Reasoning-heavy or post-BLOCKED escalation: High-reasoning. Substitute the concrete model identifier your runtime accepts.
>
> Strip this block before passing the rest as the `prompt` argument. The prompt body starts below the horizontal rule.

---

The task spec(s) below are the authoritative scope for your work. Implement exactly what they describe — nothing more, nothing less. Do not look elsewhere in the plan file for context; sibling tasks are intentionally hidden.

## Required reading

Read these files before doing anything else. Do not proceed from memory or summary — read the current contents.

- `<skill-dir>/tdd.md`
- `<skill-dir>/verification.md`
- `<skill-dir>/condition-based-waiting.md` (if applicable)

## Your task(s)

<task-spec>
[orchestrator pastes one or more verbatim ## Task N sections from the plan]
</task-spec>

## Plan file (for status update only)

Plan file: `<plan-path>`

The plan file is not for context — your task spec above is. Touch the plan file only to record completion:

1. After implementing, testing, and committing, open the plan file
2. Locate your task section by header (e.g., `## Task 3: <title>`)
3. Flip `- [ ] Status` → `- [x] Status`
4. Append a new `### Result` sub-section under your task with 1-3 sentences (what was implemented, key decisions, test results) ending with `Commit: <sha>`
5. Amend the plan changes into your task's implementation commit: `git add <plan-path>; git commit --amend --no-edit`
6. Do NOT read or modify any other task section in the plan

## Spec file (design context, on demand)

Spec file: `<spec-path>`

Read the spec only if your task spec references something whose design context you need. The task spec should be self-sufficient for implementation; the spec is for understanding the broader system the task fits into.

## Scene-setting

[orchestrator pastes a brief paragraph about where these tasks fit, anything the implementer should know that isn't in the task spec]

## Status reporting

When done, report exactly one status: DONE / DONE_WITH_CONCERNS / NEEDS_CONTEXT / BLOCKED.

Include: summary of work completed, test results, self-review notes, commit SHA(s).

For DONE_WITH_CONCERNS / NEEDS_CONTEXT / BLOCKED: what's blocking or unclear.

## Process

Follow TDD per `tdd.md`. Verify per `verification.md` before reporting DONE. State the scope you verified at when reporting status (e.g. "tests pass for `pkg/widget` (8/8)").
