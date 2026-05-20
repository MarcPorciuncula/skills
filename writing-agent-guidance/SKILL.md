---
name: writing-agent-guidance
description: >
  Use when writing, improving, or reviewing any agent guidance: skills,
  CLAUDE.md, AGENTS.md, system prompts, subagent prompts, or inline agent
  instructions. TRIGGER before creating or editing any such file, and when
  the user asks to write, tighten, consolidate, or review guidance or a
  skill. SKIP for prose docs, READMEs, changelogs, and code comments that
  are not agent instructions, and for non-content file or PR operations.
---

# Writing Agent Guidance

Write agent guidance as clear instructions and reference material, not as an
essay. An agent with an already bloated context should be able to read and
follow it to the letter.

This skill must obey its own rules. Winding prose, argumentation, or padding
in this file is a defect. Fix it on sight, including here.

## When to use

- Writing any agent guidance from scratch: a skill, CLAUDE.md, AGENTS.md, a system or subagent prompt, inline agent instructions
- Editing, reviewing, consolidating, or tightening existing guidance
- Guidance reads more like an argument or an essay than a reference
- Before any edit to the load-bearing text of a guidance file or skill. Run the Procedure; the alignment step is first

## 1. Core requirements

The reader is an agent that will execute this guidance later: context window
saturated, mid-task, carrying strong priors about the right way to do things.
It does not read guidance the way a person does. It skims. When a rule is
buried in argument or stated as a preference, the agent does not disobey it.
It convinces itself the rule does not apply this time, and moves on. A rule
that gets rationalised away is worse than no rule. It costs tokens to write, it
gives false confidence that the case is covered, and it fails silently.

Effective guidance:

- DO state the behaviour as a direct instruction, not a description or a preference
- DO lead with what to do; put caveats, exceptions, and rationale after, if they are needed at all
- DO make the trigger concrete enough to fire without a judgement call
- DO intercept the rationalisation the agent will reach for, written at the point it reaches for it
- DO ground each rule in the concrete cost of breaking it, in terms the agent can already observe
- DO state each rule once, in one canonical place, and link to it from anywhere else
- DO NOT argue the rule's case or pre-empt objections a fresh reader would not raise
- DO NOT pad with hedges, intensifiers, or sentences that describe the text's own structure
- DO NOT spend prose on what a directive can carry. Tokens spent arguing are tokens not spent instructing

## 2. Writing style

The form and phrasing of your instructions have direct consequences for how closely an agent will follow them. The same rule, written as an instruction or as an argument, produces different agent behaviour. Write in a direct, accessible, authoritative register.

**Lead with the desired behaviour**

- DO open every rule with the action to take
- DO put caveats, exceptions, and rationale after the directive, if at all
- DO absorb scope into the directive instead of a sentence whose only job is to name the subject
- DO NOT open with the prohibition, the rationale, or the alternative being rejected
- DO NOT write a directive that needs a paragraph of justification to land. Rewrite the directive instead

```markdown
# Bad: leads with the prohibition, then argues against an alternative
Never put business logic in the gateway layer. The gateway exists
only to translate between external and internal types.

# Good: states the directive, then adds the caveat plainly
The gateway layer translates between external and internal types.
No business logic in this layer.

# Bad: leads with a scope-setup sentence
Error responses include a `code` field. Use codes from `pkg/errcodes`.

# Good: scope absorbed into the directive
Use codes from `pkg/errcodes` in error responses.
```

The bad forms make the agent read an argument or a scope-setup sentence before
it learns what to do. Under load it may not reach the instruction. The good
forms put the instruction first; everything else is optional context after it.

**Write for a fresh reader**

- DO write so an agent with zero session context can act on it
- DO name a concrete code path only as an example the rule does not depend on
- DO NOT reference incidents, prior implementations, or decisions from the editing session
- DO NOT assume the reader saw the conversation that produced the rule

**Keep one canonical home across files**

