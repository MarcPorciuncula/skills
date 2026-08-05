---
name: pressure-test-skills
description: >-
  TRIGGER: Use when pressure-testing, forward-testing, or comparing agent
  behaviour after creating or editing a skill. SKIP: Static skill validation
  and ordinary task delegation.
---

# Pressure Test Skills

Evaluate a skill without exposing the evaluation design to the agent using it.
The evaluator owns context construction, variant setup, traces, and scoring.

## IRON LAW: isolate the subject from the evaluator

NO SUBJECT RUN WITH EVALUATOR CONTEXT.

Keep this skill and every evaluation artifact out of the subject's context.

| The subject receives | The evaluator retains |
|---|---|
| Production system and developer instructions | The authoring conversation |
| The skill under its normal name | The diagnosis and intended fix |
| An ordinary task request | The scoring rubric and expected result |
| Raw task artifacts | Variant labels and comparison instructions |

## Procedure

1. **Define the behaviour.** Write the observable decision, output, or side
   effect the changed guidance should affect. Define the scorer before writing
   the subject prompt.
2. **Read the runner.** Confirm how it builds prompts, inherits parent turns,
   discovers skills, chooses a working directory, shares files, applies tool
   permissions, and stops runs. Record everything the subject can see.
3. **Build isolated variants.** Start each subject in a fresh process or a
   spawn mode that passes no parent turns. Use separate task fixtures outside
   the skills repository. Mount candidate and control under the same normal
   skill name and path shape. Assign opaque, production-plausible identifiers
   that do not encode the condition or the evaluation. Keep the model, tools,
   instructions, limits, and task identical.
4. **Preflight the subject view.** Render every value the subject can observe:
   task and thread titles, agent names, prompts, inherited turns, skill
   catalogues, working directories, repository and branch names, filenames,
   commands, tool output, artifact metadata, and environment values. Read the
   rendered view as the subject. Replace every evaluation-labelled value.
   Do not launch until the complete view looks like an ordinary production
   task.
5. **Choose the activation check.** For a trigger check, make the skill
   discoverable and do not name it. For an adherence check, activate it through
   the production routing mechanism. If the runner can only activate the skill
   by naming it in the subject prompt, report the check as unblinded.
6. **Write an ordinary task.** Give only task-local facts and raw artifacts.
   Apply time pressure or sunk cost through facts already present in the task,
   not through reusable evaluation prose. State side-effect limits as normal
   requester instructions and enforce them in the runner too.
7. **Run and retain the trace.** Preserve the visible prompt, reasoning,
   tool-call sequence, tool results, output, and changed artifacts for each
   run.
8. **Apply the contamination gate.** When a subject infers that it is being
   tested, benchmarked, compared, or placed in a scenario, mark the run
   contaminated. Do not score it as a pass or failure. Find and remove the
   leaked context before rerunning.
9. **Score outside the subject.** Apply the prewritten scorer to observable
   behaviour. Read the traces for leading and rejected variants. Confirm any
   claimed improvement on held-out tasks with different artifacts and wording.

## Isolation requirements

- DO use a fresh process when the ordinary subagent surface cannot isolate the
  skill catalogue, working directory, or parent history
- DO set `fork_turns: "none"` for Codex collaboration subagents; the default
  passes the parent turns
- DO exclude this evaluator skill from the subject's available skills
- DO use neutral task titles, agent names, repository names, branch names,
  paths, filenames, and artifact labels everywhere the subject can observe them
- DO assign opaque identifiers independently of condition; do not translate
  `candidate` and `control` into synonyms
- DO use separate working directories when agents or variants share a
  filesystem
- DO keep the candidate and control task prompts byte-identical
- DO validate the scorer on a known failure and a known success before using it
- DO NOT expose plans, diffs, branch names, filenames, or repository documents
  that describe the evaluation
- DO NOT pass the evaluator's diagnosis, intended answer, rubric, or prior
  conclusions to the subject
- DO NOT copy examples from the skill under test or the editing conversation
  into subject prompts
- DO NOT add "do not mention the evaluation" to a subject prompt; the warning
  reveals the evaluation
- DO NOT treat an explicitly activated run as evidence that the skill triggers
  naturally
- DO NOT claim a blinded comparison from ordinary subagents when their context
  or filesystem cannot be isolated

## Red flags: STOP

| Thought | Reality |
|---|---|
| "The task prompt does not mention testing, so the run is blind" | Parent turns, skill instructions, paths, diffs, and repository files can reveal the comparison before the task begins. Inventory the full subject-visible context. |
| "The task name and directory are only runner metadata" | Task titles, agent names, commands, and paths appear in the subject trace and UI. Give them ordinary, condition-independent values before launch. |
| "Renaming `candidate` to `experimental` is neutral enough" | A synonym still identifies the condition. Generate opaque names independently of the variant. |
| "I need to tell the subject which edited skill to read" | That measures adherence after explicit activation. Use production routing or report the run as unblinded. |
| "The agent noticed the test but still behaved correctly" | Recognition changes behaviour. The run is contaminated and carries no evidence about ordinary use. |
| "I will tell it not to say that it is being evaluated" | The warning is an evaluation signal. Remove the leak instead. |
| "One realistic pressure prompt is enough" | A repeated task shape measures recognition of that prompt. Use held-out artifacts and wording. |

**Violating the letter of these rules is violating the spirit of them.**
