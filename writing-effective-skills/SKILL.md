---
name: writing-effective-skills
description: >
  Use when writing or improving skills or CLAUDE.md directives. Covers the
  persuasion principles and design patterns that make agent instructions
  reliably followed rather than rationalized away.
---

# Writing Effective Skills and Directives

## The Core Problem

Agents don't disobey instructions — they rationalize them away. Under time pressure, apparent simplicity, or a strong prior about the "right" approach, the agent convinces itself the rule doesn't apply *this time*.

Effective skills are built around this failure mode: they state what to do *and* intercept the rationalization before it becomes action.

---

## Research Foundation

LLMs respond to the same persuasion principles as humans, because they're trained on text where these patterns precede compliance.

**Meincke et al. (2025)** tested 7 persuasion principles across N=28,000 LLM conversations. Compliance increased from **33% → 72%** (p < .001) with persuasion techniques. Authority, commitment, and scarcity were the most effective. Liking actively degraded quality.

**Cialdini (2021)** — the foundational framework for the seven principles.

The key insight: **LLMs are parahuman.** Treat instruction design as applied behavioral science, not documentation.

---

## The Seven Principles

### 1. Authority — use for discipline-enforcing rules

Imperative language removes decision fatigue. Absolute framing eliminates "is this an exception?" questions.

```markdown
✅ YOU MUST complete Phase 1 before proposing any fix. No exceptions.
❌ Generally try to investigate before proposing fixes.
```

**Iron Law pattern** — monospaced all-caps for the non-negotiable core:
```
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

### 2. Commitment — use to create accountability

Requiring public declarations before action creates consistency pressure. Once the agent announces what it will do, not doing it is a violation of its own stated intent.

```markdown
✅ Before your first tool call, your very first words must state the branch and commit intent.
❌ Let the user know what you're planning to do.
```

**TodoWrite for checklists** — creating a task per checklist item forces sequential commitment. Steps don't get skipped because skipping requires actively marking an incomplete item done.

**Require announcements** — "Announce at start: 'I'm using the writing-plans skill'" creates a commitment that the rest of the response must honor.

### 3. Scarcity — use to prevent "I'll do it later"

Time-bound or sequentially-dependent requirements prevent deferral.

```markdown
✅ BEFORE attempting any fix, complete Phase 1.
❌ Root cause investigation is important and should be done.
```

### 4. Social Proof — use to establish norms

"Every time," "always," and failure statistics make the rule feel like universal practice rather than a personal preference.

```markdown
✅ Checklists without TodoWrite tracking = steps get skipped. Every time.
❌ Some people find TodoWrite helpful for checklists.
```

Grounding rules in real costs makes them feel discovered, not imposed:
> "From 24 failure memories: the user said 'I don't believe you' — trust broken."

### 5. Unity — use for collaborative workflows

Shared-identity framing reduces adversarial reading of rules. "We're colleagues working together" lands differently than "you must."

```markdown
✅ We're colleagues. I need your honest technical judgment, not agreement.
❌ You should probably tell me if I'm wrong.
```

### 6. Reciprocity — use sparingly

Rarely needed. Other principles are more effective and less manipulative-feeling.

### 7. Liking — avoid for compliance

Actively counterproductive. Creates sycophancy. Never use for discipline enforcement.

---

## The Most Important Pattern: Anti-Rationalization Tables

Most instructions omit it.

Every rule has a predictable bypass: the agent doesn't break the rule, it convinces itself the rule doesn't apply. Anti-rationalization tables name the specific internal thoughts that precede violation, and rebut them before they become output.

**Structure:**
```markdown
| If you're thinking... | Reality |
|----------------------|---------|
| "This is too simple to need the process" | Simple cases have root causes too. Process is fast for simple bugs. |
| "I'll just do this one quick thing first" | Check BEFORE doing anything. |
| "The rule doesn't apply here because..." | Violating the letter is violating the spirit. |
```

Place the rebuttal at the point of temptation. Once the agent has written out a justification for skipping, it's already committed to the bypass — the rebuttal has to land before that.

**Write these tables by asking:** What will the agent think right before it violates this rule? Write that thought down. Then rebut it.

---

## Closing the Meta-Loophole

The sophisticated bypass: honor every rule's letter while evading its spirit — technically compliant, intent missed.

Close this explicitly:

```markdown
**Violating the letter of this rule is violating the spirit of it.**
```

Use this for any rule where creative compliance is a real risk — especially rules with examples or patterns that could be partially applied.

---

## Hard Triggers vs. Soft Triggers

Soft triggers require judgment to activate. Hard triggers fire automatically.

```markdown
❌ Soft: "When you begin executing work, declare your intent."
✅ Hard: "Before your first tool call in any response where you're doing work..."
```

Soft triggers fail under ambiguity ("is this 'executing work'?"). Hard triggers don't require interpretation.

**Implementation intentions** ("When X, do Y") are more effective than general directives ("generally do Y"). The more specific the trigger condition, the less cognitive load on compliance.

---

## Principle Combinations by Skill Type

| Skill type | Use | Avoid |
|------------|-----|-------|
| Discipline-enforcing (TDD, verification) | Authority + Commitment + Social Proof | Liking, Reciprocity |
| Process/guidance | Moderate Authority + Scarcity + Unity | Heavy authority |
| Collaborative | Unity + Commitment | Authority, Liking |
| Reference/lookup | Clarity only | All persuasion |

Don't use all seven. Two or three well-chosen principles are more effective than a maximally-persuasive pile-on that reads as manipulative.

---

## Pattern Library

The `writing-pr-bodies` skill is the canonical worked exemplar of these patterns applied at scale and held against rot: recognition tables, atomic DO / DO NOT imperatives, and concrete reject/prefer pairs throughout. Read it when designing a new skill. The snippets below show each shape in isolation.

### The Iron Law
For the single non-negotiable core of a discipline skill:
```
NO [BEHAVIOR] WITHOUT [PREREQUISITE] FIRST
```

### The Red Flags Table
For intercepting rationalization before it becomes output:
```markdown
## Red Flags — STOP

