---
name: writing-specs
description: >
  Write, revise, or review software specifications, design documents, and RFCs
  at spec altitude. TRIGGER when the user asks to write a spec, draft a design
  doc or RFC, record an architectural design in the repository, or update an
  existing specification. SKIP routine implementation without a requested spec
  file, pull request bodies (use writing-pr-bodies), and Linear issue updates
  (use linear-issue-workflow).
---

# Writing Specifications and Design Documents

If `writing-persistent-content` is available, load it and select its internal technical profile for prose register. This skill owns what belongs in a specification, its altitude, contract representations, and how it evolves.

Write a repository specification only when the user asks for one or when an architectural contract needs a durable record in the repository. Never commit single-use, file-by-file implementation checklists (`plans/*.md`); if task decomposition is needed, use `dex` or Linear instead.

## 1. Resolve domain and codebase facts before drafting

Before writing or updating a spec:

- **Discover codebase facts directly:** Inspect the existing code, schemas, and adjacent specs yourself. Never ask the user questions that the repository already answers.
- **Lock product and domain behaviour before code mechanics:** When requirements have genuine forks (scope trade-offs, user-visible behaviour, failure semantics, or compatibility boundaries), ask the user the minimum foundational questions needed, presenting concrete options and a recommended choice with its trade-off.
- **Never unilaterally cut correctness or scope:** You may recommend deferring speculative scope, but the user decides. Do not silently drop edge cases or correctness requirements under "YAGNI" or "v1 simplicity".

## 2. Write at spec altitude

A specification defines *what* the system delivers and *which boundaries and contracts* govern it so an engineer or agent can implement it without re-litigating architecture, while leaving local code mechanics free to adapt:

| Belongs at spec altitude | Omit from specifications |
|---|---|
| Target outcome, motivation, and user- or consumer-visible surfaces | File-by-file or function-by-function edit checklists (`Task 1: edit foo.ts`) |
| Exact RPC, API, event, and database contract shapes (`diff` or schema blocks) | Routine helper names, local state hooks, or line-level code recipes |
| Component ownership boundaries (which service/package owns each invariant) | Chronological narration of the design conversation or rejected strawmen |
| Producer-to-consumer runtime flow (sync vs. queued, transaction and retry boundaries) | Boilerplate test inventories or standard framework explanations |
| Rollout, migration, backwards-compatibility, and security/permission constraints | Speculative future phases stated as current requirements |
| Explicit separation of **Settled requirements**, **Exclusions**, and **Open decisions** | Ambiguous proposals mixed into committed requirements |

## 3. Foreground exact contracts, schemas, and structure

Do not hide contracts or topology inside prose paragraphs:

- **Contract and schema blocks:** Whenever the design introduces or changes protobuf/RPC methods or messages, public API or webhook payloads, persisted job/event schemas, or database tables/columns/indexes, include a compact `diff` or ASCII schema block (`+`, `-`, `~`) with exact field, method, and column names, types, and adjacent `#` or `//` comments for invariants, lookup keys, and lifecycle.
- **UI surfaces:** When the spec covers a user-facing screen or flow with non-trivial hierarchy, include a concise affordance tree (per `map-ui-affordances`, if available) showing what each region or control lets the user do.
- **Topology and state transitions:** Use a terminal-friendly ASCII diagram when control flow, fan-out, or state transitions branch or converge. Use a numbered list (1 to 6 steps) for linear sequences and a Markdown table for ownership or mode matrices.

## 4. Keep settled requirements distinct from open decisions

Treat a specification as a living contract for its delivery unit:

- **Separate settled from open:** Put unresolved product or architectural questions in an explicit `Open decisions` section with the viable options and blocking impact, and put out-of-scope items in `Exclusions` (or `Non-goals`). Never write `TBD` inside a requirement or present an unconfirmed guess as settled policy.
- **Re-synthesize on update:** When updating an existing spec after decisions change, integrate the new decision directly into the governing section and delete superseded wording. Do not append contradictory `Update:` or `Note:` patches at the bottom of the file.
- **Follow repository conventions for placement:** Place the file in the repository's established spec directory (such as `docs/specs/`, `specs/`, or adjacent package documentation) using a descriptive capability-based filename.