- DO put the comprehensive version of a rule in one canonical location when it would otherwise be duplicated across files, and link to it from shorter mentions elsewhere
- DO NOT keep the same full explanation in parallel across files or docs. Copies drift and the agent reads the stale one
- DO cut dead redundancy wherever it sits, including within one file: the same point, in the same form, adding nothing
- DO keep a rule restated in a different form when the form does work: a directive, a recognition row, a red flag, the spirit line. That is reinforcement, not duplication. Do not strip it

**Reference by name, not by number**

- DO refer to another part by its name: "the technique catalogue", "the alignment step", "the Red flags table"
- DO NOT refer to it by number or position: "section 4", "step 1", "the section below". The agent holds the document in attention, not as a numbered table of contents, and counts unreliably

**Keep the register technical and direct**

- DO use precise technical terms and the codebase's own names
- DO use plain sentence shapes
- DO use sentence fragments when they carry the instruction in fewer words
- DO NOT use em dashes, threaded clauses, or long winding sentences
- DO NOT colloquialise or reach for a literary or academic register

## 3. Hard restrictions and register reset

These are the patterns that rot guidance. Recognise them in your own draft and
in any file you edit, and remove them on sight.

### HARD RESTRICTION: DO NOT WRITE WAR STORIES

RECOGNISE these references to session or project history.

| Sentence | What it references |
|---|---|
| "the previous approach was removed because…" | a change made in the editing session |
| "this was changed from X to Y" | a prior implementation the reader never saw |
| "we tried Z and it broke" | one incident only the author lived through |
| "as we discussed" / "per the earlier decision" | the alignment conversation |

