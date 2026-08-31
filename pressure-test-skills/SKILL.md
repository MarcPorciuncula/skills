---
name: pressure-test-skills
description: >-
  TRIGGER: Use when pressure-testing, forward-testing, or comparing agent
  behaviour after creating or editing a skill. SKIP: Static skill validation
  and ordinary task delegation.
---

# Pressure Test Skills

Run blind tests of whether a skill changes the intended observable behaviour.
Keep the evaluation design out of the subject's context with the strongest
isolation the existing runner readily provides. Remove cues that could
plausibly change the subject's behaviour, but do not let custom harness work or
exhaustive sanitation displace the behaviour test.

## Match the evidence to the claim

| Question | Check |
|---|---|
| Does the revised skill produce the intended decision or output? | Run the candidate on a representative task. |
| Did the edit improve behaviour relative to the previous skill? | Compare candidate and control with the same task and relevant context. |
| Will the skill load naturally for this request? | Run a fresh-context routing check without naming the skill. |
| Does the result generalise beyond one task shape? | Add a materially different case or held-out task. |

Choose the evidence design that supports the conclusion you need. Add controls,
held-out tasks, scorer validation, or more cases when the claim depends on
them. Evidence breadth and isolation quality are separate decisions. A
candidate-only run still uses the strongest available blind setup.

An explicitly named skill run is valid evidence about adherence after
activation. Do not present it as evidence about natural routing.

## Apply the strongest available isolation

Before launching, apply every relevant isolation measure the existing runner
readily supports. Do not choose a weaker setup because the preferred setup
might need troubleshooting.

| Subject-visible risk | Isolation measure |
|---|---|
| Inherited authoring or evaluation turns | Start a fresh context with no inherited turns. Set `fork_turns: "none"` for Codex collaboration subagents. |
| Evaluator-only skills or instructions | Exclude them when the runner provides skill-catalogue or prompt control. |
| Labels that reveal the condition or expected result | Use neutral names for subject-visible variants and fixtures. |
| Cross-variant files or mutable state | Use separate working directories when a subject could inspect or change the other variant's state. |

Give the subject an ordinary task, the revised skill through the intended
activation path, and only the raw artifacts needed to perform the task. Define
the observable behaviour before the run.

Remove direct evaluation cues:

- Do not pass the authoring conversation, diagnosis, intended answer, rubric,
  or prior conclusions.
- Do not tell the subject to evaluate, benchmark, compare, or pressure-test the
  skill unless evaluation is itself the behaviour under test.
- Do not expose candidate or control labels, evaluation plans, or the previous
  skill to a candidate run.
- Do not copy distinctive examples from the skill or editing conversation into
  the task prompt when a natural example is available.
- Do not warn the subject not to mention the evaluation. The warning is itself
  a cue.

Inspect subject-visible metadata for obvious evaluation labels or the expected
result. Do not inventory every title, path, environment value, or tool output.
Do not replace a working runner or build new infrastructure only to hide
low-signal metadata.

## Fall back only when blocked

When a concrete obstacle prevents the preferred blind setup, degrade in this
order:

1. Use another isolation control already provided by the runner, such as a
   fresh process, no-history spawn mode, skill-catalogue control, or a separate
   working directory.
2. Remove or neutralize the specific subject-visible cue that reveals the
   evaluation or expected result.
3. If the remaining measure requires custom infrastructure, a replacement
   runner, or repeated setup, omit that measure and record the limitation. Keep
   every other available isolation measure.
4. If the subject notices the evaluation, classify the run as unblinded. Use it
   only to identify the leak or demonstrate adherence after explicit
   activation. Remove an obvious leak and rerun when the fix is cheap.
5. If no stronger blind run is practical after those attempts, report the best
   result available and stop. Do not block a useful skill improvement solely
   because perfect isolation is unavailable.

Do not skip directly to a weaker setup. Name the obstacle that caused each
fallback. Stop refining the setup when the remaining differences are unlikely
to change the behaviour being tested.

## Run and score

Run the chosen design with side effects limited to the user's authorized
scope. For a comparison, keep the task prompt, model, tools, instructions, and
limits the same where those factors affect the claim. Mount each skill under
its normal name. Use separate working directories when variants could mutate
or discover each other's state.

Retain enough of the prompt, trace, output, and artifacts to explain the
result. Score the subject's output, tool calls, side effects, and changed
artifacts against the defined behaviour. Do not require a known-success and
known-failure scorer calibration unless an automated scorer or ambiguous
rubric makes calibration useful.

## Report the result

State:

- what behaviour the check exercised;
- whether the observed result supports the skill change;
- whether activation was natural or explicit;
- whether the subject remained blind to the evaluation;
- any cue, context difference, sample-size limit, or side-effect constraint
  that materially narrows the conclusion.

Stop when the evidence answers the decision needed for the current edit. Do
not claim broad reliability from one task, and do not delay a useful skill
improvement solely to make a one-off test fully blind.
