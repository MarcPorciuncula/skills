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

<!-- SCAFFOLD -->
*Purpose:* the register/voice model — what language to produce so the guidance is followed. The `writing-pr-bodies` "Writing style" analogue.
*Sources:* `writing-agent-guidance` principles 1–3 (lead with the directive, write for a fresh reader, consolidate) recast as a voice model.
*Form:* gloss + DO / DO NOT + one worked contrast example (the explanation is the artifact, stays prose).

## 3. Hard restrictions and register reset

<!-- SCAFFOLD -->
*Purpose:* concrete bad-pattern recognition; condition the agent to reset and not over-contextualise when editing existing guidance.
*Sources:* `writing-agent-guidance` principles 2/4/5 (war story, strawman, alignment leakage, weak justification) converted from categories to concrete sentence catalogues. NET-NEW content.
*Form:* `HARD RESTRICTION:` + `RECOGNISE` + 2-col tables + `REJECT | PREFER | WHY` triples + the reset block.

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
