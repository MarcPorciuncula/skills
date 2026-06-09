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

## Each run targets not-dealt-with threads

This skill is invoked iteratively. A PR may have been through prior cycles — possibly in a different session this agent has no memory of. Determine state from the PR itself, not from session continuity.

Analyse and surface only **not-dealt-with** threads.

**A thread is dealt with when:**
- some party has addressed the original issue (dismissal, the reviewer retracting, or acknowledgment plus fix), AND
- the latest comment does not raise a new question or reopen the concern.

Otherwise it is not dealt with.

A `[Claude]` reply is a signal, not the determinant — the contents matter, and the resolving comment may come from anyone (PR author, the reviewer themselves, or Claude). GitHub's resolved/open state is also not the determinant — the auto-resolve rules deliberately keep some dealt-with threads open for human visibility.

Read each thread's full comment history before classifying.

Dealt-with threads are context, not content. Read them to spot repeated reviewer behaviour, recurring concerns, or structural issues worth addressing. They do not appear in the analysis table, in "Needs your attention", or in narration.

## Red Flags — Stop

| Thought | Reality |
|---------|---------|
| "These all look like simple fixes, I'll just start executing" | The analysis table comes first in every mode. Always. |
| "The username looks like a bot so I'll auto-resolve without checking the category" | Bot status affects auto-resolve eligibility, not whether analysis is required. Check the category. |
| "This reviewer isn't allowlisted, so I'll leave the fix for them too" | The allowlist gates the reply and the resolve, never the code change. Make the fix in Phase 2; only the reply is held back for the user. |
| "I reviewed this comment already, I can add its ID to the resolve list" | Only IDs recorded during Phase 1 may be resolved. Post-push comments are out of scope regardless of content. |
| "The plan says X but the code does Y, I should sync the plan" | Single-use plans are historical. Don't sync them to final code. Only update living design/architecture docs. |
| "The PR description contradicts the code, so the code must be wrong" | Check commit history first. Intentional divergence → update the description. Unexplained divergence → may be a real bug. |

## Mode

- **"Address review comments"** (or similar action-oriented phrasing): Analyze, present the table, then immediately proceed to execute the recommended changes, reply to comments, and resolve threads per the auto-resolve rules. Phases 1 → 2 → 3.
- **"Evaluate review comments"** (or similar analysis-oriented phrasing): Analyze, present the table, then **stop and wait** for the user to review, ask questions, and decide which to address. Phase 1 only — do not post replies or resolve threads.

<HARD-GATE>
In ALL modes — including address mode where execution follows immediately — you MUST present the analysis table before taking any action. This applies even when all comments look obviously simple or trivial. The table is the commitment: it shows the user exactly what you are about to do and creates an opportunity to redirect before any changes are made.
</HARD-GATE>

## Reply attribution label

Posts from this skill carry an attribution prefix so reviewers can tell agent comments from human ones at a glance. The default is `[Claude]`. If CLAUDE.md (user-level or project-level) configures a different attribution label for PR review replies (e.g. `[Agent]`, `[Bot]`, a tool name), use that label everywhere this skill writes `[Claude]` — the dealt-with detection signal, the allowlist gate, and every template in Phase 3.

Without an explicit override in CLAUDE.md, the default `[Claude]` stands.

## Reviewer reply allowlist

Claude only posts `[Claude]` replies and resolves threads on behalf of the user for authors that are pre-approved. This prevents auto-replies going out to human reviewers who haven't agreed to receive them.

**Always auto-handled (reply + resolve per the category rules):**
- Bot / automated reviewers (e.g. `copilot-pull-request-reviewer`, `github-actions`, `dependabot`, anything with the `[bot]` suffix or an account that exists to run automation).

**Auto-handled only when explicitly allowlisted in CLAUDE.md guidance** (user-level or project-level):
- Human reviewers. The allowlist names specific GitHub usernames the user has explicitly approved for `[Claude]` auto-replies on PR review comments. Treat "no allowlist found" as "no human is allowlisted" — default to the escalation path below. Do not infer allowlist status from other signals (collaborator status, prior friendly exchanges, repo ownership, etc.) — only an explicit name in CLAUDE.md counts.

