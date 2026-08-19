# Internal technical reference

Write for maintainers and collaborators who share the repository or technical
domain but did not participate in the drafting conversation.

## Context and terminology

- Assume relevant technical competence and access to the codebase.
- Introduce a project-specific concept before relying on its name alone.
- Use identifiers, file paths, and domain terms when they improve precision or
  navigation.
- Keep exact technical terms. Do not replace them with vague plain-language
  approximations.
- Link to the canonical explanation instead of duplicating it.

## Durable technical content

- Record invariants, ownership, contracts, constraints, and non-obvious
  rationale that a maintainer cannot recover quickly from the implementation.
- State compatibility, rollout, persistence, permission, or operational
  consequences beside the decision that creates them.
- Omit routine mechanics and details already obvious from the adjacent code or
  diff.
- Describe the final behavior or design. Do not narrate the task, branch, or
  editing session.
- Mark assumptions and unresolved questions explicitly when later work depends
  on them.

## Code comments

- Explain why the code exists, which invariant it protects, or which surprising
  condition changes its behavior.
- State non-obvious preconditions, side effects, ordering, concurrency, and
  compatibility requirements.
- Do not paraphrase the statement or function immediately below the comment.
- Do not describe how the code changed or refer to the plan that introduced it.
- Follow the language's document-comment conventions for symbols consumed by
  internal tooling.

## Specifications and design documents

- State scope, required behavior, affected contracts, and responsibility
  boundaries before implementation detail.
- Keep decisions and rejected alternatives only when the distinction affects
  the resulting boundary or constraint.
- Separate committed requirements from proposals and unresolved questions.
- Use a diagram or table when the reader would otherwise reconstruct a flow,
  ownership relationship, state transition, or before-and-after contract from
  prose.

## Review artifacts

Use the artifact-specific skill for pull request bodies, review comments,
tickets, and similar collaboration records. Apply this profile to their prose
without replacing the artifact's evidence or structure rules.
