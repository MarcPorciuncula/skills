---
name: address-review
description: >
  Analyze and address PR review comments. Use when the user mentions
  addressing review comments, evaluating review comments, PR feedback,
  review feedback, checking comments, looking at comments, PR comments,
  or any reference to comments on the current branch's PR.
---

# Address Review Comments

Analyze review comments on the current branch's PR, categorize each one, and present recommendations. Depending on the user's phrasing, either proceed to fix immediately or wait for input.

## Red Flags — Stop

| Thought | Reality |
|---------|---------|
| "These all look like simple fixes, I'll just start executing" | The analysis table comes first in every mode. Always. |
| "The username looks like a bot so I'll auto-resolve without checking the category" | Bot status affects auto-resolve eligibility, not whether analysis is required. Check the category. |
| "I reviewed this comment already, I can add its ID to the resolve list" | Only IDs recorded during Phase 1 may be resolved. Post-push comments are out of scope regardless of content. |
| "The plan says X but the code does Y, I should sync the plan" | Single-use plans are historical. Don't sync them to final code. Only update living design/architecture docs. |
| "The PR description contradicts the code, so the code must be wrong" | Check commit history first. Intentional divergence → update the description. Unexplained divergence → may be a real bug. |

## Mode

- **"Address review comments"** (or similar action-oriented phrasing): Analyze, present the table, then immediately proceed to execute the recommended changes, reply to comments, and resolve threads per the auto-resolve rules. Phases 1 → 2 → 3.
- **"Evaluate review comments"** (or similar analysis-oriented phrasing): Analyze, present the table, then **stop and wait** for the user to review, ask questions, and decide which to address. Phase 1 only — do not post replies or resolve threads.

<HARD-GATE>
In ALL modes — including address mode where execution follows immediately — you MUST present the analysis table before taking any action. This applies even when all comments look obviously simple or trivial. The table is the commitment: it shows the user exactly what you are about to do and creates an opportunity to redirect before any changes are made.
</HARD-GATE>

## Phase 1: Analysis

### Gather comments

1. Determine the PR for the current branch: `gh pr view --json number,url`
2. Fetch all inline review comments using `fetch-review-comments.sh`.
3. Fetch PR conversation comments: `gh pr view --comments`
4. Fetch review statuses using `fetch-reviews.sh`.
5. Record every comment ID from step 2 that you analyze. These IDs are needed in Phase 3 to scope replies and thread resolution to only the comments you actually reviewed.

### Assess each comment

Read the current state of the code at each commented location. For each comment, determine which category it falls into:

- **Outdated / already fixed:** The comment is on code that has already changed or the concern has been addressed in a subsequent commit. Recommend dismissing.
- **Question or discussion:** The reviewer is asking why something was done a certain way, or making a suggestion that shouldn't be adopted. Draft a clear explanation the user can post as a reply — explain the decision and the reasoning behind it.
- **Valid concern — simple fix:** A straightforward change like a naming improvement, missing error check, unused import, formatting. These can be batched together in one commit.
- **Valid concern — behavioural change or test gap:** The comment reveals a real issue that requires a change in behaviour or a gap in test coverage. Flag that this will follow the red-green testing workflow during execution. **Before categorizing a comment as a test gap, run it through "Test-gap claims as a source of false positives" below — not every request for a test is a valid gap.**
- **Pedantic:** Technically accurate but adds coupling, complexity, or churn for negligible benefit. Common shapes:
  - Comments about intentional design trade-offs (colocation, inlined patterns)
  - Micro-optimizations outside hot paths
  - "Consider" suggestions that add abstraction over a simpler working approach
  - Re-raising a variant of an already-addressed concern
- **Stale documentation mismatch:** The comment compares code against a stale PR description, plan doc, or spec rather than identifying a real code issue. See "Stale documentation as a source of false positives" below.
- **Out of scope:** The suggestion is valid but unrelated to the PR's purpose. Recommend acknowledging and deferring to a follow-up.

### Stale documentation as a source of false positives

