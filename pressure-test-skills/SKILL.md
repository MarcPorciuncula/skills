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

## Choose the smallest useful blind check

| Question | Check |
|---|---|
| Does the revised skill produce the intended decision or output? | Run the candidate on one representative task. |
| Did the edit improve behaviour relative to the previous skill? | Compare candidate and control with the same task and relevant context. |
| Will the skill load naturally for this request? | Run a fresh-context routing check without naming the skill. |
| Does the result generalise beyond one task shape? | Add a materially different case or held-out task. |

Start with the first check that can answer the actual question. Add controls,
held-out tasks, scorer validation, or more cases only when the claim depends on
them. A localized skill change does not require a benchmark harness.

An explicitly named skill run is valid evidence about adherence after
activation. Do not present it as evidence about natural routing.

## Keep the subject focused on the task

Give the subject an ordinary task, the revised skill through the intended
activation path, and only the raw artifacts needed to perform the task. Define
the observable behaviour before the run and score the subject's output, tool
calls, side effects, and changed artifacts against it.

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

Use the strongest isolation available through the existing runner. Start the
subject in a fresh context with no inherited authoring turns. Set
`fork_turns: "none"` for Codex collaboration subagents. Exclude this evaluator
skill when the runner provides skill-catalogue control. Use neutral names for
subject-visible variants and fixtures when labels would reveal the expected
condition.

Inspect subject-visible metadata for obvious evaluation labels or the expected
result. Do not inventory every title, path, environment value, or tool output.
Do not replace a working runner or build new infrastructure only to hide
low-signal metadata. When the runner cannot isolate a surface directly, use the
best available separation and report the limitation. Stop refining the setup
when remaining differences are unlikely to change the behaviour being tested.

## Run proportionally

For a candidate-only check:

1. State the behaviour the edit should affect.
2. Choose a realistic task that exercises that decision.
3. Run the task with side effects limited to the user's authorized scope.
4. Inspect the trace and artifacts for the observable result.

For a comparison, keep the task prompt, model, tools, instructions, and limits
the same where those factors affect the claim. Mount each skill under its
normal name. Use separate working directories only when variants could mutate
or discover each other's state.

Retain enough of the prompt, trace, output, and artifacts to explain the
result. Do not require a known-success and known-failure scorer calibration
unless an automated scorer or ambiguous rubric makes calibration useful.

If the subject notices the evaluation, classify the run as unblinded. Do not
count it as evidence of ordinary blind behaviour. The run can still identify a
leak or demonstrate adherence after explicit activation. Remove an obvious
leak and rerun when the fix is cheap. If another rerun requires custom
infrastructure or repeated setup, report the limitation and stop. Do not block
a useful skill improvement solely because a fully blind run is unavailable.

If setup fails or begins to dominate the work, simplify the blind check. Prefer
an explicitly activated adherence run, a candidate-only run, or the strongest
comparison the existing runner supports over repeated fixture and harness
refinement.

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
