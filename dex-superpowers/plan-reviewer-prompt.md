# Plan Reviewer Prompt Template

Use this template when dispatching a plan reviewer subagent after creating a dex task tree.

**Purpose:** Verify the task tree is a complete, well-structured decomposition of the design — with accurate dependencies, no gaps, and appropriate granularity.

```
Agent tool:
  subagent_type: general-purpose
  model: <pick before dispatch — see "Model Selection" in execution.md. Default: High-reasoning. Plan review is reasoning-heavy and high-leverage; do not downgrade unless the epic is trivially small. Substitute the concrete model identifier your runtime accepts.>
  description: "Review plan for dex epic <id>"
  prompt: |
    You are reviewing whether a dex task tree is a sound implementation plan
    for its design.

    ## Read the Plan

    The epic ID is: <epic-id>

    1. Run `dex show <epic-id> --full` to read the design
    2. Run `dex show <epic-id> --expand` to see the task tree
    3. Run `dex show <id> --full` for each subtask to read full descriptions

    ## CRITICAL: This Plan Was Just Written by the Agent Who Designed It

    The planner is reviewing their own work. They will see what they intended,
    not what they wrote. You are here because self-review is blind to its own
    gaps. Be skeptical.

    **DO NOT:**
    - Assume the plan is correct because it looks reasonable
    - Accept vague task descriptions ("add appropriate error handling")
    - Trust that dependencies are right because they form a chain
    - Rubber-stamp and move on

    **DO:**
    - Read each task description critically
    - Trace dependencies against actual data/type/build requirements
    - Check task descriptions against the design line by line
    - Look for what's missing, not just what's present

    ## Your Job

    Evaluate the task tree on four dimensions:

    **1. Dependency accuracy**
    - Does each `blocked-by` reflect a real build/type/data dependency?
    - Are there FALSE dependencies that would needlessly serialize work?
    - Are there MISSING dependencies where a task assumes something
      another task produces?

    **2. Research gaps**
    - Are there open questions (which library, which API, which approach)
      that will become rabbit holes during implementation?
    - Does any task description hand-wave over a decision that hasn't
      been made? ("choose an appropriate X", "use a suitable Y")

    **3. Task granularity**
    - Does each task have a clear, distinct purpose?
    - Do any tasks overlap significantly? If so, which should be merged
      or how should the boundary be sharpened?
    - Are any tasks too large (touching many files with unclear scope)?
    - Are any tasks too small (trivial changes split out unnecessarily)?

    **4. Completeness**
    - Does the task tree cover ALL done criteria from the epic design?
    - Walk through the design section by section — is every component,
      behavior, and requirement accounted for in at least one task?
    - Are there implicit requirements (error handling, testing, migration)
      that the design mentions but no task covers?

    **Verify by reading the design and tasks, not by trusting the planner.**

    Report:
    - ✅ Plan is sound (if all four dimensions check out, with brief evidence for each)
    - ❌ Issues found: [list specifically what's wrong, grouped by dimension]
```
