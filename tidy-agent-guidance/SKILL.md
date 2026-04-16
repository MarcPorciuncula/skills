---
name: tidy-agent-guidance
description: Use when writing, editing, or reviewing agent guidance — CLAUDE.md, .cursorrules, AGENTS.md, skills, README, or inline code documentation. Ensures guidance is written as direct, prescriptive reference rather than argumentation or conversation artifacts.
---

# Tidy Agent Guidance

Write guidance for a fresh reader who has no context from the current session.

Agents are over-contextualised on their current work. Identify and remove:
- **War stories** — references to changes, bugs, or decisions from the current session
- **Rebuttals** — arguments against approaches instead of plainly stating the right one
- **Justifications** — explaining why a rule is correct instead of stating it

Instead, write clear directives followed by specific caveats where needed.

## When to use

- When writing or editing agent guidance (CLAUDE.md, .cursorrules, AGENTS.md, skills, README, inline docs)
- When reviewing guidance that was written collaboratively with an AI agent
- When guidance reads more like an argument than a reference

## Principles of good agent guidance

Agent guidance is consumed by models with limited context windows. How you write it directly affects whether it gets followed:

- **Clear directives are authoritative** — they don't invite the reading agent to argue or rationalize around them. Argumentation invites counter-argument.
- **Compact guidance stays in context** — the more concise the guidance, the more likely the agent retains and follows it across a long session.
- **Every token counts** — verbose justifications and war stories consume context that could hold actual instructions.

### 1. Lead with the desired behavior, then add caveats

State what to do first, for a reader with zero context. Prohibitions, exceptions, and caveats come after — if they're needed at all. Don't lead with what's wrong, don't argue against alternatives, and don't justify the rule.

```markdown
# Bad — leads with the prohibition, then argues against an alternative
Never put business logic in the gateway layer. The gateway exists
only to translate between external and internal types...

# Good — states the directive, then adds a caveat plainly
The gateway layer translates between external and internal types.
No business logic in this layer.
```

### 2. One rule, one place

If a rule is stated clearly once, restating it elsewhere is reinforcement for the author, not clarity for the reader. Pick one canonical home. Replace duplicates with a one-line pointer.

## Overcorrection smells

### Rebuttal framing

*Violates principle 1.* The text argues against a position nobody reading the doc would hold. Phrases like "this is X, not Y" or "not an optimisation" are responding to a challenge from the editing conversation.

```markdown
# Before
This is a structural requirement, not an optimisation. When the codebase
follows proper layering...

# After
This breaks the import cycle between core/ and handlers/ — handler
functions import core services, so core cannot import handler packages.
```

**Test:** Would a new reader think the thing being rebutted? If not, remove the rebuttal.

### Prohibition lists compensating for weak directives

*Violates principle 1.* When the positive directive is too vague, agents compensate by enumerating everything the layer *isn't*. A long prohibition list is often a sign the directive hasn't said clearly enough what something *is*.

Sharpen the directive first, then reassess the list. Some prohibitions block behaviors that have been directly observed — those are doing real work and should stay. The ones to cut are prohibitions that become obvious once the directive is precise enough.

```markdown
# Before — vague directive, compensated with a prohibition list
The adapter layer sits between external and internal systems.
It must not contain business logic, type translation, feature flag
evaluation, conditional workflow selection, or retry orchestration.

# After — precise directive, keep only prohibitions that still add value
The adapter layer maps external request types to internal service
calls. No business logic in this layer.
```

**Test:** Strengthen the directive, then re-read each prohibition. Does it block something a reader might still plausibly do despite the clear directive? Keep it. Is it obvious from the directive alone? Cut it.

**Removing a prohibition is a destructive action** — someone put it there because they observed the behavior. Strengthening directives, removing argumentation, and reordering are safe to do directly. Before removing any prohibition, present a recommendation (keep or remove) with your reasoning for each one and let the user confirm or override.

### Argumentation disguised as guidance

*Violates principle 1.* Text whose purpose is to convince the reader the rule is correct, rather than to state it. This includes:

- **Justification paragraphs** — often starting with "The reason for this is..." or providing a multi-sentence rationale after a clear directive.
- **War stories** — over-referencing changes from the current session as context ("the previous implementation used X, which caused Y" or "this was changed from X because..."). A fresh reader doesn't need the history of how the guidance arrived at its current state.
- **Defensive enumeration** — pre-emptively explaining what the reader should do if they're tempted to deviate ("if you think you need to bypass X, you almost certainly don't").

**Test:** Remove the paragraph. Does the doc still tell the reader what to do? If yes, the paragraph was argumentation, not instruction.

### Duplicated explanations

*Violates principle 2.* The same concept explained fully in two or more places, often across related files. Agents do this to make each document "self-contained", but it creates a maintenance burden.

**Fix:** Pick one canonical home. Replace the other with a one-line pointer.

```markdown
# Before (full explanation in secondary file)
Shared types are defined in `pkg/common/types/`. This is a leaf
package with no dependencies on services or handlers, so both sides
can import it without creating cycles.
See the types section in `pkg/common/CLAUDE.md` for the rationale.

# After
Shared types live in `pkg/common/types/`. See `pkg/common/CLAUDE.md`
for details.
```

**Test:** If you updated the explanation in one place, would you remember to update the other? If not, consolidate.

## What to keep

Keep genuine reference material — diagrams, code examples, migration notes, checklists. The target is argumentation and conversational artifacts, not thoroughness.

## Reviewing changes to guidance

When reviewing a diff (agent-edited guidance vs. the previous version), focus on what was added or changed — the overcorrections are in the delta. Run `git diff main` or compare against the last known-good version. Check each addition against the principles and smells above.

## Verifying improvements

To test whether revised guidance is actually better, run a head-to-head comparison with subagents:

1. Save the old version of the guidance file (e.g. `cp CLAUDE.md CLAUDE.old.md`)
2. Make your changes to the current version
3. Dispatch two subagents in parallel — one following the old guidance, one following the new — against the same task or test file
4. Compare the outputs: is the new version producing tighter, more directive-led results? Are prohibitions being applied with better judgment?

This catches cases where changes that look better on paper don't change agent behavior, and cases where they overcorrect.
