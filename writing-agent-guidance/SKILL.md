---
name: writing-agent-guidance
description: >
  Write, revise, or review instructions that an agent will execute, including
  skills, AGENTS.md, CLAUDE.md, system prompts, subagent prompts, and inline
  agent instructions. TRIGGER before creating or materially editing agent
  guidance and when the user asks to improve, consolidate, or review a skill.
  SKIP human-facing prose, quoted guidance that will not be revised, and
  non-content file, Git, or pull-request operations.
---

# Writing Agent Guidance

Write guidance that lets a capable agent select and perform the intended
behaviour without access to the drafting conversation. Keep the normal method
complete in the guidance or skill bundle. Do not assume that a harness-specific
authoring skill is installed.

## Check applicability after loading

When this skill loads automatically, confirm that the task creates, revises, or
reviews instructions that an agent will execute.

If the task only moves guidance files, changes non-content metadata, performs
Git or pull-request operations, quotes guidance without revising it, or writes
human-facing prose, ignore the remainder of this skill. Continue the task with
the applicable guidance.

When the user explicitly invokes this skill, treat that invocation as evidence
that they want it applied. Follow their requested scope even when another
guidance source would normally own the artifact.

## Start from the required behaviour

Before drafting, identify:

- The medium and where it loads
- The behaviour the guidance must change or preserve
- The agent or harness that will read it
- The context the reader can rely on
- The cost and recoverability of an incorrect choice
- The amount of valid implementation freedom

Read an existing artifact end to end before revising it. Infer routine details
from the artifact, repository, and harness. Ask the user only when plausible
interpretations would materially change the guidance or remove a load-bearing
constraint.

Assume the reader is capable but may encounter the guidance mid-task with
competing context and strong priors. Include information that changes a
decision or action. Omit explanations of concepts the reader already knows.

## Calibrate constraint strength

Match the form to the behaviour's variability, fragility, and failure cost.

| Situation | Guidance form |
|---|---|
| Several outcomes or approaches are valid | Principle, heuristic, or selection criteria |
| One approach is usually best but exceptions are legitimate | Default plus the conditions for departing from it |
| A result must satisfy parallel requirements | Atomic checklist or DO / DO NOT list |
| An order matters and a skipped step invalidates later work | Numbered procedure with observable checkpoints |
| Progression would be unsafe or destructive before a condition holds | Hard gate |
| Agents repeatedly override a clear rule | Evidence-based cost or anti-rationalisation device |

- Use a plain directive before adding a compliance device.
- Keep judgment where the task genuinely requires judgment.
- Add exact commands, scripts, schemas, or gates when variation is dangerous or
  deterministic repetition is more reliable.
- Do not make guidance rigid because the subject is important. Use stronger
  constraints when the allowed path is narrow or a wrong choice is costly.
- Use `must`, `always`, and `never` only for requirements that have no ordinary
  exception within the stated scope.
- Preserve prerequisite semantics such as `only if`, `unless`, `before`, and
  `after`. Do not turn a necessary condition into a sufficient trigger.

## Write instructions and facts distinctly

### Write controllable behaviour as instructions

- Start an unconditional instruction with the action.
- Start a conditional instruction with the condition, then give the action.
- Use the imperative or infinitive form.
- Give one independently checkable action per sentence or bullet.
- Prefer active voice and a direct verb.
- State the required alternative beside a prohibition when the agent would not
  otherwise know what to do.
- Put caveats and rationale after the instruction they qualify.
- Absorb a single rule's scope into its instruction instead of opening with a
  redundant scope sentence.

### Reserve declarative prose for facts

Use declarative sentences for stable facts, ownership boundaries, definitions,
and mental models that help the agent choose an action. Keep them close to the
decision they inform.

Apply this test:

- If the reader can comply with or violate the sentence, write an instruction.
- If the sentence can only be true or false independently of the reader, write
  a fact.

Do not disguise a directive as an invariant:

```markdown
# Unclear: controllable behaviour written as three facts
Feature modules select semantic roles. `theme.css` owns theme values. Shared
primitives own repeated state combinations.

# Clear: three actions
Use semantic roles in feature modules. Define theme values in `theme.css`. Put
repeated state combinations in shared primitives.
```

When several facts define ownership or a decision boundary, prefer a compact
table or diagram over a dense declarative lede.

## Use plain technical language

Apply this profile, derived from ASD-STE100 Simplified Technical English, to
agent instructions. It is a readability profile, not a claim of STE
compliance.

- Keep sentences short enough to resolve in one reading. Split independent
  clauses or use a list when a sentence carries several ideas.
- Put a condition before the action it governs.
- Give one instruction per sentence unless actions must occur together.
- Prefer active voice. Use passive voice when the actor is unknown or when
  changing the voice would change the technical meaning.
- Use a direct verb instead of a noun phrase that names the same action.
- Use one consistent term for each concept. Preserve established technical
  names and identifiers.
