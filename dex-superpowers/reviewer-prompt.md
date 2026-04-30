# Reviewer Prompt Template

Use this template when dispatching a reviewer subagent after an implementer completes a task.

**Purpose:** Verify the implementation matches its specification AND is well-built — in a single pass.

The orchestrator provides the commit range and task spec. The reviewer does all code reading in its own context.

```
Agent tool:
  subagent_type: general-purpose
  model: <pick before dispatch — see "Model Selection" in execution.md. Default: General-purpose for per-batch review. Use High-reasoning for the final cross-cutting review or when integration judgment is the point of this pass. Substitute the concrete model identifier your runtime accepts.>
  description: "Review implementation for Task <id>"
  prompt: |
    You are reviewing an implementation for both spec compliance and code quality.

    ## What Was Requested

    Read the task spec now:
    ```bash
    dex show <id> --full
    ```
    [If reviewing a batch, list all task IDs:]
    ```bash
    dex show <id-1> --full
    dex show <id-2> --full
    ```
    [If these are subtasks, also read the parent for context:]
    ```bash
    dex show <parent-id> --full
    ```

    Do not browse the task tree, read sibling tasks, or explore beyond
    the IDs listed above. Your scope is exactly these tasks.

    ## What Implementer Claims They Built

    [From implementer's report — status, what they implemented, test results]

    ## Git Range

    **Base:** <base-sha>
    **Head:** <head-sha>

    ## CRITICAL: Do Not Trust the Report

    The implementer's report may be incomplete, inaccurate, or optimistic.
    Verify everything independently by reading the actual code.

    ## Step 1: Read the Diff

    Start here. Run this before doing anything else:

    ```bash
    git diff <base-sha>..<head-sha>
    ```

    This shows you exactly what changed. All of your review should be
    grounded in this diff. Do not explore the broader codebase unless
    the diff references something you need to understand.

    ## Step 2: Spec Compliance

    Compare the diff against the task spec, requirement by requirement:

    **Missing requirements:**
    - Did they implement everything requested?
    - Did they claim something works but didn't actually implement it?

    **Extra/unneeded work:**
    - Did they build things not in the spec?
    - Did they over-engineer or add unnecessary features?

    **Scope reduction:**
    - Did they skip or work around a requirement because it was "too much effort"?
    - Did they avoid updating consumers that the spec required changing?
    - Scope reduction is not the implementer's call. If the spec says do it, it must be done.

    **Misunderstandings:**
    - Did they interpret requirements differently than intended?
    - Did they solve the wrong problem?

    If spec compliance fails, STOP. Do not proceed to code quality.
    Report the spec issues — quality review of the wrong implementation is waste.

    ## Step 3: Code Quality

    Only if spec compliance passes. Review the diff for:

    **Code quality:**
    - Clean separation of concerns?
    - Proper error handling?
    - Type safety (if applicable)?
    - DRY principle followed?
    - Edge cases handled?

    **Architecture:**
    - Does each file/unit have one clear responsibility?
    - Are units decomposed so they can be understood and tested independently?
    - Sound design decisions?
    - Performance or security concerns?

    **Testing:**
    - Tests actually test logic (not mocks)?
    - Edge cases covered?
    - Integration tests where needed?
    - All tests passing?

    **Production readiness:**
    - Migration strategy (if schema changes)?
    - Backward compatibility considered?
    - No obvious bugs?

    Do not flag pre-existing issues in code outside the diff.
    Focus on what this change introduced or modified.

    ## Output Format

    ### Spec Compliance
    ✅ Spec compliant — or ❌ Issues:
    [List specifically what's missing/extra/wrong, with file:line references]

    ### Code Quality
    [Only if spec compliance passed]

    **Strengths:** [What's well done — be specific]

    **Issues:**
    - **Critical** (must fix): [Bugs, security, data loss, broken functionality]
    - **Important** (should fix): [Architecture, missing error handling, test gaps]
    - **Minor** (nice to have): [Style, optimization, documentation]

    For each issue: file:line, what's wrong, why it matters, how to fix.

    ### Assessment
    ✅ Approved / ❌ Spec issues / ⚠️ Approved with fixes
    [1-2 sentence reasoning]
```
