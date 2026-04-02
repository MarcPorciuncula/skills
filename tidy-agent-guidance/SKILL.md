---
name: tidy-agent-guidance
description: Use when reviewing documentation that was written or edited collaboratively with an AI agent — CLAUDE.md, .cursorrules, AGENTS.md, README, or inline code documentation. Detects overcorrections where the agent injected defensive framing, conversation-specific rebuttals, or duplicated explanations that don't belong in prescriptive guidance.
---

# Tidy Agent Guidance

Review agent-edited guidance docs and strip overcorrections — defensive framing, conversation artifacts, and duplication that accumulate when an AI agent helps write or revise documentation.

## When to use

- After collaborating with an AI agent on guidance docs (CLAUDE.md, .cursorrules, AGENTS.md, README, inline docs)
- When guidance reads more like an argument than a reference
- When the same concept is explained in multiple places

## The review process

### 1. Diff against the base

Compare only what was added or changed — don't re-evaluate the entire document. Use `git diff main` or compare against the last known-good version. The overcorrections are in the delta.

### 2. Classify each addition

Check every added paragraph, bullet, or section against the overcorrection smells below. Most agent-edited docs will have 2-3 of these.

### 3. Fix and verify

Apply the fix for each smell, then re-read the result. The corrected text should be something a senior engineer would write from scratch for a new team member — declarative, prescriptive, no argumentation.

## Overcorrection smells

### Rebuttal framing

The text argues against a position nobody reading the doc would hold. Phrases like "this is X, not Y" or "not an optimisation" are responding to a challenge from the editing conversation.

```markdown
# Before (rebuttal)
This is a structural requirement, not an optimisation. When the codebase
follows proper layering...

# After (declarative)
This breaks the import cycle between domains/ and workflows/ — workflow
activities import domain services, so domain services cannot import
workflow packages directly.
```

**Test:** Would a new reader think the thing being rebutted? If not, remove the rebuttal.

### Conversation-specific anti-patterns

Rules that prohibit things nobody would think to do unless they were in the editing conversation. These sound reasonable in isolation but aren't genuinely common pitfalls.

```markdown
# Before (conversation-specific)
No business logic, no type translation, no feature flag checks,
no conditional workflow selection.

# After (genuinely common pitfalls only)
No business logic, no type translation.
```

**Test:** Would a developer working in this area plausibly make this mistake without prompting? "Business logic in a thin wrapper" — yes, common. "Feature flags in a dispatcher" — no, that's oddly specific.

### Defensive enumeration

A paragraph that pre-emptively explains what the reader should do if they're tempted to deviate. This is the agent anticipating pushback that will never come.

```markdown
# Before (defensive)
If the domain needs to make a decision about which workflow to dispatch,
it does that itself and calls the appropriate dispatcher method.

# After (removed)
[delete — the "no business logic" rule already covers this]
```

**Test:** Is this restating a rule that's already declared elsewhere in the doc? If so, the restatement is the agent reinforcing its own argument.

### Duplicated explanations

The same concept explained fully in two or more places, often across related files. Agents do this to make each document "self-contained", but it creates a maintenance burden and signals the agent was being thorough rather than intentional.

**Fix:** Pick one canonical home for the explanation. Replace the other with a one-line pointer.

```markdown
# Before (full duplicate in secondary file)
Workflow input/output types are defined in `pkg/workflows/types/`,
not in the individual workflow packages. This is a leaf package with
no dependencies on domains or workflow implementations, so both sides
can import it without creating cycles.
[diagram]
See the `workflows/types` section in `pkg/workflows/CLAUDE.md` for
the rationale.

# After (one-liner pointer)
Workflow input/output types live in `pkg/workflows/types/`.
See `pkg/workflows/CLAUDE.md` for details.
```

**Test:** If you updated the explanation in one place, would you remember to update the other? If not, consolidate.

### Justification paragraphs

A paragraph whose purpose is to convince the reader the rule is correct, rather than to state it. Often starts with "The reason for this is..." or provides a multi-sentence rationale after a clear directive.

**Test:** Remove the paragraph. Does the doc still tell the reader what to do? If yes, the paragraph was justification, not instruction.

## What to keep

Not everything an agent adds is overcorrection. Keep:

- **Diagrams** showing dependency relationships or data flow — these are genuinely useful reference material
- **Code examples** showing the correct pattern — concrete and scannable
- **Migration notes** acknowledging current state vs target — practical and honest
- **Step-by-step checklists** for adding new things — actionable for new contributors

## The calibration question

For each piece of guidance, ask: **"Would a senior engineer write this from scratch for a new team member, or is this the agent arguing with itself?"**

Guidance docs should read like a reference written by someone who knows the codebase, not like a transcript of a debate about how the codebase should work.
