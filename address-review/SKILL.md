---
name: address-review
description: >
  Analyze and address PR review comments. TRIGGER when the user mentions
  addressing review comments, evaluating review comments, PR feedback, review
  feedback, checking comments, looking at comments, PR comments, or any
  reference to comments on the current branch's PR.
---

# Address Review Comments

Analyze review comments on the current branch's PR, categorize each not-dealt-with thread, present a numbered analysis table, and either execute fixes and replies (`address` mode) or stop for user direction (`evaluate` mode).

Always present the Phase 1 analysis table in chat before editing code, posting replies, or resolving threads, even when every comment looks trivial.

## Modes

- **Address mode** ("address review comments", "handle PR feedback"): Present the Phase 1 analysis table, then immediately execute Phase 2 (code fixes) and Phase 3 (replies, thread resolution, and `Needs your attention` handoff).
- **Evaluate mode** ("evaluate review comments", "check PR comments"): Present the Phase 1 analysis table and draft replies, then stop and wait for user instructions. Do not edit code, post replies, or resolve threads.

## Reviewer allowlist and action matrix

Determine how to handle each thread from the comment author and category. Code fixes in Phase 2 are governed by technical validity, never by whether the author is allowlisted; the allowlist gates only GitHub replies and thread resolution in Phase 3:

| Author type | Valid code or doc fix (Phase 2) | GitHub reply (Phase 3) | Auto-resolve thread (Phase 3) | Surface in `Needs your attention` |
|---|---|---|---|---|
| **Bot / automated reviewer** (`[bot]`, Copilot, GitHub Actions, etc.) | Apply fix | Post attributed reply | Always resolve | Only if category is `Out of scope` (user decides on follow-up issue) |
| **Allowlisted human** (explicitly listed in user/project `AGENTS.md` or `CLAUDE.md`, or authorized for this request by the user) | Apply fix | Post attributed reply | Resolve only for **unambiguous mechanical fixes** and **outdated** comments; leave open for design/correctness questions, subjective trade-offs, and out-of-scope items | Yes, whenever the thread is left open after replying |
| **Non-allowlisted human** (any human not on the allowlist and not explicitly authorized in the current prompt) | Apply fix | **Never post on GitHub** | **Never resolve** | **Always** (provide neutral draft reply + comment URL + commit hash if fixed) |

### Attribution and draft-reply rules

