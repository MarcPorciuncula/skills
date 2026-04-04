---
name: dex-superpowers
description: >
  Use before any creative work, feature implementation, bug fixing, or behavior change.
  Covers brainstorming, design, TDD, debugging, verification, code review, parallel dispatch,
  and branch completion. Replaces superpowers workflow skills with dex-integrated equivalents.
  Use when: starting a new feature, implementing a design, writing tests, fixing bugs,
  claiming work is done, reviewing code, finishing a branch, or dispatching parallel agents.
---

# dex-superpowers

Unified development workflow skill. Each phase has its own document — read the right one before acting.

**Dex is the task tracking system.** No TodoWrite, no plan files, no spec files. Design documents become dex epic descriptions. Implementation plans become dex subtask trees. Progress is tracked with `dex start`, `dex complete`.

<HARD-GATE>
Read the sub-document for your current phase before taking action. Do not proceed from memory of what a superpowers skill used to say — read the current document in this directory.
</HARD-GATE>

## Phase Routing

| You are about to... | Read this first |
|---------------------|-----------------|
| Start new feature work, explore requirements, design something | `brainstorming.md` |
| Execute dex tasks with subagents | `execution.md` |
| Write or run tests (TDD red-green-refactor) | `tdd.md` |
| Debug a bug, test failure, or unexpected behavior | `debugging.md` |
| Claim work is done, commit, create a PR | `verification.md` |
| Request or receive code review | `code-review.md` |
| Finish a branch (all tasks complete, ready to merge/PR) | `finishing.md` |
| Work on 2+ independent tasks concurrently | `parallel-dispatch.md` |

## Dex Quick Reference

```bash
# Create epic with design
dex create "Feature name" --description "Full design..."

# Create subtask under epic
dex create --parent <epic-id> "Task name" --description "..."

# Add dependency
dex edit <id> --add-blocker <dependency-id>

# See task tree
dex show <epic-id> --expand

# Start work
dex start <id>

# Complete with result
dex complete <id> --result "What was done, decisions, test results" --commit <sha>

# Find ready tasks
dex list --ready
```

## Supporting References

These are loaded on demand by the phase documents that reference them:

| Document | Purpose |
|----------|---------|
| `visual-companion.md` | Browser-based mockups during brainstorming |
| `testing-anti-patterns.md` | Mock and test pitfalls |
| `root-cause-tracing.md` | Trace bugs backward through call stack |
| `defense-in-depth.md` | Multi-layer validation after finding root cause |
| `condition-based-waiting.md` | Replace arbitrary timeouts with condition polling |
| `implementer-prompt.md` | Subagent template for task implementation |
| `spec-reviewer-prompt.md` | Subagent template for spec compliance review |
| `code-quality-reviewer-prompt.md` | Subagent template for code quality review |
