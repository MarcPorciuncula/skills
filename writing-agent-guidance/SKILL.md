---
name: writing-agent-guidance
description: >
  Write, revise, or review persistent agent guidance in skill files,
  AGENTS.md, CLAUDE.md, or equivalent guidance files and reusable prompt
  templates. TRIGGER when authoring or reviewing these maintained artifacts.
  SKIP ordinary agent-to-agent or agent-to-subagent messaging, including
  delegation prompts, task assignments, status updates, and handoffs.
---

# Writing Agent Guidance

Write guidance that lets a capable agent select and perform the intended behaviour without access to the drafting conversation. Apply this skill only to persistent guidance files (`SKILL.md`, `AGENTS.md`, `CLAUDE.md`, and reusable prompt templates). If the task only composes transient messages or delegation prompts for the current session, or edits human-facing documentation, ignore this skill and continue the task.

## First-draft and revision rules

Every new or revised guidance artifact must satisfy these rules:

- **Re-synthesize instead of appending patches:** When revising an existing section, integrate the change into the governing rule, list item, or table row and delete superseded wording. Never append a trailing `Note:`, `Important:`, `Exception:`, or bolt-on paragraph that leaves earlier text contradicting or competing with the new rule.
- **Teach the decision boundary, not the textbook:** Assume a frontier model that already knows standard engineering concepts, tools, and language idioms. Include only repository-specific boundaries, non-obvious failure consequences, and exact contracts or commands.
- **Treat supplied requirements as a closed set:** Ground every fact, prohibition, and mental model in the source artifact or inspected system. Do not invent exclusivity (`only`), a one-to-one responsibility mapping, causal claims, or extra prohibitions to make a list of rules sound cohesive. Do not generalize a narrow user correction into a blanket `never` or `always` policy.
- **Eliminate drafting-session leakage:** Write for a cold reader. Strip references to the current conversation, branch history, prior versions ("previously", "was moved from"), or why an edit was just requested.
- **Omit psychological compliance theatre:** Do not use Cialdini-style manipulation or legacy `obra/superpowers` devices (`Iron Laws`, `Violating the letter of this rule is violating the spirit of it`, `Thought | Reality` anti-rationalisation tables, mandatory start-of-turn announcements, existential threats, or flattery). State the boundary, action, or precondition directly.

## Choose the representation

Match the document form to the kind of decision or action the agent needs to make:

| What the agent needs | Representation |
|---|---|
| Unconditional or conditional action | Direct imperative (`Do Y` or `When X, do Y`) |
| Parallel requirements sharing a subject (2 to 6 items) | Bullet list with one checkable action per bullet (use bold lead-in stems when items cover distinct surfaces or rules) |
| Routing, scope tiers, or multi-owner boundaries | Compact Markdown table (`Condition \| Action` or `Surface \| Owner`) |
| Ordered procedure where skipping or reordering breaks the result | Numbered sequence (1 to 6 steps) with concrete inputs and outputs |
| Exact command, payload, schema, or prompt contract | Minimal copy-pasteable code or text block |
| Non-obvious reason a shortcut fails | One-sentence observable consequence immediately after the instruction |
| Prerequisite that makes proceeding unsafe or invalid | Explicit precondition (`Before X, confirm Y. Do not proceed when...`) |

Keep judgment where the task genuinely requires judgment. Reserve `must`, `always`, and `never` for invariants that have no valid exception within the stated scope, and preserve prerequisite semantics (`only if`, `unless`, `before`, `after`) without turning a necessary condition into a sufficient trigger.

## Write instructions, facts, and technical prose

### Distinguish instructions from facts

- If the agent can comply with or violate the sentence, write an imperative instruction (`Use semantic roles in feature modules`).
- If the sentence is true or false independently of the agent's choices, write a declarative fact (`The identity service owns account-locking policy`).
- Start a conditional instruction with the condition, then state the action (`When the request asks for a fresh read, bypass the cache`).
- State the required alternative beside a prohibition when the valid path is not obvious.

Do not disguise controllable actions as architectural invariants, or invent unstated exclusivity:

```markdown
# Bad: controllable actions disguised as facts + invented exclusivity
Feature modules select semantic roles. `theme.css` owns theme values. Each layer owns only one styling concern.

# Good: direct actions preserving only supplied requirements
Use semantic roles in feature modules. Define theme values in `theme.css`.
```

### Keep the register literal and direct

Apply this readability profile (derived from ASD-STE100 Simplified Technical English; see [references/ste-inspired-language.md](references/ste-inspired-language.md) when reviewing complex phrasing):

