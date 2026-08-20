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

## Technical register

- Name the actual actor, operation, state, and consequence.
- Describe technical changes and causality literally. Do not write that a
  capability "grew," "emerged," "fell out of" an implementation, or was
  "gained" by a component.
- Do not use em dashes. Split the sentence or use a colon, parentheses, or a
  list according to the relationship.
- Do not introduce a list with an empty count such as "Three consequences:".
  Use an informative heading or start with the content.
- Do not coin a slogan or use a label-colon construction such as "The key
  insight:" to make a statement feel important.
- Use formatting to expose structure or syntax. Do not stack formatting or
  format whole sentences for cadence.
- Refer to headings, files, concepts, and procedures by stable name instead of
  number or relative position.

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
- Keep ownership, exclusivity, causality, and other invariants within the
  evidence. Do not turn a list of responsibilities into a stronger shared rule.

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

If an artifact-specific skill is available for a pull request body, review
comment, ticket, or similar collaboration record, use it with this profile.
Keep the artifact's evidence and structure rules.
