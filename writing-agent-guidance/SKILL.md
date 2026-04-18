---
name: writing-agent-guidance
description: Use when writing, editing, or reviewing agent guidance — CLAUDE.md, .cursorrules, AGENTS.md, skills, or inline code documentation. Ensures guidance reads as direct, prescriptive reference rather than argumentation or conversation artifacts.
---

# Writing Agent Guidance

Write agent guidance like a reference manual. A fresh reader with zero context should understand immediately.

Common problems to identify and remove:

- **War stories** — references to changes, bugs, or decisions from a previous session
- **Strawman rebuttals** — arguments against positions a fresh reader wouldn't hold
- **Weak justifications** — rationale for a rule that doesn't name a failure mode the reader would recognise

Rebuttals and justifications that intercept a *recognisable default* — a behaviour a fresh reader would agree an agent or author might plausibly fall into — are **interception** (principle 4). Keep the insight, promote the form.

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

### 4. Intercept recognisable defaults, don't argue against strawmen

A rebuttal or justification that names a *recognisable default* — a behaviour any fresh reader would agree an agent or author might plausibly fall into — is **interception**, not argumentation. Keep the insight, but promote the form: imperative directive, Iron Law, Red Flags row, or directive + cost statement. Rebuttals and justifications that only make sense with session history (named incidents, prior implementations, changes made during the editing conversation) are war stories — remove.

**Recognisability test:** Look at the behaviour being rebutted or justified against. Would a fresh reader think "yes, I can see an agent or author plausibly defaulting to that"?

- **Yes** → interception → promote to imperative form (below)
- **No, it requires session context to recognise** → war story → remove
- **No, no one would do that** → strawman → remove

**Promotion forms:**

- **Iron Law** — short imperative, usually bolded or capitalised. Used when the directive is the whole point: `NARRATION IS THE SPINE. VISUALS EARN THEIR PLACE.`
- **Red Flags row** — name the tempting thought and rebut it at the moment of temptation:

  ```
  | If you're thinking…                          | Reality                           |
  | "I should list every file for completeness"  | The reader has `git diff --stat`. |
  ```

- **Directive + cost** — short directive followed by the shortest self-contained phrase naming the consequence: `Don't invent new error codes inline. Unknown codes fall through to a generic error.`
- **Stop phrase** — one short sentence written at the point of temptation in a checklist or procedure.

**Cost statements name consequences, not mechanisms.** A cost statement answers "what breaks?" in terms the reader can recognise without learning internals — shared knowledge (`reviewers already have the diff`), project context the reader already holds (`the gateway owns auth`), or observable breakage (`unknown codes fall through to a generic error`). If the cost would require teaching a specific class, function, or file to make sense, either rephrase in terms of observable behaviour, or move the explanation to a dedicated architecture section and let the directive stand alone.

**Durability check:** Would the cost statement still be accurate after a routine refactor of the named thing? If yes — it's at the right level. If a refactor would make it wrong — it's naming a mechanism; rephrase. Shape-level teaching (layers, responsibilities, component boundaries) belongs in a dedicated overview, authored once and referenced. Directives point at consequences.

**Example — same insight, promoted from rebuttal to directive:**

```markdown
# Before — rebuttal prose form (insight is real; form is weak)
Don't spit out a bullet list of every file changed in the PR body —
reviewers can already see the diff on GitHub.

# After — promoted to directive + cost
PR bodies explain motivation and tradeoffs. Don't restate the diff —
reviewers already have `git diff`.
```

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

*Violates principle 1.* The text argues against a position instead of stating the directive plainly. Phrases like "this is X, not Y" or "not suitable here because" are responding to a challenge — either from the editing conversation (war story) or from a position no reader would hold (strawman).

```markdown
# Strawman — remove
This is a structural requirement, not a performance optimisation.

# Interception in rebuttal form — promote (don't remove)
Don't lead PR bodies with a summary of the diff — reviewers can
already see what changed.

# Interception promoted to directive + cost
PR bodies explain motivation and tradeoffs. Reviewers already have
the diff.
```

**Test:** Apply the recognisability test from principle 4 to the rebutted behaviour.

- Recognisable default → interception → **promote**, don't delete
- Requires session context → war story → remove
- No one would do it → strawman → remove

### Argumentation disguised as guidance

*Violates principles 1 and 2.* Text whose purpose is to convince the reader the rule is correct, rather than to state it. Forms include:

- **Weak justification paragraphs** — rationale after a clear directive, often starting with "The reason for this is..." — unless the rationale names a recognisable failure mode, in which case it's interception (principle 4) and should be promoted, not deleted.
- **Session-specific references** — references to previous implementations, past decisions, or changes that produced the current guidance ("the previous approach was removed because...", "this was changed from X to Y"). Always war stories; remove.
- **Embedded justifications** — justifications attached to directives ("don't use X — it produces output that Y can't parse"). If the rationale names a recognisable failure mode, keep it as a short cost statement (principle 4). If it just restates the directive, cut.

```markdown
# Before — justification-first framing, recognisability test fails
Structured logging is essential for maintaining observability across
the service mesh. Without consistent structured logs, correlating
requests across service boundaries becomes significantly more difficult.

Use `pkg/log` for all logging.

# After — directive first, no justification needed
Use `pkg/log` for all logging. Every handler logs request ID, method,
and path at entry. Add contextual fields for business-relevant data.
```

**Test:** Remove the paragraph or clause.

- Doc still tells the reader what to do, and nothing load-bearing was lost → it was argumentation → keep it cut.
- Removal weakens the doc against a recognisable default → it was interception → restore and promote (principle 4).
- Text is an introduction or forward summary → not argumentation; keep per principle 1.

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