- **Name the actual actor, operation, and consequence:** Write `The worker retries failed deliveries` or `Inline error codes bypass client mapping and appear as unknown errors`, not `Retry behaviour fell out of the worker` or `The adapter gained responsibility for errors`.
- **Keep sentences short and atomic:** Give one instruction per sentence unless two actions form one indivisible step. Do not hard-wrap prose or bullets across source lines when the target file uses unwrapped lines.
- **Use one consistent term per concept:** Match the codebase's exact identifiers, commands, and domain terms. Refer to other sections or procedures by stable heading name, never by section number or relative position (`above`, `step 4 below`).
- **Use generic, decoupled examples:** Use minimal examples that illustrate the pattern without coupling the rule to the specific file or ticket from the drafting session.
- **Avoid manufactured salience and punctuation tics:** Never output Unicode `U+2014` em dashes; use a colon, parentheses, comma, or period. Do not open lists with empty counts (`Two consequences:`, `Three rules:`), coin slogans, or prefix sentences with label-colon hooks (`The key insight:`, `The tell:`). Use bold, italics, and code spans to mark structure or syntax, never on whole sentences for emphasis.

## Strip common guidance failures

When reviewing or revising guidance, recognize and remove these rot patterns:

| Rot pattern | Recognition | Fix |
|---|---|---|
| **Bolt-on patch accrual** | Trailing `Note:`, `However,`, or stacked exceptions appended over multiple edits | Re-synthesize the governing rule or table so the section reads as one coherent design |
| **War story or session leakage** | Mentions past incidents, prior versions, or what the author and user just discussed | State only the durable rule, boundary, or observable failure consequence |
| **Compliance theatre** | `IRON LAW`, `Thought \| Reality` tables, `Violating the letter...`, mandatory announcements, or existential threats | Delete the device and state the rule, precondition, or consequence plainly |
| **Declarative command** | Controllable agent behaviour written as a descriptive statement | Rewrite in the imperative form (`When X, do Y`) |
| **Unsupported invariant** | Adds `only`, exclusive ownership, causal claims, or best-practice prohibitions absent from the source | Strip the unstated inference and keep only sourced facts and instructions |
| **Textbook padding** | Explains standard tools, language features, or general concepts the model already knows | Delete the explanation; keep only project-specific rules and constraints |
| **Duplicate summary** | Paraphrases a rule that already has a canonical home in another file | Link to the canonical file and heading; include only the minimum local fallback if that file may be absent |

Read [examples.md](examples.md) for concrete before-and-after rewrites of these failure modes.

## Place guidance and structure skills

Put rules where they load at the moment of use, following the user's target file when specified:

| Guidance scope | Home |
|---|---|
| Repository-wide orientation, commands, and always-on boundaries | Root `AGENTS.md` or `CLAUDE.md` |
| Directory- or package-specific invariants | Nearest directory guidance file |
| Workflow, checklist, or domain rules triggered by a distinct task | `SKILL.md` |
| Heavy reference, CLI mechanics, scripts, or extended examples | `references/` or `examples.md` inside the skill directory |
| Reusable subagent role, rubric, or output contract | Dedicated prompt template or inline block inside the owning skill |

When authoring or revising a skill (`SKILL.md`):

- **Write the frontmatter `description` as a router:** State what the skill does, concrete `TRIGGER` conditions, and `SKIP` exclusions for adjacent tasks that share vocabulary. Do not summarize the workflow in the description.
- **Keep `SKILL.md` scannable and self-contained (~150 to 250 lines):** Put the core rules, decision tables, and workflow in `SKILL.md`. Move large command recipes, reference catalogues, and extended examples into `references/` or `examples.md`, and link to them with a clear instruction on when to read them.
- **Add an in-body scope bailout only when routing is ambiguous:** If keyword overlap causes false-positive loads, add a 1 to 2 sentence scope check in the opening paragraph telling the agent when to ignore the skill. Do not add boilerplate bailout sections when the frontmatter `TRIGGER` and `SKIP` are already unambiguous.
- **Keep sibling skills decoupled:** Qualify cross-skill references with `if available` and include a concise local fallback whenever the step is required to complete the task.

## Workflow: Draft, revise, and verify

1. **Inspect the target and context:** Read the existing artifact end to end, along with any linked files or repository conventions it depends on. Ask the user only when plausible interpretations materially change the policy or remove a load-bearing constraint.
2. **Draft or re-synthesize:** Apply the change directly into the artifact's structure. Preserve load-bearing requirements, architecture/compatibility boundaries, and useful reference blocks (commands, schemas, diagrams) while stripping patched-on fluff and session leakage.
3. **Run the cold-reader check:** Read the complete modified file from top to bottom as an agent encountering it mid-task with zero conversation history:
   - Every controllable requirement is an imperative instruction (`Do Y` or `When X, do Y`), not a disguised fact.
   - No new prohibition, `only` / exclusivity claim, or causal explanation exceeds the source evidence.
   - Re-edited sections read as a single unified rule or table without trailing contradiction patches.
   - No Unicode `U+2014` em dashes, label-colon hooks (`The key insight:`), empty list counts (`Two rules:`), or compliance theatre remain.
   - Cross-references use stable heading or file names and include `if available` fallbacks for optional sibling skills.
4. **Validate proportionally:** For wording, compression, or structural cleanup, the cold-reader check suffices. When a change alters skill routing or compliance on a contested behaviour, test it on a realistic task in a fresh context (using `pressure-test-skills` if available).