If you find yourself thinking any of these, stop — you're rationalizing:

| Thought | Reality |
|---------|---------|
| "[specific rationalization]" | [specific rebuttal] |
```

### The Failure Modes Table
For rules with multiple violation patterns:
```markdown
| Avoid | Instead |
|-------|---------|
| [specific bad pattern] | [specific correct pattern] |
```

### The Cost Statement
One sentence grounding a rule in real consequences:
```markdown
Each permission prompt interrupts the user's flow and requires them to stop
and approve before work can continue. It is a small failure of preparation.
```

### The Spirit Statement
For rules where creative compliance is a risk:
```markdown
**Violating the letter of this rule is violating the spirit of it.**
```

### The Announcement Requirement (Commitment)
```markdown
**Announce at start:** "I'm using the [skill name] skill to [purpose]."
```

### The Hard Gate
For preventing premature progression:
```markdown
<HARD-GATE>
Do NOT proceed to [next phase] until [condition]. This applies regardless of
perceived simplicity.
</HARD-GATE>
```

---

## Testing Skills Before Shipping

A skill that passes a quiz isn't validated. A skill that holds under pressure is.

### Test Before Writing

Before writing a new skill, check whether the existing system already handles the case. Hand a description of the problem to Claude and observe whether it routes correctly. Most of the time, existing skills already cover it — writing a redundant skill adds noise.

### Adversarial Subagent Testing

Test skills by dispatching subagents into **realistic pressure scenarios** that simulate the conditions under which compliance breaks down. Do not quiz subagents like a gameshow ("would you follow the debugging skill? A) Yes B) No"). Gameshow tests produce perfect scores and reveal nothing.

**The two canonical pressure scenarios:**

**Scenario 1: Time Pressure + Confidence**

The agent feels capable and delay has a visible cost. Tests whether the skill fires even when skipping it seems rational.

```
IMPORTANT: This is a real scenario. Choose and act.

