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
- **Valid concern — behavioural change or test gap:** The comment reveals a real issue that requires a change in behaviour or a gap in test coverage. Flag that this will follow the red-green testing workflow during execution.
- **Out of scope:** The suggestion is valid but unrelated to the PR's purpose. Recommend acknowledging and deferring to a follow-up.

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

For question/discussion items, include the full draft reply text below the table so the user can copy and post it.

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
