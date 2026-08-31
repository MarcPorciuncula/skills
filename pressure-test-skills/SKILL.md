---
name: pressure-test-skills
description: >-
  TRIGGER: Use when pressure-testing, forward-testing, or comparing agent
  behaviour after creating or editing a skill. SKIP: Static skill validation
  and ordinary task delegation.
---

# Pressure Test Skills

Test whether a skill changes the intended observable behaviour. Prefer useful
evidence soon enough to inform the edit. Isolation supports that goal by
removing cues that would plausibly change the subject's behaviour; it is not a
separate goal or a requirement for perfect experimental conditions.

## Choose the smallest useful check

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

Remove direct evaluation cues when practical:

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

Use a fresh process or `fork_turns: "none"` when inherited turns contain the
diagnosis or expected result. Exclude this evaluator skill from the subject's
catalogue when the runner makes that practical. Use neutral names for
subject-visible variants and fixtures when labels would reveal the expected
condition.

Do not inventory or sanitize every piece of metadata by default. Inspect a
title, path, repository name, environment value, or tool output only when the
subject can see it and it plausibly reveals the evaluation or expected result.
Stop refining the setup when remaining differences are unlikely to change the
behaviour being tested.

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

If the subject notices the evaluation, decide whether that recognition could
have changed the measured behaviour. Remove an obvious leak and rerun when the
fix is cheap. Otherwise keep the result, disclose the cue as a limitation, and
avoid claims that depend on blindness. Imperfect isolation does not erase
otherwise useful evidence.

If setup fails or begins to dominate the work, simplify the check. Prefer an
explicitly activated adherence run, a candidate-only run, or a clearly
qualified comparison over repeated fixture and harness refinement.

## Report the result

State:

- what behaviour the check exercised;
- whether the observed result supports the skill change;
- whether activation was natural or explicit;
- any cue, context difference, sample-size limit, or side-effect constraint
  that materially narrows the conclusion.

Stop when the evidence answers the decision needed for the current edit. Do
not claim broad reliability from one task, and do not delay a useful skill
improvement solely to make a one-off test fully blind.
