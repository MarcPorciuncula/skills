---
name: pr-overview
description: >
  Use when the user asks for an overview of a pull request or branch (e.g.
  "what changed in PR X", "give me an overview of branch Y", "walk me
  through this PR"), before diving into the diff.
---

# PR Overview

Produce a two-layer digest — domain and code — so the user can decide where to focus before reading the diff.

## Phase 1: Gather external context

Before reading any source, assemble the context the PR was written in.

1. `gh pr view <n>` — title, body, author, base/head, linked issues.
2. `gh pr view <n> --comments` — discussion threads, concerns raised, decisions made.
3. Referenced PRs — any `#NNNN` mentioned in the body or comments, plus stack parents and children. Fetch each with `gh pr view`.
4. Linear tickets — any `AI-1205`-style identifier in the body, commit titles, or branch name. Use `mcp__linear-server__get_issue`.
5. Design docs or specs linked from the body. Read them.
6. `git log --oneline <base>..<head>` — commit storyline. Often shows how the change evolved.

You should be able to state the goal of the PR in one sentence before moving to Phase 2.

## Phase 2: Checkout and survey

1. `git fetch origin <branch>` and `git checkout <branch>`.
2. `git diff --stat <base>..HEAD` — size, spread, file concentration.
3. Identify the 5–10 most central files. Prioritise by size, position in the diff, and whether they define new types or entrypoints. Deprioritise tests and generated files unless test changes are the point of the PR.
4. Read those files.

## Phase 3: Produce the two-layer digest

Use ASCII throughout — boxes-and-arrows, tables with box-draw characters, indented call trees. Present in this order, keeping the layers visually separate.

### Domain layer — what the change means

For each that applies, produce one artifact:

- **Component map** — ASCII boxes-and-arrows when service boundaries move, components are added, or data flow changes. Mark new components with `*` or `[new]`.
- **Flow trace** — numbered steps or indented fan-out when there is observable behaviour: a user action, a lifecycle transition, an event fan-out. Show branches with `alt` / `else` labels or nested indentation.
- **State machine** — labelled boxes with arrow transitions when an entity has a lifecycle (created → active → deleted, etc.).
- **Tables for enumerable behaviour** — event → consumer, state transitions, config switches, before/after metrics, user-visible routing. Use box-draw characters (`┌ ─ ┐ │ └ ┘ ├ ┤ ┬ ┴ ┼`).

### Code layer — where the change lives

- **File inventory table** with columns `Area | Location | Purpose` — 8–15 rows covering the key files.
- **Call tree(s)** for the hot path through the new code, using indentation:
  ```
  caller
    └── intermediate
          ├── branch_a
          └── branch_b
  ```
- **Added / removed / renamed summary** with `file:line` references for navigation.

### Worth flagging — always last

- Design decisions and invariants preserved.
- Concerns, open questions, merge blockers.
- Test-plan items from the PR body still unchecked.

## Phase 4: Stay honest

- State what the overview does not cover. E.g. "Read 8 of 49 files. Skipped generated ent code, tests, and migrations."
- The overview complements the diff, it does not replace it.
- If a diagram would require guessing about behaviour you did not verify in the code, say so and skip it.

## Common mistakes

- **Mixing abstraction layers in one diagram.** Produce two diagrams instead of crossing domain boundaries with code-level call paths.
- **Starting with the diff file-by-file.** The reader can do that themselves. The value is structure and external context.
- **Skipping PR comments and linked tickets.** Reviewer concerns and author replies often encode the reason code looks the way it does.
- **Overclaiming coverage.** If the PR is 50 files and you read 8, say so.
- **Using mermaid or other non-ASCII diagram syntax.** The output renders in a terminal. Mermaid source does not.

## Input forms

Accept any of:

- PR number (`1122`)
- Branch name (`ivan/push-notifications`)
- Both

Resolve PR → branch with `gh pr view <n> --json headRefName`. Resolve branch → PR with `gh pr list --head <branch> --json number,url,title`.

If no PR exists for the given branch, proceed using just the branch. Call this out in Phase 4.
