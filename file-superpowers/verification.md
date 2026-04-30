# Verification Before Completion

## Overview

Claiming work is complete without evidence is dishonesty. Running the entire repo's checks for every change is paranoia. This document is about the discipline that sits between those two failure modes.

**Core principle:** Evidence before claims, scoped proportionally to the change.

A disciplined engineer runs the checks the change warrants, judges what it warrants from the diff, and trusts CI for the unbounded sweep. Anything broader than that is paranoia dressed as rigor; anything narrower (or skipped) is dishonesty dressed as efficiency.

## The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH, PROPORTIONAL EVIDENCE
```

Two halves, both required:

- **Fresh.** If you haven't run the verification command in this message, you cannot claim it passes. Stale runs, "should pass," and trusted-agent reports are not evidence.
- **Proportional.** Evidence means a command that exercises the behavior the claim is about. The full repo suite is not "more evidence" for a claim about one module — it's a different claim with extra cost. Match the command to the claim.

## Scope of verification

Pick the narrowest invocation that exercises the change *and any flow-on areas you'd reasonably expect to be affected*. The floor is the touched files and packages. Extend when the change touches a shared helper, alters a contract used elsewhere, or otherwise has obvious blast radius — your call, grounded in the diff.

Do **not** extend to the whole repo because "something distant might break." If the codebase is fragile enough that distant breakage from a small change is likely, that's a code-quality signal, not a verification gap. CI is the trust boundary for unbounded checks. Use it.

| Change shape | Verification scope |
|---|---|
| Edit confined to one file/module | Tests for that file/module |
| Edit to a shared helper or interface | Tests for the helper plus its known callers |
| Cross-package integration work | Tests for the affected packages |
| Anything else | CI |

The end-of-workflow adversarial pass (see `execution.md` "After All Tasks") is where integrated breakage gets probed across the whole branch. Per-task verification does not need to pre-empt that pass.

## The Gate Function

```
BEFORE claiming any status:

1. IDENTIFY: What's the claim, and what command produces evidence for it?
2. SCOPE:    What's the narrowest invocation that exercises the claim,
             plus any flow-on areas you'd expect to be affected?
3. RUN:      Execute that command fresh.
4. READ:     Full output, exit code, failures.
5. VERIFY:   Does output confirm the claim?
             - If NO: state actual status with evidence.
             - If YES: state claim WITH evidence and the scope it was run at.
6. ONLY THEN: make the claim.

Skipping step 3-4 = lying.
Defaulting step 2 to "the whole repo" = paranoia.
```

## Common Failures

| Claim | Requires | Not Sufficient |
|-------|----------|----------------|
| Tests pass for the change | Targeted test command output: 0 failures | Previous run, "should pass" |
| Linter clean for the touched files | Linter output for those files: 0 errors | Extrapolation, partial-then-stop |
| Build succeeds for the affected package | Build command for that package: exit 0 | Linter passing, logs look good |
| Bug fixed | Test original symptom: passes | Code changed, assumed fixed |
| Regression test works | Red-green cycle verified | Test passes once |
| Agent completed | VCS diff shows changes | Agent reports "success" |
| Requirements met | Line-by-line checklist against the task spec | Tests passing |

Note the column header: "tests pass *for the change*," not "every test in the repo." Make the claim match what was checked.

## Red Flags — Stop

- Using "should", "probably", "seems to"
- Expressing satisfaction before verification ("Great!", "Perfect!", "Done!", etc.)
- About to commit/push/PR without verification
- Trusting agent success reports
- Claiming "tests pass" when only some were run, without naming the scope
- **Reaching for the repo-wide suite without a diff-grounded reason** (paranoia, not rigor)
- **Adding checks the change doesn't warrant "to be safe"** (cost without signal)
- Thinking "just this once"
- Tired and wanting work over

## Rationalization Prevention

Two directions to watch — under-checking and over-checking are both rationalizations.

| Excuse | Reality |
|--------|---------|
| "Should work now" | Run the verification |
| "I'm confident" | Confidence ≠ evidence |
| "Just this once" | No exceptions for skipping |
| "Linter passed" | Linter ≠ compiler |
| "Agent said success" | Verify independently |
| "I'm tired" | Exhaustion ≠ excuse |
| "I'll run the whole suite to be safe" | Cost without signal — name the claim, scope to it |
| "What if something far away broke" | That's CI's job; if it's likely, the codebase is the problem |
| "Different words so the rule doesn't apply" | Spirit over letter, both directions |

## Key Patterns

**Tests:**
```
✅ [Run targeted test command] [See: 12/12 pass in affected package] "Tests pass for <scope>"
❌ "Should pass now"
❌ [Run full repo suite for a one-file change] — paranoid, not rigorous
```

**Regression tests (TDD Red-Green):**
```
✅ Write → Run (fail) → Implement → Run (pass) — failure must point at the missing behavior
❌ "I've written a regression test" without seeing it fail first
```

**Build:**
```
✅ [Build the affected package] [exit 0] "Build passes for <package>"
❌ "Linter passed" (linter ≠ compiler)
```

**Requirements:**
```
✅ Re-read task spec → checklist → verify each → report gaps or completion
❌ "Tests pass, task complete" (tests ≠ requirements)
```

**Agent delegation:**
```
✅ Agent reports success → check VCS diff → verify changes → report actual state
❌ Trust agent report
```

## When To Apply

**ALWAYS before:**
- Any completion claim, in any wording
- Committing, PR creation, task completion
- Moving to the next task
- Acting on a subagent's success report

**Rule applies to:**
- Exact phrases
- Paraphrases and synonyms
- Implications of success
- Any communication suggesting completion/correctness

## The Bottom Line

**Run the right command. Read the output. State the claim with the scope it was run at.**

The right command is the one the change warrants — neither skipped nor padded. CI handles the unbounded sweep on PR open; the end-of-workflow adversarial pass handles integrated breakage hunting across the branch. Per-task verification is for the per-task claim.