- Use vertical lists for complex, parallel, or sequential information.
- Keep each paragraph on one topic.
- Avoid idioms, decorative phrasing, and unexplained abbreviations that carry
  required meaning.

Read [STE-inspired language reference](references/ste-inspired-language.md)
when reviewing language behaviour, deriving examples, or deciding whether a
stricter STE rule belongs in agent guidance.

## Keep guidance independent of its drafting session

- Write for a reader who did not participate in the conversation that produced
  the guidance.
- Remove editing history, abandoned approaches, and incident narration unless
  the history is durable reference material the reader must act on.
- Keep rationale when it defines an architectural boundary, explains a
  surprising constraint, or changes how the agent chooses between valid paths.
- Replace vague importance claims with an observable consequence when the
  consequence helps the agent decide.
- Use the codebase's names and precise technical terms.
- Use generic examples that demonstrate the pattern without coupling the rule
  to the current editing task.
- Put the comprehensive form of a rule in one canonical location. Link to it
  elsewhere instead of maintaining parallel copies.
- Include the minimum fallback needed to act when a linked or sibling guidance
  source is not guaranteed to be available.

## Recognise common guidance failures

| Pattern | Recognition | Response |
|---|---|---|
| War story | The text names a past incident or prior version that the reader did not see | State the durable rule, fact, or failure category without the incident |
| Drafting-session leakage | The text recaps the conversation, alignment process, or roles between authors | Keep only information the executing agent uses |
| Strawman rebuttal | The text argues against a position a fresh reader would not plausibly hold | Remove it or state the required behaviour directly |
| Weak rationale | The text says a rule is important without naming a decision or consequence | Remove it or state the relevant consequence |
| Coined label | A new slogan or label-colon construction stands in for an instruction | State the instruction or fact directly |
| Declarative command | The agent can violate a sentence that is written as a fact | Rewrite it in imperative form |
| Duplicate summary | A link site paraphrases the canonical rule and can drift | Name the source and relevant heading; add only required fallback |
| Over-enforcement | A heuristic gains gates, announcements, and rebuttals without evidence | Return to the lightest form that protects the behaviour |

Before removing apparent rationale or repetition, test whether it intercepts a
plausible default or preserves a boundary. Promote a useful insight into a
clear instruction, condition, or cost. Remove content that only makes sense in
the drafting session.

## Select structural and compliance techniques

Use the lightest technique that reliably protects the required behaviour.

| Technique | Use when | Limits |
|---|---|---|
| Plain directive | A rule only needs to be stated clearly | Default form |
| Shared mental model | Several rules depend on the same classification or boundary | Keep it factual and short; do not hide directives inside it |
| DO / DO NOT list | Three or more parallel requirements share a subject | Keep one checkable action per bullet |
| Cost statement | The reader cannot see a consequence that affects its choice | Name an observable, durable consequence |
| Iron Law | One non-negotiable rule defines the discipline | Use at most one; omit when legitimate exceptions exist |
| Hard gate | A later phase is invalid, unsafe, or destructive before a condition holds | State the condition and prohibited progression |
| Commitment announcement | A public commitment materially improves adherence to a multi-step discipline | Do not require announcements for routine work |
| Anchor to a known concept | A stable, widely known concept conveys the shape accurately | Do not use a team-specific or unexplained comparison |
| Anti-rationalisation table | A repeated, evidenced excuse overrides an otherwise clear rule | Do not add speculative rows |
| Spirit statement | Literal compliance repeatedly defeats the intended invariant | Use once and only with a concrete letter-versus-spirit risk |
| Personality-setting directive | Judgment cannot be enumerated and a specific archetype usefully constrains it | Get human confirmation; reserve for posture-shaping guidance |
| Existential cost statement | Mechanical consequences have failed and trust-level framing is intentionally required | Get human confirmation; use at most one |
| Unity framing | Collaborative judgment benefits from treating the agent and user as colleagues | Do not use rapport, flattery, or reciprocity to compel compliance |

Do not stack more than two or three devices on one rule. Additional devices can
make every signal easier to ignore. Read [rewrite and technique
examples](examples.md) when a heavier device appears necessary.

## Put guidance where it will be available

Choose the medium by the behaviour's scope and trigger. Follow the user's
chosen file when they name one.

| Guidance | Usual home |
|---|---|
| Fired by a nameable action or task | Skill loaded near that action |
| Ordered procedure that must be available at the moment of use | Skill or dedicated prompt |
| Repository-wide orientation or always-relevant policy | Root `AGENTS.md`, `CLAUDE.md`, or harness equivalent |
| Directory-specific rules | The nearest supported directory guidance file |
| Subagent role, output contract, or stopping condition | Subagent prompt or prompt template |
| Detailed educational or reference material | Bundled reference loaded when needed |
| Data or invariant bound to one code area | Stable adjacent documentation or a scoped guidance file |

- Keep always-loaded guidance concise. Every line competes with the task and
  other policies.
- Put action-fired guidance where it can load near the action instead of
  relying only on distant orientation text.