Automated reviewers compare code against the PR description, plan docs, and specs. Divergence is common — plans are usually written before implementation and the code evolves as real constraints surface. **The code is the source of truth.**

Before categorizing a comment as stale docs, check commit history. A divergence that commits don't explain may be a real bug — treat as a valid concern instead.

For intentional divergences, the recommendation depends on the doc type:

- **Single-use plan or execution doc** (e.g. `plans/*.md`, pre-execution specs, one-off design notes consumed during implementation) — **no action**. The plan is a historical artifact; syncing it to final code adds churn without improving the codebase. Asking for a plan to be rewritten to match the code does not improve code quality.
- **Living design or architecture doc** (e.g. `README.md`, `ARCHITECTURE.md`, docs kept as ongoing reference) — update the doc to match current behaviour.
- **PR description** — update the description to reflect the change. Only when commit history makes the intent unambiguous; if commits and description conflict about what the PR is supposed to do, stop and surface it to the user rather than rewriting either.

If the doc type is unclear, default to treating it as a single-use plan. Ask the user if uncertain.

Common shapes:

- PR description references an old approach — update the description.
- Plan doc describes a step done differently — leave the plan alone.
- Comment flags a doc that "doesn't belong" (e.g. a spec from another feature bundled in an early commit) — no action.

### Test-gap claims as a source of false positives

Reviewers — especially automated ones — frequently ask for tests around recent changes. Not every test-gap claim is valid. A test is a permanent commitment: it accretes maintenance cost, constrains future refactors, and shapes how the next reader interprets the code. That permanence has to be earned.

Tests must earn their place by:

- Being attached to a fix or feature whose regression would cause real damage (correctness bugs with user-visible blast radius, or functional gaps that other code will rely on). Optimizations, performance improvements, and "more-correct" cleanups generally do not — the original code worked, and ship-on-review-confidence is fine.
- Exercising real behaviour our code owns — non-trivial transformation, branching, state, or data shape we wrote. Not the contract of a well-tested library primitive we compose.

Before categorizing a comment as **Valid concern — test gap**, run through these gates in order. **The claim is valid only if all gates pass. Any single fail → categorize as Pedantic instead.**

1. **Severity gate — does the underlying fix earn a permanent test?**
   - **Pass:** The fix addresses a correctness bug with user-visible blast radius (crash, data loss, wrong result, auth bypass), or fills a functional gap that other code will depend on.
   - **Fail → Pedantic:** The fix is an optimization, a performance improvement, or a "more-correct" cleanup. The original code worked; a regression here would be a quality decline, not a defect. The fix doesn't deserve a test that lives in the codebase forever.

2. **Subject gate — would the test exercise our logic, or a library's?**
   - **Pass:** The behaviour involves non-trivial transformation, branching, state, or data shape that we wrote.
   - **Fail → Pedantic:** The behaviour is the trivial composition of a well-tested library primitive (e.g. an rxjs operator, a TanStack Query option, a hook from a vetted library). The test would re-assert the library's contract, not ours.

3. **Category gate — is the behaviour in a class that's brittle and expensive to test in product code?**
   - **Pass:** The behaviour is deterministic and doesn't depend on timing, scheduling, or concurrent ordering primitives.
   - **Fail → Pedantic:** The behaviour depends on fine timing (debounce/throttle windows, animation frames), concurrency (race conditions, async ordering, scheduling), or lifecycle ordering (process signals, teardown sequencing). Replicating the bad state takes more effort than the fix, the test is brittle (CI flake, fake-timer/real-timer interactions), and regressions in this class are typically easier to spot in production telemetry than in tests. **Exception:** systems projects where correctness in this category is the deliverable (databases, schedulers, distributed locks, kernels). For product code (web frontends, CRUD backends, internal tools), skip.

4. **Visibility gate — could a code reviewer spot the regression by reading the change?**
   - **Pass:** The regression hides behind layers of state, indirection, or interaction; a glance at the diff wouldn't reveal it.
   - **Fail → Pedantic:** The change is small and its behaviour is visible at a glance. A test would mirror the source without catching anything review wouldn't.

