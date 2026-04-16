---
name: writing-agent-guidance
description: Use when writing, editing, or reviewing agent guidance — CLAUDE.md, .cursorrules, AGENTS.md, skills, or inline code documentation. Ensures guidance reads as direct, prescriptive reference rather than argumentation or conversation artifacts.
---

# Writing Agent Guidance

Write agent guidance like a reference manual. A fresh reader with zero context should understand immediately.

Common problems to identify and remove:

- **War stories** — references to changes, bugs, or decisions from a previous session
- **Rebuttals** — arguments against approaches instead of plainly stating the right one
- **Justifications** — explaining why a rule is correct instead of stating it

These appear in any collaboratively-written guidance, but are especially frequent when agents have been involved in the writing.

## When to use

- When writing agent guidance from scratch (CLAUDE.md, .cursorrules, AGENTS.md, skills, inline docs)
- When editing or reviewing existing guidance
- When guidance reads more like an argument than a reference

## Principles

Agent guidance is consumed by models with limited context windows. How you write it directly affects whether it gets followed:

- **Clear directives are authoritative** — they don't invite the reading agent to argue or rationalise around them. Argumentation invites counter-argument.
- **Compact guidance stays in focus** — the more concise the guidance, the more likely the agent retains and follows it across a long session.
- **Every token counts** — verbose justifications consume context that could hold actual instructions and water down their effectiveness.

### 1. Lead with the desired behavior, then add caveats

State what to do first, for a reader with zero context. Prohibitions, exceptions, and caveats come after — if they're needed at all. Don't lead with what's wrong, don't argue against alternatives, and don't justify the rule. If a directive needs a paragraph of justification to land, rewrite the directive more precisely.

This applies to individual directives and sections. Structural framing (introductions, summaries) is excluded.

```markdown
# Bad — leads with the prohibition, then argues against an alternative
Never put business logic in the gateway layer. The gateway exists
only to translate between external and internal types...

# Good — states the directive, then adds a caveat plainly
The gateway layer translates between external and internal types.
No business logic in this layer.
```

### 2. Write for a fresh reader

Guidance should make sense to someone encountering the codebase for the first time. References to specific incidents, previous implementations, or decisions from the editing session are noise to this reader. Naming a concrete code path as an example is fine, but the guidance should work without it — if removing the reference makes the directive unclear, rewrite the directive to stand alone.

### 3. Consolidate overlapping guidance

When guidance must live in multiple places, pick one canonical location for the comprehensive version and reference it from others. Distributed variations (context-sensitive abridgements, wider-scoped summaries) should always link to the detailed guidance.

## Common violations

### Duplicated explanations

*Violates principle 3.* The same concept explained in full in multiple places within a single file, or copy-pasted across files with no clear canonical source.

**Fix:** Pick one canonical home. Other locations carry a pointer.

```markdown
# Before (full explanation then near-identical restatement)
Validate all request bodies at the handler boundary using the shared
validation schemas in `pkg/validation/`. The schemas use struct tags
for declarative validation, run automatically by the middleware.
See `pkg/validation/README.md` for details.

Validate all request bodies at the handler boundary. Use the shared
schemas in `pkg/validation/` — see `pkg/validation/README.md`.

# After
Validate all request bodies at the handler boundary. Use the shared
schemas in `pkg/validation/` — see `pkg/validation/README.md` for
details. Middleware runs struct-tag validation before the handler.
```

**Test:** If you updated the explanation in one place, would you forget to update the other? If so, consolidate.

### Rebuttal framing

*Violates principle 1.* The text argues against a position nobody reading the doc would hold. Phrases like "this is X, not Y" or "not suitable here because" are responding to a challenge from the editing conversation, not instructing a reader.

```markdown
# Before
This is a structural requirement, not a performance optimisation.

# After
(remove — state the structural requirement directly instead)
```

**Test:** Would a fresh reader think the thing being rebutted? If not, remove the rebuttal.

### Argumentation disguised as guidance

*Violates principles 1 and 2.* Text whose purpose is to convince the reader the rule is correct, rather than to state it. Forms include:

- **Justification paragraphs** — rationale after a clear directive, often starting with "The reason for this is..." or explaining consequences of not following the rule ("without this, X becomes difficult").
- **Session-specific references** — references to previous implementations, past decisions, or changes that produced the current guidance ("the previous approach was removed because...", "this was changed from X to Y"). A fresh reader doesn't need the history of how the guidance arrived at its current state.
- **Defensive enumeration** — pre-emptively explaining what the reader should do if they're tempted to deviate.
- **Embedded justifications** — justifications attached to otherwise-clear prohibitions or directives ("don't use X — it produces output that Y can't parse"). If the prohibition is clear on its own, the justification is argumentation.

```markdown
# Before — justification-first framing
Structured logging is essential for maintaining observability across
the service mesh. Without consistent structured logs, correlating
requests across service boundaries becomes significantly more difficult.

Use `pkg/log` for all logging.

# After — directive first, no justification needed
Use `pkg/log` for all logging. Every handler logs request ID, method,
and path at entry. Add contextual fields for business-relevant data.
```

**Test:** Remove the paragraph or clause. Does the doc still tell the reader what to do? If yes, it was likely argumentation. If the text is an introduction or forward summary, it's not argumentation — see principle 1.

### Prohibition lists compensating for weak directives

*Violates principle 1.* When the positive directive is too vague, authors compensate by enumerating everything the thing *isn't*. If a prohibition list is long, sharpen the directive first.

Sharpen the directive first, then reassess. Some prohibitions block behaviours that have been directly observed — those should stay. Cut ones that become obvious once the directive is precise enough.

```markdown
# Before — vague directive, compensated with a prohibition list
The adapter layer sits between external and internal systems.
It must not contain business logic, type translation, feature flag
evaluation, conditional workflow selection, or retry orchestration.

# After — precise directive, keep only prohibitions that add value
The adapter layer maps external request types to internal service
calls. No business logic in this layer.
```

**Test:** Strengthen the directive, then re-read each prohibition. Does it block something a reader might still plausibly do despite the clear directive? Keep it. Is it obvious from the directive alone? Cut it.

## Safe vs. destructive changes

Strengthening directives, removing clear argumentation, reordering, and consolidating duplicates are safe to do directly.

Removing content that might be load-bearing — prohibitions, context that could encode architectural rationale, anything where you're unsure — is destructive. Before removing, present a recommendation with your reasoning and let the user confirm or override. If the content encodes a real architectural fact, convert it to a clear directive or diagram rather than deleting it.

## What to keep

Keep genuine reference material — diagrams, code examples, migration notes, checklists. The target is argumentation and conversational artifacts, not thoroughness.

## Reviewing changes to guidance

When reviewing a diff (edited guidance vs. the previous version), focus on what was added or changed — violations are more likely in the delta. Run `git diff main` or compare against the last known-good version. Check each addition against the principles and violations above.

## Verifying improvements

To test whether revised guidance is actually better, run a head-to-head comparison with subagents:

1. Save the old version of the guidance file (e.g. `cp CLAUDE.md CLAUDE.old.md`)
2. Make your changes to the current version
3. Dispatch two subagents in parallel — one following the old guidance, one following the new — against the same task or test file
4. Compare the outputs: is the new version producing tighter, more directive-led results?
