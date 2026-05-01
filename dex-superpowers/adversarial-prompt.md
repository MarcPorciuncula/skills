# Adversarial Verifier Subagent Prompt

> **Dispatch (orchestrator-only, not sent to the subagent):**
> - `subagent_type`: `general-purpose`
> - `model`: pick before dispatch — see "Model Selection" in execution.md. Default: High-reasoning. The adversarial pass is reasoning-heavy (identifying plausible failure modes from a diff and justifying each check) and runs once per branch, so don't downgrade. Substitute the concrete model identifier your runtime accepts.
>
> Strip this block before passing the rest as the `prompt` argument. The prompt body starts below the horizontal rule.

---

Your job is to **try to find breakage** in the integrated branch diff. A disciplined engineer reviewing a colleague's branch picks the highest-yield places to probe and checks those. That's what you do.

## Required reading

Read these before doing anything else:

- `<skill-dir>/verification.md` (especially "Scope of verification")

## Branch under review

- Base SHA: `<base-sha>` (branch point)
- Head SHA: `<head-sha>` (current HEAD)
- Diff command: `git diff <base-sha>..<head-sha>`

## Brief summary of work

[orchestrator pastes a short summary of the tasks completed on this branch — the plan's task headers list is fine, or 1-2 sentences of context]

## How to read the diff

Ask "if this is wrong, where would it break first?" Every check you run must be justified by something concrete in the diff: "Checking X because of Y." If you can't write that line, drop the probe.

## Process

1. **Read the integrated diff.** `git diff <base-sha>..<head-sha>`. Understand what changed.

2. **Identify expected blast radius** from the diff:
   - Touched files and packages.
   - Shared helpers, interfaces, or contracts that were modified — and their known callers.
   - Edge cases, error paths, or boundary conditions the diff hints at.
   - Cross-task interactions: things one task changed that another task depends on.

3. **Pick high-yield probes** within that blast radius. Prefer:
   - Targeted test runs against affected packages and known callers.
   - Lint/typecheck on touched packages.
   - Manual reproductions of edge cases the diff suggests (e.g. "this branch handles `null` differently — does it actually?").

4. **Probe, justify, report.** For each probe: state what you're checking and why (pointing at the diff), then run it.

Don't write new tests. If you find a coverage gap, flag it as a finding.

## Output

Report:

- **Probes run** — for each: what you checked, why (point at the diff), result (pass/fail with relevant output).
- **Findings** — for each issue: severity (Critical / Important / Nit), location (`file:line`), what's wrong, suspected cause.
- **Overall assessment** — `✅ Clean — no breakage found within proportional scope` / `⚠️ Issues found — see findings` / `❌ Significant breakage — branch should not merge until resolved`.
- **Coverage note** — what you deliberately did not check, and why.
