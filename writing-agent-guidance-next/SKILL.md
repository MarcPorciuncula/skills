---
name: writing-agent-guidance-next
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

<!-- SCAFFOLD — replace in its own step -->
*Purpose:* activation conditions for the skill.
*Sources:* current `writing-agent-guidance` "When to use" + `writing-effective-skills` trigger surface.

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
- DO apply the recognisability test below before cutting any rebuttal

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
- DO replace the justification with a one-line cost the agent can observe, when a real failure mode exists (see section 4)

**Recognisability test: cut, or promote?**

Before cutting any rebuttal or justification, apply this:

- A fresh reader would plausibly default to the rebutted behaviour → interception. Promote it to a directive form (section 4). Do not cut
- It only parses with session context → war story. Cut
- No one would do it → strawman. Cut

### REGISTER RESET: before editing existing guidance

STOP and RECOGNISE: you may be deep in a session on unrelated work, carrying a voice and context for a different activity, not for writing agent guidance. Your default instinct will be to carry that into the edit. Reframe for a fresh reader before you touch the file. Skip it and your biases will leak in. This is how guidance rots one iteration at a time.

- DO read the target file end to end and treat its voice and register as the target
- DO assume the reader has none of this conversation and none of your session context
- DO match new content to the forms already in the file: a table stays a table, a directive stays a directive
- DO NOT re-derive existing prose from memory. Edit against the file
- DO NOT carry the conversation's recap or justification into the file (see DO NOT LEAK THE ALIGNMENT CONVERSATION)

If you cannot state the file's objective, audience, and register back before
editing, you have not read it. Do that first (section 6, step 1).

## 4. How to make a rule stick

<!-- SCAFFOLD -->
*Purpose:* the device catalogue available when writing a skill or directive.
*Sources:* `writing-effective-skills` Pattern Library, seven principles as *when to use each*, hard/soft triggers, anti-rationalisation tables, letter/spirit closer; `writing-agent-guidance` §4 promotion forms including the human-only authorship guardrails.
*Form:* per device — definition + when to use + template.

## 5. Stripping rotted guidance

<!-- SCAFFOLD -->
*Purpose:* how to remove argumentation and conversational artifacts without dropping load-bearing content. Demoted from the opening to one part.
*Sources:* `writing-agent-guidance` Common violations + Safe vs destructive + What to keep.
*Form:* definition + before/after + `Test:`.

## 6. Procedure — writing or revising guidance

<!-- SCAFFOLD -->
*Purpose:* the ordered procedure for any guidance edit. Step 1 is the alignment step.
*Sources:* `writing-agent-guidance` Reviewing changes + Verifying improvements; NET-NEW alignment step.
*Form:* numbered `## Procedure` with trailing DO NOTs.

## 7. Skills: procedure and caveats

<!-- SCAFFOLD -->
*Purpose:* skill-specific procedure, pressure-testing before shipping, and the strict-workflow technique.
*Sources:* `writing-effective-skills` Testing before shipping + Extracting from docs + CLAUDE.md notes; NET-NEW strict-workflow technique with `writing-pr-bodies` as the worked exemplar.
*Form:* numbered steps + caveats + reusable blocks.

## Red flags — STOP

<!-- SCAFFOLD -->
*Purpose:* intercept the rationalisations that precede each violation, at the moment of temptation.
*Sources:* consolidated from both skills' red-flag/violation content; one row per high-risk bypass.
*Form:* `Thought | Reality` table.

**Violating the letter of these rules is violating the spirit of them.**
