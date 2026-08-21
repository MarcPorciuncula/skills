# STE-inspired language for persistent content

Use this reference for technical, procedural, instructional, support, policy,
and safety content. Apply the selected principles of ASD-STE100 Simplified
Technical English described here. Do not claim that the resulting content
complies with ASD-STE100.

ASD-STE100 is a controlled natural language for technical documentation. This
profile reuses the rules that make actions, conditions, and technical
relationships easier to understand. Preserve product terminology, public
contracts, repository conventions, and the artifact's primary style authority.

## Match the sentence to its function

| Content | Form |
|---|---|
| Reader action | Imperative instruction |
| Condition that selects an action | Condition first, then the instruction |
| Established fact or current state | Declarative sentence |
| Requirement or policy | Explicit normative language appropriate to the artifact |
| Recommendation or inference | Advice or qualified claim |

Do not write a reader-controlled action as if it were an established fact. Do
not present an inference, proposal, or planned behavior as a current fact.

## Write instructions and conditions

- Give one independently checkable action per sentence unless two actions form
  one operation.
- Put sequential actions in numbered steps.
- Keep optional actions and alternative paths visibly separate from the primary
  procedure.
- State the success condition when the result is not obvious.
- Preserve `only if`, `unless`, `before`, `after`, and other qualifiers that
  change when an instruction applies.

## Keep sentences and paragraphs direct

- Keep a sentence short enough to understand in one reading.
- Split independent clauses, unrelated facts, and nested conditions.
- Keep the words required for accuracy. Do not remove actors, objects,
  articles, or qualifiers only to shorten the sentence.
- Keep each paragraph on one topic.
- Use a vertical list for complex, parallel, or sequential information.

## Use direct verbs and accurate subjects

- Prefer a direct verb over a noun phrase that names the same action.
- Prefer active voice when the actor is known and relevant.
- Use passive voice when the actor is unknown, deliberately irrelevant, or
  required for technical accuracy.
- Name the component or person that performs the operation. Do not assign
  causality to a convenient subject when the evidence does not establish it.

Prefer "Validate the token" to "Perform an evaluation of whether the token has
validity."

## Keep terminology literal and consistent

- Use one term for each concept within the artifact and its related surfaces.
- Use established product, interface, codebase, protocol, and tool names
  exactly.
- Introduce a project-specific or product-specific term before relying on it.
- Avoid synonyms that imply distinctions the product or system does not make.
- Avoid idioms, slang, and figurative phrases that carry required meaning.
- Do not invent a metaphor or parallel vocabulary to make a technical
  relationship accessible. Explain the relationship in simpler literal
  language.
- Expand an abbreviation on first use unless the intended reader can safely be
  expected to know it.

Do not replace an exact technical or interface term with a simpler but less
accurate word.

## Review the result

For each sentence, ask:

1. Is it an instruction, condition, fact, requirement, recommendation, or
   inference?
2. Does its form match that function?
3. Does it contain more than one independently checkable action?
4. Does the subject name the actual actor or owner?
5. Can a direct verb replace a noun phrase?
6. Does each term have one consistent meaning?
7. Would a list or table make the relationship easier to scan?
8. Did simplification remove a qualifier or change the meaning?

Correct the meaning before shortening the content.

## Do not impose complete STE universally

Do not apply the ASD-STE100 controlled dictionary, fixed sentence-length
limits, aerospace warning conventions, or American English requirement to
ordinary persistent content. Do not apply technical-document register to
marketing or editorial prose when the primary style authority permits a wider
voice.
