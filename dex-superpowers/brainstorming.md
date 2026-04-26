# Brainstorming Ideas Into Designs

Help turn ideas into fully formed designs and specs through natural collaborative dialogue.

Work through the phases below in order. Each phase has an explicit gate — do not advance until it is met. If a later phase raises a question that alters an earlier phase's decisions, step back explicitly to that phase, re-lock it, then re-enter.

<HARD-GATE>
Do NOT invoke any implementation skill, write any code, scaffold any project, or take any implementation action until you have presented a design and the user has approved it. This applies to EVERY project regardless of perceived simplicity.
</HARD-GATE>

## Anti-Pattern: "This Is Too Simple To Need A Design"

Every project goes through this process. A todo list, a single-function utility, a config change — all of them. "Simple" projects are where unexamined assumptions cause the most wasted work. The design can be short (a few sentences for truly simple projects), but you MUST present it and get approval.

## Phases

```
Phase 1 — Domain Interview
  ├── 1. Explore project context
  ├── 2. Ask domain questions (one at a time, dependency order)
  └── Gate: state domain summary → user confirms
         │
         ▼  [if Phase 2 reopens a domain question → return here]
Phase 2 — Design
  ├── 3. Present design (architecture, components, data flow)
  │       explore approach forks inline as they arise
  └── Gate: user approves design
         │
         ▼  [if Phase 3 reopens a design or domain question → return to that phase]
Phase 3 — Implementation Choices  [skip if no genuine open choices]
  ├── 4. Surface implementation choices
  └── Gate: user confirms
         │
         ▼
Phase 4 — Decomposition
  ├── 5. Create dex epic
  ├── 6. Decompose into subtasks
  ├── 7. Plan review (subagent)
  ├── 8. User reviews task tree
  └── Gate: user approves → load execution.md
```

**The terminal state is loading `execution.md`.** Do NOT load any other phase document. The ONLY next step after brainstorming is execution.

---

## Phase 1 — Domain Interview

The goal is to understand what the system does before thinking about how to build it. Implementation decisions made before domain is locked are at risk of being thrown away — if the domain changes, any implementation discussion up to that point was wasted work.

**Explore project context first:**
- Read source files, `docs/`, any knowledge base, recent commits, and `dex list`. Don't skip docs or task tracking — they often encode scope and prior decisions that change the design.
- Look up codebase facts yourself before formulating questions. If you can answer something by reading a file, read it — don't ask. Questions are for decisions that require user judgment (scope, priorities, UX direction, product trade-offs), not facts you can discover.
- Before asking detailed questions, assess scope: if the request describes multiple independent subsystems (e.g., "build a platform with chat, file storage, billing, and analytics"), flag this immediately. Don't spend questions refining details of a project that needs to be decomposed first. Help the user identify the independent pieces, how they relate, and what order to build them. Each sub-project gets its own brainstorm cycle.

**Asking domain questions:**
- One question per message.
- Ask in dependency order: before asking any question, check whether there's another unresolved domain question it depends on. If yes, ask that one first. Questions about error handling depend on questions about visibility. Questions about cascade behavior depend on questions about reversibility. Work from foundational to derived.
- Prefer multiple choice when options are known: `A: ... B: ...`
- Focus on: what the system does, who the actors are, what happens in each case, what the observable behaviors and constraints are.

**What counts as a domain question:**
- "Should takedown be reversible?"
- "What should a consumer see when they try to access taken-down content?"
- "Should purging blobs be a separate action from hiding content?"

**What does NOT belong in Phase 1** — these go in Phase 3:
- Where does the predicate live?
- Should we use a shared service or inline the check?
- Which approach to the dedup query?

**Filter before asking anything:**
- Can I answer this by reading the codebase? → Read it; don't ask.
- Am I asking the user to confirm a recommendation I've already made? → Don't ask. State it and proceed.
- Is this a process or methodology decision covered by other instructions? → Don't ask. Declare how you'll proceed.

**Gate:** Before advancing to Phase 2, write a brief domain summary (actors, behaviors, constraints) and get explicit user confirmation that it is complete and correct.

---

## Phase 2 — Design

With the domain locked, design the system: architecture, components, data flow, error handling, testing approach.

**Presenting the design:**
- Present in sections scaled to their complexity: a few sentences if straightforward, up to 200-300 words if nuanced.
- Ask after each section whether it looks right. Revise before continuing.
- Cover: architecture, components, data flow, error handling, testing.