- Follow ownership of the behaviour, not the file already open during the
  editing session.
- Treat sibling skills as independently installed. Qualify optional references
  with `if available` and give a fallback for required behaviour.
- Keep the normal workflow usable without any harness-specific authoring skill.

## Revise existing guidance safely

Preserve:

- Requirements, prohibitions, and exceptions that still affect behaviour
- Architecture, ownership, compatibility, safety, and rollout boundaries
- Commands, diagrams, schemas, examples, migration notes, and checklists that
  provide non-obvious reference
- Existing structure and terminology when they remain fit for the objective

Change directly when the edit strengthens an instruction, removes clear
session leakage, repairs ambiguity, or consolidates exact duplication. Ask the
user before removing content that may be load-bearing or changing the
artifact's objective, audience, authority, or enforcement posture.

Match the existing voice during a focused edit. Reorganise or rewrite the whole
artifact when its current structure prevents the requested outcome and the
user has authorised that scope.

## Procedure

1. **Check applicability.** Apply the post-load check before producing
   announcements, artifacts, or side effects required by the skill.
2. **Inspect the artifact and context.** Read the complete guidance, applicable
   higher-priority instructions, linked sources needed for the edit, and the
   relevant harness or repository conventions.
3. **Align to the outcome.** Identify the medium, objective, reader, available
   context, register, degree of freedom, and load-bearing constraints. State
   this alignment to the user when it communicates a material decision. Ask
   for confirmation only when an unresolved choice would change the result.
4. **Classify the content.** Distinguish instructions, triggers, facts,
   definitions, caveats, costs, examples, and reference material. Rewrite
   ambiguous declarative commands before polishing style.
5. **Select constraint strength and structure.** Choose the lightest forms that
   protect the behaviour. Add stronger devices only for fragility, failure
   cost, or evidenced noncompliance.
6. **Draft or edit.** Write against the artifact and preserve its technical
   meaning. Use the plain-language profile and generic examples.
7. **Review the delta and the whole artifact.** Check additions first, then read
   the final artifact without relying on the drafting conversation. Remove
   leakage, inconsistent terminology, accidental duplication, unsupported
   rigidity, and instructions disguised as facts.
8. **Validate proportionally.** Run structural validation when available.
   Forward-test when routing, judgment, or compliance behaviour materially
   changed, is uncertain, or addresses a known failure.

## Skill-specific guidance

### Write the description as a router

Include what the skill does and concrete conditions for when it should load.
Add useful exclusions when adjacent tasks use the same vocabulary. Keep the
normal workflow in the body rather than summarising its steps in metadata.

### Add a post-load bailout when routing is imperfect

Add a bailout when a broad description or external loader has a recognizable
false-positive class. Put it before announcements, artifacts, gates, or other
side effects.

State the concrete condition that makes the skill inapplicable. Tell the agent
to ignore the remainder of the skill and continue the user's task with the
applicable guidance.

```markdown
## Check applicability after loading

If this task only inspects an existing report and does not create or revise a
report, ignore the remainder of this skill. Continue the inspection without
applying the report-authoring workflow.
```

- Do not use a discretionary condition such as "if this skill seems
  irrelevant."
- Do not repeat every metadata exclusion in the body. Cover false positives
  that remain plausible after routing.
- Do not turn the bailout into permission to escape a load-bearing rule after
  the skill is applicable.
- Treat explicit user invocation as evidence of applicability unless the user
  says otherwise.

### Keep optional resources portable

Keep the core workflow and decisions in `SKILL.md`. Move detailed variants,
large examples, domain reference, and deterministic utilities into bundled
resources. Link each resource from the core and state when to read or run it.

When another skill owns a useful step, invoke it only if available. Include a
local fallback for any step required to complete the current skill.

### Use strict workflows selectively

Use a numbered procedure when order is part of correctness. Give each required
step an observable result or checkpoint when a skipped step would otherwise be
invisible. Do not add commitment announcements, hard gates, recognition tables,
and a spirit statement to every ordered workflow.

Add those devices individually when the applicable selection criteria in this
skill justify them.

## Validate behavioural changes

Use static review for wording changes that cannot alter routing, decisions, or
side effects. Validate frontmatter and bundled structure with the harness's
validator when one is available.

For a behavioural change:

1. Define the observable decision, output, or side effect the guidance should
   change.
2. Use a control and candidate with identical task prompts and raw artifacts.
3. Run each in a fresh context that does not expose the diagnosis, expected
   result, variant name, or authoring conversation.
4. Activate the skill through the normal routing mechanism when testing its
   trigger. Record an explicitly named activation as an adherence test, not a
   routing test.
5. Score observable behaviour against criteria written before the run.
6. Confirm an apparent improvement on held-out tasks with different wording
   and artifacts.

Use `pressure-test-skills` if it is available. Otherwise run the isolated
comparison directly and state any limitation in the harness, context isolation,
or sample size.

Do not require a behavioural test when the expected result is already
deterministic from a structural validator or the change cannot affect agent
behaviour.