5. **Harness gate — is the test setup proportionate to the assertion?**
   - **Pass:** The assertion does the heavy lifting; setup is incidental.
   - **Fail → Pedantic:** The harness (mocks, providers, fake timers, scaffolding) dwarfs the assertion. The test mostly verifies that the harness was set up correctly, and the harness becomes load-bearing infrastructure for future tests that copy it.

Common shape that fails this filter: a bot asks for a test of a debounce/throttle window or other coalescing behaviour added as an optimization. Severity gate fails (it's an optimization, not a bug fix), subject gate fails (the behaviour is a library operator), category gate fails (fine timing in product code). Single comment, three failures — solidly Pedantic.

### Present the table

Present a numbered table summarizing the findings:

| # | Location | Comment | Author | Category | Recommendation | Auto-resolve? |
|---|----------|---------|--------|----------|----------------|---------------|
| 1 | `file.go:47` | "This could panic on nil" | reviewer | Valid — simple fix | Add nil guard | No (substantive) |
| 2 | `api.go:120` | "Why not use X?" | reviewer | Question | Reply: explain that Y is preferred because... | No (question) |
| 3 | `batch.go:33` | "Unused import" | copilot | Outdated | Already removed in latest push | Yes (bot) |
| 4 | `process.go:89` | "Edge case: empty input" | reviewer | Valid — test gap | Add test + fix (red-green) | No (substantive) |
| 5 | `handler.go:15` | "Nit: rename this var" | reviewer | Valid — simple fix | Rename variable | Yes (trivial directive) |
| 6 | `utils.go:200` | "Consider extracting this" | reviewer | Out of scope | Acknowledge, defer to follow-up | No (out of scope) |
| 7 | `hook.go:30` | "Both caller and callee subscribe" | copilot | Pedantic | Intentional colocation; coupling not worth it | Yes (bot) |
| 8 | `api.go:50` | "PR description says X but code does Y" | copilot | Stale docs | Update PR description (commits confirm intent) | Yes (bot) |
| 9 | `user.go:12` | "plan.md step 3 specifies util extraction" | copilot | Stale docs | No action — plan is historical | Yes (bot) |

For question/discussion items, include the full draft reply text below the table so the user can copy and post it.

### Flag convergence

If the majority of this run's comments are Pedantic (or Pedantic plus Outdated), add a note below the table:

> This review appears to have converged — most remaining comments are pedantic. Consider stopping here rather than continuing to iterate.

This is advisory only. The user decides whether to proceed.

### After presenting

- **Address mode:** Proceed directly to Phase 2 with all recommended changes, then continue to Phase 3 (reply and resolve).
- **Evaluate mode:** Stop and wait. The user may ask deeper questions about specific items, adjust recommendations, or tell you which numbers to address.

## Phase 2: Execution

Work through the approved items:

1. **Batch simple fixes** (naming, formatting, missing checks, etc.) into a single commit. Commit and push.
2. **Behavioural changes and test gaps:** write a failing test first to confirm the gap, then implement the fix. Since review comment fixes are typically small in scope, commit the test and implementation together rather than in separate commits. Push after committing.
3. **Questions/discussion items and out-of-scope items** are skipped during execution — the user handles replies and follow-ups.
4. **Outdated/already-fixed items** need no action.

In evaluate mode: do not post reply comments on GitHub — the user will handle the review conversation. Focus on code changes only.

In address mode: continue to Phase 3 after all code changes are committed and pushed.

## Phase 3: Reply and Resolve

This phase runs in address mode after Phase 2 completes. It does not run in evaluate mode.

### Reply to comments

Write a temp file with one `comment_id:body` pair per line, then pass it to `reply-to-comments.sh`. Every reply body **must** be prefixed with `[Claude]`. Keep replies concise — one or two sentences. The reply content depends on the category:

- **Outdated / already fixed:** `[Claude] This was already addressed in {commit short hash}.`
- **Question / discussion:** `[Claude] {the draft explanation from the analysis table}.`
- **Valid concern — simple fix:** `[Claude] Fixed — {brief description of what changed}.`
- **Valid concern — behavioural change or test gap:** `[Claude] Fixed — added test and implementation for {brief description}.`
- **Pedantic:** `[Claude] {brief explanation of why the current approach is intentional and the trade-off isn't worth it}.`
- **Stale documentation mismatch:** pick the reply for what was (or wasn't) updated:
  - PR description: `[Claude] Updated the PR description to reflect the current implementation.`
  - Living design/architecture doc: `[Claude] Updated {doc} to match the current behaviour.`
  - Single-use plan: `[Claude] The plan was written before implementation and the code has since diverged. Leaving the plan as-is — the code is the source of truth.`
- **Out of scope:** `[Claude] Acknowledged — deferring to a follow-up.`

### Resolve threads

After replying, write a temp file with the comment IDs to resolve (one per line), then pass it to `resolve-threads.sh`. Which threads to resolve depends on the comment author and nature:

**Always auto-resolve (pass these comment IDs to `resolve-threads.sh`):**
- **All bot/automated comments** (e.g. Copilot, copilot-pull-request-reviewer, github-actions) — regardless of category.
- **Trivial directive comments from human reviewers** — comments that are specific, actionable, and don't require discussion. Examples:
  - "Nit: rename this to X"
  - "Remove this unused import"
  - "Move this to file Y"
  - "This should be `const` not `let`"
  - "Add a nil check here"
  - "Typo: foo → bar"
  - Basically any comment where the fix is unambiguous and the reply makes it clear the change was made.
- **Outdated / already fixed comments** from any author — the code has moved on, there's nothing left to discuss.

**Do NOT auto-resolve (leave these open for user review):**
- **Questions about architecture or design** from human reviewers — "Why did you choose X over Y?", "Should this be extracted into its own module?"
- **Questions about correctness** from human reviewers — "Does this handle the case where...?", "What happens if X is null?"
- **Subjective suggestions** from human reviewers — "I think this would be cleaner if...", "Have you considered..."
- **Out of scope items** — leave open so the user can respond and track follow-up.

**The guiding principle:** If a human reviewer would want to see the reply and confirm it's satisfactory before the thread closes, leave it open. If the fix is mechanical and the reply makes it self-evident, resolve it.

**CRITICAL: Only pass comment IDs that were recorded in Phase 1.** New review comments may have appeared after the code was pushed in Phase 2 — resolving them without analysis would be silently wrong. The allow-list you built in Phase 1 is the only source of truth for what gets resolved. Do not expand it here.

### Summary

After replying and resolving, present a brief summary: how many comments were replied to, how many threads were resolved, and how many were left open for user review (with a brief note on why each was left open).

## Scripts

This skill includes helper scripts in its directory (adjacent to this SKILL.md file). All scripts have executable permissions — **invoke them directly using their absolute path, not via `bash script.sh`**.

- **`fetch-review-comments.sh`** — Fetch all inline review comments for a PR.
  Usage: `<skill-dir>/fetch-review-comments.sh <owner/repo> <pr_number>`
- **`fetch-reviews.sh`** — Fetch all review statuses for a PR.
  Usage: `<skill-dir>/fetch-reviews.sh <owner/repo> <pr_number>`
- **`reply-to-comments.sh`** — Bulk-reply to PR review comments in one invocation. Reads `comment_id:body` pairs from a file (one per line).
  Usage: `<skill-dir>/reply-to-comments.sh <owner/repo> <pr_number> <file>`
- **`resolve-threads.sh`** — Resolve PR review threads, filtered to only threads whose root comment ID is in the provided allow-list. Reads comment IDs from a file (one per line). Prevents accidentally resolving threads from newer reviews.
  Usage: `<skill-dir>/resolve-threads.sh <owner/repo> <pr_number> <file>`