**Approach forks:**
When the design reaches a genuine fork — a decision where multiple approaches are viable and the choice materially affects the design — explore the options at that point before continuing:
- Identify all viable options; present the ones worth considering with trade-offs.
- If only one approach makes sense, say so and briefly note what you considered and ruled out.
- Lead with your recommended option and explain why.

Don't manufacture a forced alternatives menu at the start of design. Forks appear inside the design as you work through it — explore them when they arise, not upfront.

**Design for isolation and clarity:**
- Break the system into smaller units that each have one clear purpose, communicate through well-defined interfaces, and can be understood and tested independently.
- For each unit, you should be able to answer: what does it do, how do you use it, and what does it depend on?
- Can someone understand what a unit does without reading its internals? Can you change the internals without breaking consumers? If not, the boundaries need work.
- Smaller, well-bounded units are easier to work with — you reason better about code you can hold in context at once, and edits are more reliable when files are focused. When a file grows large, that's often a signal it's doing too much.

**Working in existing codebases:**
- Explore the current structure before proposing changes. Follow existing patterns.
- Where existing code has problems that affect the work (e.g., a file that's grown too large, unclear boundaries, tangled responsibilities), include targeted improvements as part of the design — the way a good developer improves code they're working in.
- Don't propose unrelated refactoring. Stay focused on what serves the current goal.

**Gate:** User explicitly approves the full design before proceeding.

**Back-transition:** If any design question turns out to depend on an unresolved domain question, stop. Step back to Phase 1, re-lock the domain, then re-enter Phase 2.

---

## Phase 3 — Implementation Choices

Surface choices that are genuinely open and not already determined by codebase patterns or process defaults. This phase can be empty — if everything is resolved by the domain, design, and existing conventions, skip it.

**What belongs here:**
- A structural choice the design doesn't resolve (e.g., inline predicate vs. shared helper function).
- A decision with meaningful trade-offs between valid implementations.

**What does NOT belong here:**
- Process defaults: TDD approach, commit strategy, task tracking. State these as declarations ("I'll follow red-green per the TDD skill"), not questions.
- Codebase patterns: if existing code establishes the convention, follow it.
- Confirmations of recommendations already made: proceed; the user will push back if they disagree.

**Format each question:**
- Write it as a question — end with `?`
- Enumerate options: `A: ... B: ...`
- State your recommendation and one-sentence rationale on a separate line
- One sentence of context before the question if needed; don't mix explanation and caveats into the question itself

**Back-transition:** If any implementation choice turns out to depend on an unresolved design or domain question, stop. Step back to the appropriate phase, re-lock it, then re-enter.

---

## Phase 4 — Decomposition

### Create Dex Epic

Save the validated design as a dex epic:

```bash
dex create "Feature name" --description "Full design text..."
```

The epic description should contain the complete design — architecture, components, data flow, error handling approach, and testing strategy. This is the authoritative reference for the implementation.

### Decompose Into Subtasks

Break the design into implementation tasks under the epic:

```bash
dex create --parent <epic-id> "Task name" --description "..."
dex edit <task-id> --add-blocker <dependency-id>  # for sequential dependencies
```

**Each subtask description must include:**
- **Scope:** What this task does and doesn't cover
- **Approach:** How to implement it (files to create/modify, key decisions)
- **Files:** Exact paths to create, modify, and test
- **Done criteria:** What "complete" looks like for this task

**Subtask description quality requirements:**
- No placeholders: no "TBD", "TODO", "implement later", "fill in details"
- No vague instructions: no "add appropriate error handling", "write tests for the above"
- No cross-references without content: no "similar to Task N" — repeat what's needed
- Complete code context: if a step changes code, describe what changes
- Exact file paths always

**Decomposition guidelines:**
- Small feature (1-2 files) → Single task, no subtasks needed
- Medium feature (3-5 files) → 3-7 subtasks
- Large initiative (5+ independent tasks) → Epic with tasks
- 3-7 children per parent is optimal. Don't over-decompose.

### Plan Review (Subagent)

**Do NOT self-check the plan.** The agent who built the plan sees what it intended, not what it wrote. Dispatch a reviewer subagent using `plan-reviewer-prompt.md` with the epic ID. The reviewer reads the tasks from dex directly.

If the reviewer finds issues, fix them. No need to re-review after fixing — the user review gate follows immediately.

### User Review Gate

After the plan review, ask the user to review the task tree:

> "Task tree created under dex epic `<id>`. Run `dex show <epic-id> --expand` to review. Let me know if you want to make any changes before we start implementation."

Wait for the user's response. If they request changes, make them and re-run the self-check. Only proceed once the user approves.

---

## Key Principles

- **Consider YAGNI** — Don't add speculative features nobody asked for. YAGNI does not apply to requirements that ensure the system works correctly.
- **Correctness is non-negotiable** — Code is cheap. If something is critical to the system working correctly, it stays in the design. Never cut correctness requirements to reduce effort.
- **Escalate scope reductions, don't decide them** — You can recommend cutting something, but the user decides. Never present a reduced scope as a fait accompli.
- **Be flexible** — Go back and clarify when something doesn't make sense.

## Red Flags — Scope Reduction

If you find yourself thinking any of these, stop — you're about to cut something the user may consider critical:

| Thought | Reality |
|---------|---------|
| "This is too much effort for now" | Code is cheap. Present the full-effort option and let the user decide. |
| "We can add this later" | Later means never, and the user didn't ask for a phased approach. Ask first. |
| "This is out of scope" | You're defining scope right now. If it's relevant to correctness, it's in scope until the user says otherwise. |
| "Let's keep it simple for v1" | Simplicity is good. Cutting correctness requirements is not simplicity — it's cutting corners. |
| "This would require changing too much existing code" | That's an effort estimate, not a design argument. Present the change with the effort noted and let the user decide. |
| "YAGNI" | YAGNI applies to speculative features nobody asked for. It does not apply to requirements that ensure the system works correctly. |

**The rule:** You can recommend against including something. You MUST NOT unilaterally remove it from the design. Present the trade-off and let the user choose.

## Explaining With Structure

When presenting designs, problems, or solutions, **show structure visually** using ASCII diagrams in the terminal. A diagram communicates architecture faster than prose and gives the user something concrete to react to.

**Default to visual explanation.** Don't wait to be asked. If what you're describing has components, flow, hierarchy, or spatial relationships, draw it.

**Scope explanations one step wider than the immediate question.** If the user asks about a component, show where it sits in the system. If they ask about a flow, show what triggers it and what it feeds into. The user shouldn't have to ask "what calls this?" or "what happens next?" — that context should already be in the diagram.

**Use the right format for the content:**

```
Call trees — who calls what, and in what order:

  handleRequest()
  ├── validateInput()
  │   ├── checkAuth()
  │   └── parseBody()
  ├── processOrder()
  │   ├── checkInventory()
  │   └── createTransaction()
  └── sendResponse()

Component/data flow — how pieces connect:

  ┌──────────┐     ┌───────────┐     ┌──────────┐
  │  Client  │────▶│  Gateway  │────▶│ Service  │
  └──────────┘     └───────────┘     └──────────┘
                         │
                         ▼
                   ┌───────────┐
                   │   Cache   │
                   └───────────┘

Directory/file structure:

  src/
  ├── hooks/
  │   ├── install.ts      ← new
  │   └── verify.ts       ← new
  ├── config/
  │   └── schema.ts       ← modified
  └── index.ts

State machines / decision flow:

  IDLE ──▶ LOADING ──▶ READY
                │         │
                ▼         ▼
             ERROR    PROCESSING ──▶ DONE
                         │
                         ▼
                       ERROR

UI wireframes (for web/CLI layouts):

  ┌─────────────────────────────────┐
  │  Header          [Save] [Exit] │
  ├──────────┬──────────────────────┤
  │ Sidebar  │  Main content area   │
  │          │                      │
  │ • Item 1 │  ┌────────────────┐  │
  │ • Item 2 │  │   Editor       │  │
  │ • Item 3 │  │                │  │
  │          │  └────────────────┘  │
  └──────────┴──────────────────────┘
```

**When to use which:** Call trees for understanding execution paths. Component diagrams for architecture discussions. File trees for showing what changes where. State machines for lifecycle/workflow questions. Wireframes for UI layout discussions.

These are not decoration — they are the primary medium for communicating structure. Prose accompanies the diagram to explain *why*, the diagram shows *what*.
