---
name: file-superpowers
description: >
  TRIGGER: Use when the user invokes `file-superpowers` by name or slash command,
  asks to write a spec, or asks to write a plan. SKIP: Do not infer a trigger from
  synonymous wording or inline planning requests, including “create a spec”, “spec
  this out”, “give me a spec”, “give me a plan”, “outline this”, “how would you
  approach this?”, or “what is the plan?” Do not use by default for implementation,
  bug fixes, testing, review, or branch completion.
---

# file-superpowers

Unified development workflow skill. Each phase has its own document — read the right one before acting.

## Entry gate

Start the workflow only when the user invokes `file-superpowers`, asks to write a
spec, or asks to write a plan.

Do not infer this trigger from synonymous wording. “Create a spec”, “spec this
out”, and similar wording request an inline response. Do not create workflow
artifacts or follow the phased process.

For routine work, phase documents may be consulted as reference material without
starting the workflow, creating a spec, or creating a plan.

Specs live at `docs/superpowers/specs/`. Plans live at `docs/superpowers/plans/`. Tasks are checkbox-tracked sections inside the plan file. Progress is recorded by flipping a task's checkbox and appending a `### Result` sub-section, both amended into the task's implementation commit.

<HARD-GATE>
Read the sub-document for your current phase before taking action. Do not proceed from memory of what a workflow skill used to say — read the current document in this directory.
</HARD-GATE>

## Phase Routing

| You are about to... | Read this first |
|---------------------|-----------------|
| Start new feature work, explore requirements, design something | `brainstorming.md` |
| Execute tasks with subagents | `execution.md` |
| Change behaviour or create or modify tests | `../testing/SKILL.md` |
| Debug a bug, test failure, or unexpected behavior | `debugging.md` |
| Claim work is done, commit, create a PR | `verification.md` |
| Request or receive code review | `code-review.md` |
| Finish a branch (all tasks complete, ready to merge/PR) | `finishing.md` |
| Work on 2+ independent tasks concurrently | `parallel-dispatch.md` |

## Plan File Quick Reference

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
- Test decision recorded; selected verification passes
- <observable behavior>

## Task 2: <title>
- [ ] Status
Depends on: Task 1

### Scope
...
```

- Tasks are sequential by default; `Depends on:` declares non-adjacent dependencies.
- Status is binary: `- [ ]` (pending) or `- [x]` (done).
- On completion, append a `### Result` sub-section to the task with 1-3 sentences, then amend the plan changes into the task's implementation commit.

## Supporting References

These are loaded on demand by the phase documents that reference them:

| Document | Purpose |
|----------|---------|
| `root-cause-tracing.md` | Trace bugs backward through call stack |
| `defense-in-depth.md` | Multi-layer validation after finding root cause |
| `condition-based-waiting.md` | Replace arbitrary timeouts with condition polling |
| `implementer-prompt.md` | Subagent template for task implementation |
| `reviewer-prompt.md` | Subagent template for unified spec + quality review |
| `plan-reviewer-prompt.md` | Subagent template for plan review after task decomposition |
