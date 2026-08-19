---
name: writing-persistent-content
description: >
  Write or materially revise human-facing prose that persists outside the
  current conversation. TRIGGER for code comments, specifications, pull
  request bodies, tickets, documentation, public API metadata, website copy,
  and interface text. Classify the eventual audience as internal technical,
  external technical, or external nontechnical before drafting. SKIP chat
  responses, conversational walkthroughs, progress updates, commit messages,
  generated code, and prose quoted without revision.
---

# Writing persistent content

Classify persistent prose by its eventual reader and destination. The source
file does not determine the audience. A source comment rendered into public
API documentation is external writing.

## Ownership

This skill owns audience assumptions, register, context independence, and the
publication standard. Artifact-specific guidance owns required content,
evidence, structure, and workflow. If applicable artifact-specific guidance is
available, use it with this skill.

Follow explicit user direction and project, product, language, or platform
style before this general guidance.

## Classify the eventual reader

| Reader and destination | Profile |
|---|---|
| Maintainers or collaborators who share the codebase or engineering context | Internal technical |
| Customers, integrators, operators, or developers using a public technical contract | External technical |
| Product users or a general audience | External nontechnical |

- Classify generated or rendered text by where the generated text appears.
- Classify a public repository's contributor material by its function. A pull
  request body remains internal technical reference unless it is also used as
  product documentation.
- When one source must serve internal and external readers, write the exposed
  text for the external reader. Put internal implementation notes in a
  separate internal comment or document.
- When one external artifact serves technical and nontechnical readers, choose
  the primary reader. Split the material when each audience needs different
  terminology or prerequisite context.

## Write durable prose

- Write for a reader who has none of the drafting conversation.
- State the subject, outcome, or purpose before supporting detail.
- Use one consistent term for each concept. Match established names and
  capitalization.
- Distinguish facts, requirements, decisions, assumptions, and unresolved
  questions when confusing them would change how the text is used.
- Keep session history, abandoned approaches, and authoring steps out of the
  artifact unless the history is itself relevant reference material.
- Use headings, links, lists, tables, and diagrams so their meaning survives
  outside the surrounding paragraph.
- In repository documentation, refer to files in the same repository with
  relative paths. Do not use absolute filesystem paths.
- Prefer claims that remain true after routine implementation changes.
- Preserve qualifications that affect correctness, compatibility, safety,
  permissions, availability, or user action.

## Load the audience profile

Read the profile before drafting or revising the artifact:

- [Internal technical reference](references/internal-technical.md)
- [External technical writing](references/external-technical.md)
- [External nontechnical writing](references/external-nontechnical.md)

Read both external profiles only when one artifact must serve both audiences
and cannot be split.

## Compose with artifact guidance

| Artifact | Audience profile | Additional owner |
|---|---|---|
| Pull request body | Internal technical | `writing-pr-bodies`, if available |
| Specification or design document | Internal technical unless intended for publication | The active specification workflow |
| Code comment | Internal technical unless rendered or exported publicly | Repository and language conventions |
| Proto or schema comment | The audience of the generated description | Proto, schema, and API conventions |
| Public developer documentation | External technical | Product and documentation conventions |
| Interface or product copy | External nontechnical | Product, design-system, brand, and legal conventions |

## Review the artifact

1. Confirm the selected profile against the final rendered destination.
2. Read the artifact-specific and project style sources that apply.
3. Draft from the reader's task and context, not from the implementation or
   authoring sequence.
4. Read the result once without relying on the drafting conversation. Restore
   missing context and remove process narration.
5. For external content, verify public terminology, supported behavior,
   accessibility, and any version or availability claim before publication.

## Classification checks

| Tempting classification | Correct classification |
|---|---|
| A technical subject explained in chat is external technical writing | It is current-user communication because the output stays in the conversation |
| A comment in source code is automatically internal | Use the audience of any generated or published form |
| A publicly visible pull request body is external documentation | Use internal technical reference because its job is code review |
| Plain language makes technical documentation nontechnical | Audience and purpose decide the profile, not vocabulary difficulty |
