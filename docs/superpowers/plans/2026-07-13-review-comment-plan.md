# Review comment skill — Implementation Plan

Spec: docs/superpowers/specs/2026-07-13-review-comment-design.md

## Task 1: Author the review-comment skill
- [x] Status

### Result

Added the portable `review-comment` skill with concern-specific evidence selection, outcome/remedy separation, cold-read checks, and a generic list-scoped-state example. The system validator passed, the scoped content checks and `git diff --check` passed, and independent self-review found no actionable violations.

### Scope
Create the portable `review-comment` skill content and generic worked example. The skill drafts and revises comments from code context supplied or inspected locally. It does not inspect GitHub review state, post reviews, process comments received from other reviewers, or summarize an entire PR.

### Approach
Initialize `review-comment` with the system skill scaffold, then replace the template with a concise ordered procedure. The procedure must verify the concern, state its consequence, select an evidence form, separate required outcomes from suggested implementations, draft for a reader with no conversation context, and perform a cold-read revision pass. Route correctness bugs, missing edge cases, failure risks, architectural ownership, duplication/coupling, and uncertain choices to distinct evidence forms.

Require comments to introduce identifiers before use; qualify parent, child, and sibling relationships; remove unresolved references such as “this refactor”; avoid code-level prescriptions when a behavioral or architectural outcome is sufficient; preserve requested user-authored text verbatim; and keep agent-authored additions separate and attributed according to active repository guidance. Include a generic list-scoped-state example whose verified current topology is followed by a `Suggested shape`, not a target or mandate.

### Files
- `review-comment/SKILL.md` (new)

### Done criteria
- The description triggers on drafting, revising, or preparing code review comments and skips full PR summaries, GitHub review-state inspection, review posting, and received-comment handling.
- The workflow supports correctness, edge-case, risk, architecture, coupling, and question-shaped concerns without forcing one template on all of them.
- Architectural comments show verified current structure and a suggested shape only when topology carries the point.
- Hard bugs state required behavior firmly while marking only optional remedies as suggestions.
- The drafting pass explicitly checks introduced identifiers, qualified relationships, resolved references, appropriate abstraction, verbatim user text, and attribution boundaries.
- The example is understandable without this plan, spec, or conversation.

## Task 2: Add skill metadata and catalogue entry
- [x] Status

### Result

Generated `review-comment/agents/openai.yaml` with the system skill metadata generator and added the skill to the portable-skills catalogue without changing existing entries. The system validator, scoped metadata/catalogue assertions, and `git diff --check` passed.

### Scope
Generate the skill's UI metadata and add it to the portable-skills catalogue. Do not change metadata or catalogue descriptions for existing skills.

### Approach
Generate `agents/openai.yaml` from the completed skill. Use `Review Comment` as the display name, describe drafting cold-read-accessible code review comments in the short description, and make the default prompt ask the skill to draft a focused review comment from an identified concern and relevant code context. Add a `review-comment` row to the README Skills table describing its role without enumerating the workflow.

### Files
- `review-comment/agents/openai.yaml` (new)
- `README.md` (modify)

### Done criteria
- Agent metadata matches the skill's trigger and responsibility boundary.
- The README lists `review-comment` among portable skills with a concise, accurate description.
- Existing catalogue entries remain unchanged.

## Task 3: Validate and pressure-test the skill
- [x] Status
Depends on: Task 1, Task 2

### Result

The system skill validator passed. In fresh-agent pressure tests, the partial-success fan-out comment identified that an early rejection can start a refetch while another RPC is still committing, required reconciliation only after every request has settled, and presented observing all outcomes before refetching or using a transactional bulk endpoint as alternative implementations. The architectural comment stated the current provider/list topology as fact, labelled the alternative `Suggested shape`, assigned list-scoped state to `SearchResultList`, qualified its rendered consumers, and stayed above implementation details. Both comments were understandable from their raw scenarios alone.

### Scope
Validate the completed skill and test its behavior with two fresh agents. Keep prompts and results ephemeral; do not add test artifacts to the repository.

### Approach
Run the system skill validator on `review-comment/`. Dispatch one fresh agent with a partial-success fan-out bug: the UI rolls back all local state after one RPC fails even though earlier RPCs remain committed. Require a cold-read review comment and verify it states the inconsistent persisted state and required behavioral guarantee firmly while presenting a transactional endpoint only as one possible remedy.

Dispatch a second fresh agent with a generic component tree where a provider owns list-scoped state above a list that defines the items and renders all consumers. Require a cold-read review comment and verify it shows the current topology as fact, labels the alternative `Suggested shape`, names the list as the logical owner, qualifies component relationships, and avoids an implementation walkthrough.

### Files
- `docs/superpowers/plans/2026-07-13-review-comment-plan.md` (modify on completion only)

### Done criteria
- The skill validator passes.
- The hard-bug pressure test keeps correctness mandatory and implementation optional.
- The architectural pressure test uses current/suggested structure, establishes ownership, and stays above code-level implementation.
- Both fresh-agent outputs are understandable without access to this plan, spec, or conversation.