**For non-allowlisted human reviewers:** do not post a reply, do not resolve the thread. Instead, draft the reply (or the context the user would need to write one) and surface it in "Needs your attention" with the comment URL, so the user can post it themselves.

This gate applies regardless of category. A "trivial directive" or "outdated" comment from a non-allowlisted human still goes to "Needs your attention" — the user owns the conversation with that reviewer.

**Phase 2 (code changes) is not gated by the allowlist.** Only Phase 3 (reply and resolve) is. When a non-allowlisted human flags anything the rules say to address (a valid simple fix, a real bug, a test gap), make the change in Phase 2 exactly as you would for an allowlisted author. Hold back only the reply: surface a draft "Fixed in commit X" reply for the user to post. Not being allowed to reply never means not addressing the issue.

## Phase 1: Analysis

### Gather comments

1. Determine the PR for the current branch: `gh pr view --json number,url`
2. Fetch all inline review comments using `fetch-review-comments.sh`. Group into threads using the `Reply to` field (a comment with no reply-to is its thread's root).
3. Fetch PR conversation comments: `gh pr view --comments`
4. Fetch review statuses using `fetch-reviews.sh`.
5. For each thread, read the full comment history in order and classify it as dealt-with or not-dealt-with per "Each run targets not-dealt-with threads". Only not-dealt-with threads enter the analysis table.
6. Record every comment ID from step 2 that you analyze (i.e., comments in not-dealt-with threads). These IDs are needed in Phase 3 to scope replies and thread resolution to only the comments you actually reviewed.

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

Reviewers — especially automated ones — frequently ask for tests around recent changes. A test is a permanent maintenance commitment, so not every test-gap claim earns one — run the gates below before categorizing as **Valid concern — test gap**.

The claim is valid only if all gates pass. Any single fail → categorize as Pedantic instead.

1. **Severity gate — does the underlying fix earn a permanent test?**
   - **Pass:** The fix addresses a correctness bug with user-visible blast radius (crash, data loss, wrong result, auth bypass), or fills a functional gap that other code will depend on.
   - **Fail → Pedantic:** The fix is an optimization, a performance improvement, or a "more-correct" cleanup.

2. **Subject gate — would the test exercise our logic, or a library's?**
   - **Pass:** The behaviour involves non-trivial transformation, branching, state, or data shape that we wrote.
   - **Fail → Pedantic:** The behaviour is the trivial composition of a well-tested library primitive (e.g. an rxjs operator, a TanStack Query option, a hook from a vetted library). The test would re-assert the library's contract, not ours.

3. **Category gate — is the behaviour in a class that's brittle and expensive to test in product code?**
   - **Pass:** The behaviour is deterministic and doesn't depend on timing, scheduling, or concurrent ordering primitives.
   - **Fail → Pedantic:** The behaviour depends on fine timing (debounce/throttle windows, animation frames), concurrency (race conditions, async ordering, scheduling), or lifecycle ordering (process signals, teardown sequencing). Tests in this class tend to be CI-flaky for low return. **Exception:** systems code where this category *is* the deliverable (databases, schedulers, distributed locks, kernels).

4. **Visibility gate — could a code reviewer spot the regression by reading the change?**
   - **Pass:** The regression is non-obvious from the diff alone — hidden behind layers of state, indirection, or interaction.
   - **Fail → Pedantic:** The change is small and its behaviour is visible at a glance. A test would mirror the source without catching anything review wouldn't.

5. **Harness gate — is the test setup proportionate to the assertion?**
   - **Pass:** The assertion does the heavy lifting; setup is incidental.
   - **Fail → Pedantic:** The harness (mocks, providers, fake timers, scaffolding) dwarfs the assertion. The test mostly verifies that the harness was set up correctly.

Common shape that fails this filter: a bot asks for a test of a debounce/throttle window or other coalescing behaviour added as an optimization. Severity gate fails (it's an optimization, not a bug fix), subject gate fails (the behaviour is a library operator), category gate fails (fine timing in product code). Single comment, three failures — solidly Pedantic.

### Present the table

Present a numbered table summarizing the findings:

The "Auto-handle?" column captures whether Claude will post the reply and resolve the thread end-to-end in Phase 3. For non-allowlisted human reviewers it is always "No (user reply)" regardless of category — see "Reviewer reply allowlist". For allowlisted humans, the column reflects the category-based rules in Phase 3.

| # | Location | Comment | Author | Category | Recommendation | Auto-handle? |
|---|----------|---------|--------|----------|----------------|--------------|
| 1 | `file.go:47` | "This could panic on nil" | reviewer | Valid — simple fix | Add nil guard | No (user reply) |
| 2 | `api.go:120` | "Why not use X?" | reviewer | Question | Draft reply: explain that Y is preferred because... | No (user reply) |
| 3 | `batch.go:33` | "Unused import" | copilot | Outdated | Already removed in latest push | Yes (bot) |
| 4 | `process.go:89` | "Edge case: empty input" | reviewer | Valid — test gap | Add test + fix (red-green) | No (user reply) |
| 5 | `handler.go:15` | "Nit: rename this var" | reviewer | Valid — simple fix | Rename variable | No (user reply) |
| 6 | `utils.go:200` | "Consider extracting this" | reviewer | Out of scope | Draft acknowledgment, user defers to follow-up | No (user reply) |
| 7 | `hook.go:30` | "Both caller and callee subscribe" | copilot | Pedantic | Intentional colocation; coupling not worth it | Yes (bot) |
| 8 | `api.go:50` | "PR description says X but code does Y" | copilot | Stale docs | Update PR description (commits confirm intent) | Yes (bot) |
| 9 | `user.go:12` | "plan.md step 3 specifies util extraction" | copilot | Stale docs | No action — plan is historical | Yes (bot) |

For every item with "Auto-handle? = No (user reply)" — i.e. all non-allowlisted human reviewer comments — include the full draft reply text and the comment URL below the table so the user can copy and post it. The same applies to question/discussion items from allowlisted humans where the reply needs user review before posting.

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

Phase 3 is gated by the **Reviewer reply allowlist**: Claude only posts replies to bots and to humans explicitly allowlisted in CLAUDE.md. For non-allowlisted human reviewers, Phase 3 produces no GitHub side-effects on their threads — those threads are surfaced in "Needs your attention" with drafted replies and comment URLs for the user to handle.

### Reply to comments

For each not-dealt-with thread analysed in Phase 1, decide whether Claude is allowed to post the reply:

- **Bot author:** Claude posts the reply per the category rules below.
- **Allowlisted human author** (per CLAUDE.md): Claude posts the reply per the category rules below.
- **Non-allowlisted human author:** Claude does **not** post anything. Draft the reply body using the same category rules and pass it through to "Needs your attention" along with the comment URL. Omit the attribution prefix. Skip this comment when assembling the reply file. Write the draft per "Drafting replies for the user" below.

### Drafting replies for the user

A draft reply is a plain, factual starting point the user will edit before posting. It is not written in the user's voice. You do not know how the user writes, and you have not looked. Mimicking a voice you have not seen produces fabricated pleasantries. "Good point", "Nice catch", and similar appraisals of a reviewer's comment read as patronising when an agent generates them, and they put words in the user's mouth the user never chose.

- State only what was done or found: the fix, the commit, the reason, the answer to the question. Same content as the bot/allowlisted templates, minus the prefix, one or two sentences.
- No pleasantries. Do not open with or insert "Good point", "Nice catch", "Great question", "You're right", or any appraisal of the reviewer's comment.
- Do not describe the draft as being in the user's voice, in their style, or how they would phrase it. It is a neutral draft; the user supplies the voice.

For comments Claude is allowed to post, write a temp file with one `comment_id:body` pair per line, then pass it to `reply-to-comments.sh`. Every reply body **must** be prefixed with the configured attribution label (default `[Claude]`; see "Reply attribution label"). Keep replies concise — one or two sentences. The reply content depends on the category — the templates use `[Claude]` as the default; substitute the configured label if one is set:

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

After replying, write a temp file with the comment IDs to resolve (one per line), then pass it to `resolve-threads.sh`. **Never resolve a thread Claude didn't post a reply on** — silently closing a non-allowlisted human reviewer's thread leaves them without an answer. Which threads to resolve depends on the comment author and nature:

**Always auto-resolve:**
- **All bot/automated comments** (e.g. Copilot, copilot-pull-request-reviewer, github-actions) — regardless of category.

**Auto-resolve only when the author is allowlisted in CLAUDE.md:**
- **Trivial directive comments from allowlisted human reviewers** — comments that are specific, actionable, and don't require discussion. Examples:
  - "Nit: rename this to X"
  - "Remove this unused import"
  - "Move this to file Y"
  - "This should be `const` not `let`"
  - "Add a nil check here"
  - "Typo: foo → bar"
  - Basically any comment where the fix is unambiguous and the reply makes it clear the change was made.
- **Outdated / already fixed comments from allowlisted human reviewers** — the code has moved on, there's nothing left to discuss.

**Do NOT auto-resolve:**
- **Any thread from a non-allowlisted human reviewer** — Claude didn't post a reply, so resolving would close the conversation without acknowledgment.
- **Questions about architecture or design** from allowlisted human reviewers — "Why did you choose X over Y?", "Should this be extracted into its own module?"
- **Questions about correctness** from allowlisted human reviewers — "Does this handle the case where...?", "What happens if X is null?"
- **Subjective suggestions** from allowlisted human reviewers — "I think this would be cleaner if...", "Have you considered..."
- **Out of scope items** from allowlisted human reviewers — leave open so the user can respond and track follow-up.

**The guiding principle:** If a human reviewer would want to see the reply and confirm it's satisfactory before the thread closes, leave it open. If the fix is mechanical and the reply makes it self-evident, resolve it. If Claude didn't reply at all (non-allowlisted author), never resolve.

**CRITICAL: Only pass comment IDs that were recorded in Phase 1.** New review comments may have appeared after the code was pushed in Phase 2 — resolving them without analysis would be silently wrong. The allow-list you built in Phase 1 is the only source of truth for what gets resolved. Do not expand it here.

### Summary

After replying and resolving, present a brief summary: how many comments were replied to, how many threads were resolved, and how many were left open for user review (with a brief note on why each was left open).

### Needs your attention

After the summary, re-surface every item that **still requires the user to take action**. This is the last thing in the conversation by design — the Phase 1 table scrolls away under Phase 2/3 tool output, and these items get lost otherwise.

The bar for inclusion is high: include only items from this run's analysis where the user must do something *by the skill's own rules*. If a comment was auto-resolved or declined per the rules, the standard behaviour was applied and there is nothing for the user to do — re-surfacing it implicitly asks the user to override the skill's own classification, which is the opposite of why this section exists. Trust the classification.

Include:

- **Threads needing your reply (non-allowlisted human reviewer)** — every not-dealt-with thread whose author is a human not on the CLAUDE.md allowlist. Claude has not posted anything on these threads. Include the comment URL, the drafted reply text (no attribution prefix, written per "Drafting replies for the user"), and a note on any code change Claude already made so the reply can reference it (e.g. "Fixed in {commit short hash}").
- **Threads left open after a Claude reply** — for allowlisted human reviewers: questions about architecture/design, correctness, subjective suggestions, or out-of-scope items where Claude posted a reply but left the thread open. Include the reply text Claude posted so the user can read it without leaving the terminal.
- **Out of scope items** — even when the reply was posted, the user needs to decide whether to open a follow-up issue or PR.

Do **not** include:

- Threads dealt with in prior runs (regardless of GitHub resolved/open state). "Needs your attention" covers this run's analysed items only; prior-run state never reappears here.
- Anything that was auto-resolved per the rules (bot comments of any category, trivial directives or outdated comments from allowlisted humans). Auto-resolve *is* the standard behaviour — these are deliberately handled without the user.
- Pedantic or stale-docs items from bots or allowlisted humans where Claude declined and the thread was auto-resolved. The decline *is* the standard behaviour by the gates in Phase 1; surfacing it asks the user to override the skill's own logic.
- Simple fixes that have already been applied and replied to (allowlisted-human or bot author).
- Outdated / already-fixed items handled end-to-end by Claude.

Format as a numbered list. For each item include: location (`file:line`), comment URL, the original comment (truncated if long), the author, the category, what action is needed, and the reply text — labelled "Claude posted:" if it was posted, or "Suggested reply:" if it's a draft for the user to post.

Skip this section entirely if there are no items requiring user action. This is the common case when the run converges (most comments auto-resolved or auto-declined per the rules) — silence is the correct outcome, not a regression.

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