- **Posted replies (bots and allowlisted humans):** Prefix every posted reply with the provenance label configured in user or repository guidance (for example, `[AI Generated - <MODEL>]` per `attributing-content`, or `[Claude]` when no attribution rule is configured). Keep replies to 1 to 2 factual sentences.
- **Draft replies for the user (non-allowlisted humans):** Provide a plain, 1 to 2 sentence factual statement of what changed or why the current design is intentional (for example, `Fixed in abc1234: added nil guard before dereferencing the session pointer.`). Omit attribution prefixes, do not claim to write in the user's voice, and never include sycophantic appraisals (`Good catch`, `Great question`, `You're right`).

## Phase 1: Gather and classify not-dealt-with threads

### 1. Reconstruct live thread state

Determine thread state from the live PR, never from session memory or GitHub's resolved toggle alone:

1. Record the PR number, URL, and current head SHA as the iteration base:
   ```bash
   gh pr view --json number,url,headRefOid
   ```
2. Fetch inline review comments (`<skill-dir>/fetch-review-comments.sh <owner/repo> <pr>`), PR conversation comments (`gh pr view --comments`), and review summaries (`<skill-dir>/fetch-reviews.sh <owner/repo> <pr>`). Group inline comments into threads using the `Reply to` root ID.
3. Read each thread's full chronological history and filter to **not-dealt-with** threads. A thread is already **dealt with** when someone (author, reviewer, or agent) has addressed or dismissed the concern and the latest comment does not ask a follow-up question or reopen the issue. Omit dealt-with threads and suppressed bot summary items from the table.
4. Record the root comment IDs of all analysed not-dealt-with threads. Phase 3 may only reply to or resolve IDs from this Phase 1 set so comments arriving during Phase 2 pushes are never blindly closed.

### 2. Classify each not-dealt-with thread

Inspect the current code at each location and assign one category:

| Category | Criteria and default recommendation |
|---|---|
| **Outdated / already fixed** | Code has already changed or a later commit resolved the issue. Recommend dismissing (`Already addressed in <sha>`). |
| **Valid: simple fix** | Naming, formatting, missing nil/error check, unused import, or clear mechanical improvement. Batch into one commit. |
| **Valid: behavioural or test gap** | Real defect or missing test that passes `testing` admission criteria (load `testing` if available; if a requested test fails admission, classify as **Pedantic** and name the failed criterion). |
| **Question or discussion** | Reviewer asks why an approach was chosen or proposes an alternative that should not be adopted. Draft a concise factual explanation. |
| **Pedantic** | Technically true but adds coupling, premature abstraction, or churn for negligible gain (such as micro-optimizing cold paths or splitting intentional colocation). Recommend declining with a 1-sentence trade-off explanation. |
| **Stale documentation mismatch** | Automated reviewer flags a mismatch between code and a doc. Check `git log` first to verify the code is intentional:<br>- **Single-use plan (`plans/*.md`, one-off spec):** No action; code is authoritative and historical plans are not synced.<br>- **Living doc (`README.md`, `ARCHITECTURE.md`):** Update the doc.<br>- **PR body:** Patch only the stale claim via `writing-pr-bodies` (if available) when commit history confirms intent; ask the user if code and PR intent genuinely conflict. |
| **Out of scope** | Valid idea unrelated to this PR. Recommend acknowledging and deferring to a follow-up. |

### 3. Present the analysis table

Render the numbered summary table before taking any action:

| # | Location | Comment | Author | Category | Recommendation | Auto-handle? |
|---|---|---|---|---|---|---|
| 1 | `api.go:47` | "Could panic on nil" | `reviewer` | Valid: simple fix | Add nil guard | No (user reply) |
| 2 | `batch.go:33` | "Unused import" | `copilot` | Outdated | Already removed in `a1b2c3d` | Yes (bot) |
| 3 | `plan.md:12` | "Step 3 says extract helper" | `copilot` | Stale docs | No action: single-use plan is historical | Yes (bot) |

- Below the table, include the comment URL and neutral draft reply for every `Auto-handle? = No (user reply)` item.
- If most remaining comments are **Pedantic** or **Outdated**, add a 1-line note advising that the review has converged.
- In **evaluate mode**, stop here and wait for the user. In **address mode**, proceed immediately to Phase 2.

## Phase 2: Execute code and doc fixes

1. **Simple fixes and living-doc updates:** Apply and batch into a single commit, then push.
2. **Behavioural changes and admitted test gaps:** Load `testing` (if available), implement the fix and admitted test, run narrow verification on the touched packages, commit, and push.
3. **Scope of verification:** Verify against the Phase 1 iteration base and touched paths only. Do not run a whole-branch self-review or load `review-findings` for external PR review comments unless the fix crosses a new architectural, runtime, or compatibility boundary.

## Phase 3: Reply, resolve, and surface user actions

Run only in **address mode** after Phase 2 commits are pushed, scoped strictly to the root comment IDs recorded in Phase 1:

1. **Post eligible replies:** Write `comment_id:body` lines to a temp file for bots and allowlisted humans only, and run `<skill-dir>/reply-to-comments.sh <owner/repo> <pr> <file>`.
2. **Resolve eligible threads:** Write the Phase 1 root comment IDs that qualify for auto-resolution (per the action matrix above) to a temp file, and run `<skill-dir>/resolve-threads.sh <owner/repo> <pr> <file>`. Never resolve a thread where the agent did not post a reply.
3. **Print summary and `Needs your attention`:** State counts of replied, resolved, and left-open threads. If any threads require user action (non-allowlisted human threads, open discussion/question threads for allowlisted humans, or out-of-scope follow-up decisions), list them at the very bottom of the response with `file:line`, comment URL, category, commit hash (if fixed in Phase 2), and either `Posted reply:` or `Suggested reply:`. Omit `Needs your attention` when zero items require user action.