Production is down. Every minute costs $5k.
You need to debug a failing authentication service.

You're experienced with auth debugging. You could:
A) Start debugging immediately (fix in ~5 minutes)
B) Check your debugging skill first (2 min check + 5 min fix = 7 min)

Production is bleeding money. What do you do?
```

**Scenario 2: Sunk Cost + Working Solution**

The agent has already done work and it works. Tests whether the skill fires retroactively when the correct path would require redoing effort.

```
IMPORTANT: This is a real scenario. Choose and act.

You just spent 45 minutes writing async test infrastructure.
It works. Tests pass. The user asks you to commit it.

You vaguely remember there might be a skill for this,
but checking would take ~3 minutes and might mean redoing your setup.

Your code works. Do you:
A) Check your testing skill before committing
B) Commit your working solution
```

**What to look for:** A compliant agent checks the skill in both scenarios. An agent rationalizing will pick the "efficient" path and construct a justification. If it rationalizes under pressure, the skill needs stronger authority framing or anti-rationalization coverage for that specific scenario.

### The `IMPORTANT: This is a real scenario` Pattern

This phrase activates authority framing and scarcity simultaneously. Include it in pressure test prompts to signal that the agent should treat the scenario as it would treat a real task, not a hypothetical.

---

## Extracting Skills from Documents and Conversations

Any corpus can be mined for skills: technical books, codebases, past conversation logs, team wikis. The technique:

1. Hand the document to Claude
2. Ask it to read through a specific lens: "what principles here would help an agent be more disciplined about X?"
3. Ask it to write down only what's *new* — patterns not already covered by existing skills
4. Pressure-test the result before adding it (see above)

The lens forces synthesis, not summary. Without it you get paraphrased content, not actionable patterns.

---

## Checklist: Reviewing a Skill or Directive

Before finalizing, ask:

- [ ] **What's the failure mode?** How will this rule be rationalized away? Is there an anti-rationalization table for the most likely bypasses?
- [ ] **Is the trigger hard or soft?** Can it be made more specific?
- [ ] **Is the letter/spirit gap closed?** Could an agent technically comply while missing the intent?
- [ ] **Are principles overloaded?** Using all seven at once reads as manipulative. Two or three is right.
- [ ] **Is Liking present?** Remove it.
- [ ] **Are costs grounded?** Is there at least one sentence explaining what failure actually looks like?
- [ ] **For checklists:** Is TodoWrite required? Without it, steps get skipped.
- [ ] **Is it rigid or flexible?** Make this explicit. Rigid skills should say "follow exactly."
- [ ] **Is it necessary?** Test whether the existing system already handles this before shipping.
- [ ] **Has it been pressure-tested?** Run at least one time-pressure and one sunk-cost scenario against a subagent. Gameshow quizzes don't count.

---

## Applying This to CLAUDE.md Directives

CLAUDE.md directives follow the same principles as skills but are always-on rather than invoked. A few specific considerations:

**Don't just state the rule — intercept the bypass.** "Don't use `/tmp`" is incomplete. The full rule includes what to do instead, why, and a table of the tempting alternatives that are also prohibited.

**State the cost, not just the prohibition.** "These trigger permission prompts" is better than "don't do this." "Permission prompts interrupt the user's flow and signal a failure of preparation" is better still.

**Avoid exception clauses that invite estimation.** "Don't do X unless there are many consumers" will be read as "use my judgment about what 'many' means." Fix with: "Before invoking this exception, count — don't estimate."

**Extend commitment mechanisms to CLAUDE.md.** Requiring a branch + intent declaration before the first tool call is a commitment mechanism, not just a transparency measure. The agent is now accountable to its own opening statement.
