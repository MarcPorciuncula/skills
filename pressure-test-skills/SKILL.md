---
name: pressure-test-skills
description: >-
  TRIGGER: Use when pressure-testing, forward-testing, or comparing agent
  behaviour after creating or editing a skill. SKIP: Static skill validation
  and ordinary task delegation.
---

# Pressure Test Skills

Run an ordinary task to determine whether guidance produces the intended
observable behaviour. Isolation prevents evaluation cues from changing the
subject's behaviour. It supports the behaviour check and must not displace it.

## Match the evidence to the claim

| Question | Check |
|---|---|
| Can the subject follow the revised guidance? | Run the candidate on a representative task. This is an adherence check. |
| Did the edit improve behaviour relative to the previous skill? | Compare candidate and control with the same task and relevant context. |
| Will the skill load naturally for this request? | Run a fresh-context routing check without naming the skill. |
| Does the result generalise beyond one task shape? | Add a materially different case or held-out task. |

Define the observable decision, output, or side effect before writing the task.
Choose only the evidence needed for the current claim. A candidate-only run
does not show that the edit improved behaviour. Do not add a control, held-out
task, scorer calibration, or more cases unless the claim needs it.

An explicitly named skill run is valid evidence about adherence after
activation. Do not present it as evidence about natural routing.

## Keep the behaviour check blind

Before launching, apply this minimum isolation with controls already provided
by the runner:

- Start the subject in a fresh context without inherited authoring or
  evaluation turns. Set `fork_turns: "none"` for Codex collaboration
  subagents.
- Give the subject the skill under its normal name, an ordinary task, and only
  the raw artifacts needed to perform it.
- Keep the evaluator skill, authoring conversation, diagnosis, intended answer,
  rubric, prior skill, evaluation plan, and variant labels out of the subject's
  context.
- Use separate working directories when a subject could inspect or change the
  other variant's files or state.

Write the task as a plausible request for the work itself. If pressure or sunk
cost matters, express it through facts that naturally belong to the task. Do
not invent an extreme emergency or conspicuous scenario language merely to
force a decision.

Do not tell the subject to evaluate, benchmark, compare, or pressure-test the
skill unless evaluation is the behaviour under test. Do not warn the subject
not to mention the evaluation. The warning is itself a cue.

Inspect subject-visible metadata for obvious evaluation labels or the expected
result. Do not inventory every title, path, environment value, or tool output.
After the minimum isolation is in place, run the behaviour check. Do not build
custom infrastructure or sanitize low-signal metadata to make the setup look
perfect.

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

If the subject infers that it is being tested, do not use that run as evidence
of ordinary behaviour. Use it to identify the leak. If the run was explicitly
activated from the start, use it only as an adherence check. Remove one obvious
high-signal leak and rerun when an existing runner control makes that cheap.
Otherwise report that the blind behaviour claim was not validated and stop.

## Report the result

State:

- what behaviour the check exercised;
- whether the observed result supports the skill change;
- whether activation was natural or explicit;
- whether the subject remained blind to the evaluation;
- any cue, context difference, sample-size limit, or side-effect constraint
  that materially narrows the conclusion.

Stop when the evidence answers the decision needed for the current edit. Do
not claim improvement from a candidate-only run or broad reliability from one
task.
