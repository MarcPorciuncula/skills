---
name: address-review
description: >
  Analyze and address PR review comments. Use when the user mentions
  addressing review comments, evaluating review comments, PR feedback,
  or review feedback on the current branch's PR.
---

# Address Review Comments

Analyze review comments on the current branch's PR, categorize each one, and present recommendations. Depending on the user's phrasing, either proceed to fix immediately or wait for input.

## Mode

- **"Address review comments"** (or similar action-oriented phrasing): Analyze, present the table, then immediately proceed to execute the recommended changes without waiting for user approval.
- **"Evaluate review comments"** (or similar analysis-oriented phrasing): Analyze, present the table, then **stop and wait** for the user to review, ask questions, and decide which to address.
- **"Address and resolve review comments"** (or phrasing that includes "resolve", e.g. "fix and resolve", "address and close threads"): Same as address mode, but after fixing code also **replies to every comment** and **resolves all review threads** on GitHub. See Phase 3.

In all modes, always present the analysis table first so the user can see what's happening.

## Phase 1: Analysis

### Gather comments

1. Determine the PR for the current branch: `gh pr view --json number,url`
2. Fetch all review comments and inline comments: `gh api repos/{owner}/{repo}/pulls/{number}/comments`
3. Fetch PR conversation comments: `gh pr view --comments`
4. Fetch review statuses: `gh api repos/{owner}/{repo}/pulls/{number}/reviews`

### Assess each comment

Read the current state of the code at each commented location. For each comment, determine which category it falls into:

- **Outdated / already fixed:** The comment is on code that has already changed or the concern has been addressed in a subsequent commit. Recommend dismissing.
- **Question or discussion:** The reviewer is asking why something was done a certain way, or making a suggestion that shouldn't be adopted. Draft a clear explanation the user can post as a reply — explain the decision and the reasoning behind it.
- **Valid concern — simple fix:** A straightforward change like a naming improvement, missing error check, unused import, formatting. These can be batched together in one commit.
- **Valid concern — behavioural change or test gap:** The comment reveals a real issue that requires a change in behaviour or a gap in test coverage. Flag that this will follow the red-green testing workflow during execution.
- **Out of scope:** The suggestion is valid but unrelated to the PR's purpose. Recommend acknowledging and deferring to a follow-up.

### Present the table

Present a numbered table summarizing the findings:

| # | Location | Comment | Author | Category | Recommendation |
|---|----------|---------|--------|----------|----------------|
| 1 | `file.go:47` | "This could panic on nil" | reviewer | Valid — simple fix | Add nil guard |
| 2 | `api.go:120` | "Why not use X?" | reviewer | Question | Reply: explain that Y is preferred because... |
| 3 | `batch.go:33` | "Unused import" | reviewer | Outdated | Already removed in latest push |
| 4 | `process.go:89` | "Edge case: empty input" | reviewer | Valid — test gap | Add test + fix (red-green) |
| 5 | `handler.go:15` | "Consider extracting this" | reviewer | Out of scope | Acknowledge, defer to follow-up |

For question/discussion items, include the full draft reply text below the table so the user can copy and post it.

### After presenting

- If no comments require code changes (and not in address-and-resolve mode), say so and stop.
- **Address mode:** Proceed directly to Phase 2 with all recommended changes.
- **Address and resolve mode:** Proceed directly to Phase 2, then continue to Phase 3.
- **Evaluate mode:** Stop and wait. The user may ask deeper questions about specific items, adjust recommendations, or tell you which numbers to address.

## Phase 2: Execution

Work through the approved items:

1. **Batch simple fixes** (naming, formatting, missing checks, etc.) into a single commit. Commit and push.
2. **Behavioural changes and test gaps** follow the red-green testing principles: write the failing test first to drive and verify the fix, then implement. Since review comment fixes are typically small in scope, the test and implementation can be committed together in one commit rather than separate red/green commits. Push after committing.
3. **Questions/discussion items and out-of-scope items** are skipped during execution — the user handles replies and follow-ups.
4. **Outdated/already-fixed items** need no action.

In address and evaluate modes: do not post reply comments on GitHub — the user will handle the review conversation. Focus on code changes only.

In address-and-resolve mode: continue to Phase 3 after all code changes are committed and pushed.

## Phase 3: Reply and Resolve (address-and-resolve mode only)

This phase only runs in address-and-resolve mode.

### Gather context

1. Get the repo owner/name: `gh repo view --json nameWithOwner --jq .nameWithOwner`
2. The PR number was already determined in Phase 1.

### Reply to every comment

For each review comment from Phase 1, post a reply using its comment ID:

```
gh api repos/{owner}/{repo}/pulls/{number}/comments/{comment_id}/replies -f body="[Claude] ..."
```

Every reply body **must** be prefixed with `[Claude]`. Keep replies concise — one or two sentences. The reply content depends on the category:

- **Outdated / already fixed:** `[Claude] This was already addressed in {commit short hash}.`
- **Question / discussion:** `[Claude] {the draft explanation from the analysis table}.`
- **Valid concern — simple fix:** `[Claude] Fixed — {brief description of what changed}.`
- **Valid concern — behavioural change or test gap:** `[Claude] Fixed — added test and implementation for {brief description}.`
- **Out of scope:** `[Claude] Acknowledged — deferring to a follow-up.`

### Resolve all review threads

After all replies are posted, resolve every unresolved review thread:

1. Fetch thread IDs:
   ```
   gh api graphql -f query='
     query {
       repository(owner: "{owner}", name: "{repo}") {
         pullRequest(number: {number}) {
           reviewThreads(first: 100) {
             nodes {
               id
               isResolved
             }
           }
         }
       }
     }'
   ```

2. For each thread where `isResolved` is `false`, resolve it:
   ```
   gh api graphql -f query='
     mutation {
       resolveReviewThread(input: {threadId: "{thread_id}"}) {
         thread { isResolved }
       }
     }'
   ```

### Summary

After replying and resolving, present a brief summary: how many comments were replied to, how many threads were resolved.
