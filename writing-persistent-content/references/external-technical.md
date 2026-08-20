# External technical writing

Write for developers, integrators, operators, and administrators who rely on a
public product or technical contract without access to internal context.

## Reader context

- Start from the reader's task, prerequisite, or contract question.
- Define product-specific terms before relying on them.
- Use public product, interface, and API names. Omit internal package names,
  implementation stages, and private architecture unless they are part of the
  supported contract.
- Address the reader as `you` in procedures. Use a named actor when ownership
  or responsibility matters.
- Put a condition before the instruction it governs.

## Supported behavior

- Distinguish supported behavior from incidental implementation behavior.
- State defaults, permissions, limits, errors, version requirements, and
  compatibility constraints that affect correct use.
- Do not describe planned behavior as currently available.
- Explain deprecations with the supported replacement and required migration.
- Verify commands, code samples, identifiers, and availability claims against
  the current product before publication.

## Procedures and examples

- Give each action its own ordered step.
- Use exact interface labels and documented commands.
- Make examples minimal, realistic, and consistent with the surrounding text.
- Show the relevant result or success condition when it is not obvious.
- Keep optional steps and alternative paths visibly distinct from the primary
  procedure.

## API and generated reference

- Describe every public type, member, parameter, return value, error, and
  exception required to use the contract.
- Open each description with information not already recoverable from the name
  and signature.
- State valid values, defaults, units, nullability, side effects, and failure
  behavior where they matter.
- Write source comments that feed generated documentation as final published
  descriptions. Do not leave internal shorthand for the generator to expose.
- Follow the language or API platform's reference conventions before general
  prose guidance.

## Accessibility and global use

- Use literal, precise language. Avoid idioms, culturally specific references,
  unnecessary figurative language, and jokes that carry meaning.
- Explain technical relationships in simpler literal language. Do not invent a
  metaphor, slogan, or parallel vocabulary to make a concept accessible.
- Name the actual actor, operation, state, and consequence. Do not describe a
  technical change as growth, emergence, acquisition, or motion when those
  words obscure what changed.
- Do not use em dashes. Split the sentence or use punctuation that states the
  relationship directly.
- Do not introduce a list with an empty count or prefix a statement with a
  label-colon construction such as "The key insight:".
- Use descriptive headings and link text that remain meaningful out of
  context.
- Provide text alternatives for images and do not introduce information only
  through color, position, or an image.
- Avoid directional references such as `above`, `below`, or `on the right`
  when a stable label or section name is available.
- Use consistent terminology, formatting, capitalization, dates, and units.
- Use formatting to expose structure or syntax. Do not stack formatting or
  format whole sentences for emphasis or cadence.

## Google developer documentation reference

Use project-specific style first. Consult only the Google guide pages relevant
to the artifact or disputed term:

| Need | Reference |
|---|---|
| Core conventions | [Highlights](https://developers.google.com/style/highlights) |
| Register | [Voice and tone](https://developers.google.com/style/tone) |
| Localization and terminology consistency | [Write for a global audience](https://developers.google.com/style/translation) |
| Inclusive language | [Write inclusive documentation](https://developers.google.com/style/inclusive-documentation) |
| Accessible structure and media | [Write accessible documentation](https://developers.google.com/style/accessibility) |
| Public symbol comments | [API reference code comments](https://developers.google.com/style/api-reference-comments) |
| Specific wording | [Word list](https://developers.google.com/style/word-list) |

Treat the guide as a reference, not a substitute for product knowledge,
language conventions, or reader needs.