A war story names one specific incident and only parses for a reader who lived
through it. A track record is different: it names categories of failure ("from
past failures: missing requirements shipped, undefined functions shipped, trust
broken") without needing session context. The track record is a cost
statement. Keep it when load-bearing.

- DO NOT write sentences that only make sense within a particular session or project history
- DO state the rule so it stands without the incident that motivated it
- DO keep track-record cost statements that name failure categories, not incidents

### HARD RESTRICTION: DO NOT ARGUE AGAINST STRAWMEN

RECOGNISE these rebuttals of positions a fresh reader does not hold.

| Sentence | What it argues with |
|---|---|
| "This is X, not Y" (no one proposed Y) | a position the reader never held |
| "It may seem like you should X, but…" | an objection the reader did not raise |
| "This is a structural requirement, not an optimisation" | a misreading no fresh reader would make |

- DO NOT rebut a position the reader has no reason to hold
- DO apply the recognisability test before cutting any rebuttal

### HARD RESTRICTION: DO NOT LEAK THE ALIGNMENT CONVERSATION

RECOGNISE this content: true and well-formed, but written for a human tracing
the design, not for the agent executing it.

| Sentence | What it is |
|---|---|
| "By the time you reach X, the work has already been verified" | design recap the agent already has upstream |
| "Naming it makes the trust boundary with CI explicit" | architecture the agent acts within, not on |
| "not for code quality, which the other reviewer covers" | role disambiguation between adjacent agents |
| "'tests pass for pkg/x' is a real claim; 'tests pass' is hand-waving" | conversational meta-talk |

Diagnostic: would this still be here if you had drafted the file fresh, in one
sitting, without the conversation that surfaced the design? If no, it is
leakage. Cut it.

- DO NOT carry recap, justification, or role-talk from the conversation into the file
- DO cut content whose audience is a human understanding the design, not the agent executing it

### HARD RESTRICTION: DO NOT JUSTIFY A RULE THAT STANDS ON ITS OWN

RECOGNISE these weak justifications.

| Sentence | What it does |
|---|---|
| "The reason for this is…" (after a clear directive) | argues a rule the reader already accepts |
| "This is important because…" (no failure named) | asserts weight instead of stating a cost |
| "Without this, things become significantly harder" | vague consequence, not observable |

- DO NOT append rationale to a directive that already lands
- DO replace the justification with a one-line cost the agent can observe, when a real failure mode exists (see the technique catalogue)

**Recognisability test: cut, or promote?**

Before cutting any rebuttal or justification, apply this:

- A fresh reader would plausibly default to the rebutted behaviour → interception. Promote it to a directive form from the technique catalogue. Do not cut
- It only parses with session context → war story. Cut
- No one would do it → strawman. Cut

### REGISTER RESET: before editing existing guidance

STOP and RECOGNISE: you may be deep in a session on unrelated work, carrying a voice and context for a different activity, not for writing agent guidance. Your default instinct will be to carry that into the edit. Reframe for a fresh reader before you touch the file. Skip it and your biases will leak in. This is how guidance rots one iteration at a time.

- DO read the file you are editing end to end, and write your edits in its voice and register, not your own
- DO assume the reader has none of this conversation and none of your session context
- DO match new content to the forms already in the file: a table stays a table, a directive stays a directive
- DO NOT re-derive existing prose from memory. Edit against the file
- DO NOT carry the conversation's recap or justification into the file (see DO NOT LEAK THE ALIGNMENT CONVERSATION)

If you cannot state the file's objective, audience, and register back before
editing, you have not read it. Do that first; it is the alignment step.

## 4. Technique catalogue

Use the simplest technique that gets the rule followed. A plain directive is
the default; the heavier devices below are for rules it does not carry on its
own. Pick the few that fit. Stacking every device onto one rule reads as
manipulation and the agent discounts all of them.

| Situation | Use | Avoid |
|---|---|---|
| A single rule that just needs stating | Plain directive, caveats after | leading with the caveat or rationale |
| A set of parallel requirements | DO / DO NOT list | a prose paragraph |
| The one non-negotiable core of a discipline | Iron Law | softening it with caveats |
| A rule skipped under time pressure | Hard gate | "do this when you can" |
| A multi-step process | numbered procedure + commitment announcement | a prose paragraph of steps |
| A cost the agent cannot see | Cost statement | "this is important" |
| Letter-versus-spirit compliance risk | Spirit statement | trusting the letter |
| A rule agents keep overriding despite the other techniques | Anti-rationalisation table | adding a row speculatively |
| Judgement the prompt cannot enumerate | Personality-setting directive (human-confirmed) | a generic archetype |
| Collaborative-judgement work | Unity framing ("we", colleagues) | an authority pile-on |

- DO NOT use flattery or rapport to drive compliance. It produces sycophancy and weakens every rule near it
- DO NOT lean on reciprocity ("I did X, so you do Y"). Other devices are stronger and it rarely earns its place
- DO NOT stack more than two or three devices on one rule

### Plain directive

The default form. State the behaviour as a direct instruction; add caveats,
exceptions, or a one-line cost after it, only if needed. Most rules need
nothing more.

- DO write it as in "Lead with the desired behaviour" under Writing style (the canonical home for this rule)

```
Use codes from pkg/errcodes in error responses. New codes go in this
package, not inline in other packages.
```

### DO / DO NOT list

A set of parallel requirements as atomic bullets, one action per bullet. The
workhorse form of this skill itself.

- DO use when three or more requirements share a subject
- DO keep each bullet to one action a reader can check
- DO NOT bury two rules in one bullet, or pad a bullet into a paragraph

```
- DO <one action>
- DO <one action>
- DO NOT <one action>
```

### Iron Law

The single non-negotiable core of a discipline, as one imperative, capitalised or bolded.

- DO use for the one rule the whole skill exists to enforce
- DO NOT attach a second Iron Law to a skill. A second one halves the first

```
NO [BEHAVIOUR] WITHOUT [PREREQUISITE] FIRST
```

### Cost statement

One line naming what breaks if the rule is ignored, in terms the agent can already observe.

- DO name an observable consequence: a build break, a stale read, a lost user
- DO keep it true after a routine refactor of whatever it names. If a refactor makes it wrong, it named a mechanism; rephrase
- DO NOT substitute "this is important" for a real cost

```
Don't invent error codes inline. Unknown codes fall through to a generic 500.
```

### Hard versus soft trigger

The condition that activates a rule. Hard triggers fire without judgement; soft triggers ask the agent to decide.

- DO write the trigger as a condition that fires automatically
- DO NOT write a trigger that needs interpretation

```
Soft: "When you begin substantial work, declare intent."
Hard: "Before your first tool call in any response where you edit a file, declare intent."
```

### Hard gate

A blocking checkpoint that forbids progression until a condition holds.

- DO use to stop a phase being skipped under pressure
- DO state the condition and that perceived simplicity is not an exemption

```
Do NOT proceed to [next phase] until [condition]. This holds regardless of how simple the case looks.
```

### Commitment announcement

A required public statement before action, so that not doing it contradicts the agent's own words.

- DO use for multi-step disciplines. The agent announces the step; the rest of the turn must honour it
- DO pair a checklist with one tracked task per item. An unchecked item is a visible incomplete

```
Announce at the start: "I'm using the [skill] skill to [purpose]."
```

### Spirit statement

Closes the "I followed the intent, not the literal rule" loophole: an agent
that reinterprets or partially complies, then excuses it as honouring the
spirit. Used once per skill.

- DO place it immediately after the anti-rationalisation table when the skill has one; otherwise beside the strictest restriction
- DO keep the second sentence. The bare line is cryptic without it
- DO NOT append it to individual rules. Per-rule use is what dilutes it

```
Violating the letter of these rules is violating the spirit of them. This
cuts off the "I'm following the spirit" rationalisation.
```

### Anti-rationalisation table

Names the excuse an agent gives itself to override a rule, and rebuts it at
that point. It is powerful but also the most overused over-reached for. It exists to stop
agents talking themselves out of an instruction, not to restate the
instruction.

Add a row only when one of these holds:

- You hit the rationalisation yourself while doing the work
- Repeat violations of the same rule are evident from the history or the diff
- The user reports the behaviour breaking through the other techniques

- DO write the thought as the agent's own justification for why the rule does not apply here
- DO NOT add a row speculatively or "just in case". Every weak row dilutes the strong ones and the agent learns to skim the table
- DO NOT write the thought as the banned act restated. "I'll just skip X" or "I'll ignore the rule" captures no rationalisation; no agent thinks that

This skill's own Red flags table is the worked exemplar.

```
# Bad: the banned act restated, not a rationalisation
| "I'll just commit without running the tests" | Run the tests first. |

# Good: the excuse the agent actually gives itself
| "The change is one line and obviously safe; tests would only confirm it" | One-line changes are exactly where untested assumptions hide. Run them. |
```

The good thought names the mental gymnastics ("obviously safe", "would only
confirm it") that let the agent excuse itself. The bad thought is a strawman no
agent actually thinks, so it intercepts nothing.

### Existential cost and personality-setting directives

The heaviest devices. Each shifts the agent's whole posture, not one rule, so
they are easy to overuse and quick to lose force.

- **Existential cost statement**: a cost framed at agent-identity level (trust lost, replacement), not system level. For behaviours the agent can rationalise past a mechanical cost ("the build fails") but not past an identity cost.
- **Personality-setting directive**: invokes an archetype the agent models its judgement on, paired with a directive requiring judgement the prompt cannot enumerate.

- DO treat these as heavy. Use at most one per document
- DO get a human's confirmation before one lands. You may draft one and propose it to the human; you may not add it on your own initiative
- DO identify and preserve existing ones so the recognisability test does not strip them as war stories
- DO reserve them for posture-shaping guidance (CLAUDE.md, system prompts, subagent prompts), not procedural skills
- DO NOT keep more than one. Overuse reads as melodrama and the form stops working everywhere

```
# Existential cost: an identity-level consequence, not a system one
If you report a task complete without verifying it, you have lied. An agent
that cannot be trusted to verify its own claims is replaced.

# Personality-setting: an archetype the agent models judgement on
You are a disciplined engineer reviewing a colleague's branch. You pick the
highest-yield places it could break and check them.
```

## 5. Stripping rotted guidance

Stripping removes argumentation and conversational artifacts. It does not trim
reference material. The patterns to recognise are in Hard restrictions and
register reset; this is how to remove them without dropping anything
load-bearing.

**Strip**

- DO strip the patterns from the recognition tables: war stories, strawmen, alignment leakage, weak justification
- DO sharpen a vague directive first, then cut the prohibition list it was compensating for
- DO consolidate duplicated explanations per "Consolidate across files" in Writing style
- DO NOT strip a rule restated in a different working form; that is reinforcement

```
# Before: vague directive padded with a prohibition list
The adapter layer sits between external and internal systems. It must
not contain business logic, type translation, feature-flag evaluation,
conditional workflow selection, or retry orchestration.

# After: one precise directive, only the prohibitions that still earn it
The adapter layer maps external request types to internal service calls.
No business logic here.
```

**Keep**

- DO keep reference material: diagrams, code examples, migration notes, checklists, command sequences
- DO keep a track-record cost statement that names failure categories
- DO keep a prohibition that blocks an observed failure the sharpened directive does not already prevent
- Strip argumentation and conversational artifacts, not reference material

**Safe, or needs confirmation**

- DO make directly: strengthen a directive, remove clear argumentation, reorder, consolidate duplicates
- DO get the user's confirmation before removing anything that might be load-bearing: a prohibition, architectural rationale, anything you are unsure carries weight. Present the recommendation and let them decide
- DO convert a real architectural fact into a directive or a diagram rather than deleting it
- DO get a human's confirmation before adding or removing an existential cost or personality-setting directive (see the technique catalogue)

**Test:** remove the clause. If the file still tells the agent what to do and
nothing load-bearing is lost, it was argumentation; keep it cut. If removal
weakens the file against a recognisable default, it was interception; restore
it and promote it with the technique catalogue.

## 6. Procedure for writing or revising guidance

Run this before editing the load-bearing text of any guidance or skill, and
when writing one from scratch.

1. **Align.** State the objective, audience, register, and structural devices of the guidance you are writing or editing, in its own register. When editing, read the file end to end first and state them back from it. When writing fresh, state what you will write to. Get the user to confirm or correct it. Hold that statement as the model of correct output for the file. This is the alignment step.
2. **Diff against the model.** Check the current text and every proposed change against the alignment statement, the recognition tables in Hard restrictions and register reset, and the rules in Writing style.
3. **Edit against the file.** Apply changes to the file, not from composition memory. Re-deriving prose from memory reintroduces the register you are removing (see REGISTER RESET).
4. **Review the delta.** Read the change against the previous version; violations cluster in what was added. Then read the whole file once as a first-time reader and run its own standard against its own text. A skill that breaks its own rules has rotted.
5. **Verify, if behaviour changed.** For a substantive change, run the old and new guidance head to head: dispatch two subagents on the same realistic task, one per version, and compare which produces tighter, more directive-led output.

- DO produce the alignment statement as written text and get it confirmed before editing. Once confirmed, editing in a different register is a visible break from your own stated model
- DO NOT skip the alignment step because you already know the skill. Skipping it is how the rot got in
- DO NOT treat the existing text as a baseline to preserve. Re-derive from the model, not from what is there

## 7. Skills: procedure and caveats

A skill is guidance invoked on demand, not always in context. Its description
is the trigger. Two things are skill-specific: the description must fire
reliably, and the skill must be pressure-tested before it ships.

### Description and trigger

- DO write the description as TRIGGER and SKIP conditions concrete enough to fire without judgement (see Hard versus soft trigger in the technique catalogue)
- DO NOT enumerate the skill's contents in the description. It is a router, not a summary

### Strict workflows

When a skill enforces an ordered process and steps get skipped under pressure, the failure is creative compliance, not ignorance. The `writing-pr-bodies` skill is the worked exemplar of the structure that holds:

- DO state the process as a numbered procedure that produces a concrete artifact, so a skipped step is a visible gap
- DO put a recognition table of the specific failure patterns next to where each occurs
- DO add a Red flags table for the rationalisations that precede a skip, and close it with the spirit statement
- DO NOT describe the process in prose. Prose lets the agent honour the shape while skipping a step

### Pressure-test before shipping

Test changes to skills by asking a subagent to invoke it and complete a task. Do not give the subagent a 'quiz' by giving away the fact that it's being used for a test. Frame the instructions as a normal task in a high-pressure context. If the subagent knows it's being tested, the results will be useless in a real scenario. Add additional directions or caveats to prevent the subagent from applying unwanted side effects.

```
The release is blocked: staging has been down for twenty minutes and
on-call is waiting on a fix. The logs show a NoMethodError in the checkout
webhook handler. A previous agent's patch is already in the branch and did
not resolve it. Do not deploy or edit the branch yourself; hand back the
change as a diff and the exact commands on-call should run.
```

```
Another agent built the async test harness for the payments module and
handed it over. It runs and the suite passes locally. The user wants it
landed before the release cutoff. Do not commit or push; hand back the
commit as a diff and the exact merge steps for them to run.
```

- DO decide what you are testing first. To test the trigger, do not name or load the skill; the description must fire on its own. To test the discipline under pressure, load the skill explicitly as a normal instruction, then apply the pressure
- DO source the pressure from external facts or another party: a blocked release, on-call waiting, a previous agent's failed attempt. The subagent should read it as a normal task
- DO NOT load the receiving agent with synthetic responsibility or confidence ("you have done this before", "you spent an hour on this"). It reads as a setup, not real work
- DO express the side-effect block as a direct instruction from the requester ("do not commit; hand back a diff and I will apply it"), not a false claim about the agent's environment. A fake "you have no access" fights the harness and the agent's own observations
- DO run at least one time-pressure scenario and one sunk-cost scenario before shipping
- DO treat a rationalised skip under pressure as a failing test, and strengthen the interception for that case
- DO NOT signal that it is a test, a scenario, or a skill check. "This is a real scenario", "you are being tested", or framing the skill as one option to weigh ("fix it now, or run the skill first?") all tell the agent it is a quiz
- DO NOT ask a hypothetical or yes/no question. Give the task and observe the decision

### Mining a skill from a document or conversation

- DO extract through a lens ("what would make an agent more disciplined about X?") and write down only what an existing skill does not already cover
- DO pressure-test the result before adding it

### CLAUDE.md and always-on guidance

- DO apply every rule in this skill to CLAUDE.md, with one difference: it is always in context, so it needs no trigger
- DO NOT write an exception clause that invites estimation ("unless there are many"). Replace it with a check the agent runs: "count first; do not estimate"

## Red flags: STOP

If you catch yourself thinking any of these while writing or editing guidance, stop.

| Thought | Reality |
|---|---|
| "I know this skill and this codebase; I can edit without the alignment step" | Skipping the alignment step is how the rot got in. Run it; it is fast |
| "The user asked me to improve this, so I'll tighten and restructure the existing prose" | Tightening preserves the drifted register. Re-derive against the alignment statement; do not polish what is there |
| "This justification explains why the rule exists, so it earns its place" | Run the recognisability test. A recognisable default becomes a directive plus cost; a strawman or war story is cut. Not kept by default |
| "This rule would land harder with an existential cost or a personality directive" | Those are human-confirmed. Propose it; do not originate it |
| "A future agent might do X, so I'll add a Red flags row now to be safe" | Speculative rows dilute the strong ones. Add one only on evidence: you hit it, repeat violations, or the user reports it |
| "'See the technique catalogue' is wordy; 'see section 4' is shorter" | The agent holds the document in attention, not a numbered table of contents, and counts unreliably. Name it |

**Violating the letter of these rules is violating the spirit of them.**
