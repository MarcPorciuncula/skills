# STE-inspired language for agent guidance

Use this reference to evaluate the readability of agent instructions. Apply the
selected principles of ASD-STE100 Simplified Technical English described here.
Do not claim that the resulting guidance complies with ASD-STE100.

## Scope

ASD-STE100 is a controlled natural language for technical documentation. Issue
9 contains writing rules and a controlled dictionary. It permits approved
general vocabulary together with subject-specific technical nouns and verbs.

Agent guidance has a different audience and risk profile from aerospace and
defence maintenance documentation. Reuse the parts of STE that make actions,
conditions, and technical relationships easier to understand. Preserve
software terminology, repository conventions, and user-specified language.

Primary sources:

- [ASD-STE100 Issue 9](https://www.asd-ste100.org/assets/files/ASD-STE100_ISSUE9.pdf)
- [Official ASD-STE100 overview](https://www.asd-ste100.org/about_STE.html)
- [STEMG paper on ASD-STE100 and AI](https://www.asd-ste100.org/assets/files/WhitePaper-ASD-STE100_and_AI.pdf)

The STEMG cautions that AI-generated text can appear consistent with STE
without correctly applying its rules and vocabulary. Use this local profile as
an explicit editing standard. Do not rely on a model's recognition of the
standard's name.

## Instructions and conditions

- Write an instruction in the imperative form.
- Put a condition before the instruction it governs when the reader must know
  the condition first.
- Give one instruction per sentence unless two actions occur together or form
  one indivisible operation.
- Put sequential actions in numbered steps.
- Keep optional actions and alternative paths visibly separate from the primary
  procedure.

Before:

> Update the registry, and restart the worker after checking that no jobs are
> active unless the worker supports a rolling reload.

After:

> If the worker supports a rolling reload, reload it after you update the
> registry. Otherwise:
>
> 1. Make sure that no jobs are active.
> 2. Update the registry.
> 3. Restart the worker.

## Sentences and paragraphs

- Keep a sentence short enough to understand in one reading.
- Split a sentence when it contains independent instructions, unrelated facts,
  or several nested conditions.
- Keep the words required for accuracy. Do not omit articles, actors, objects,
  or qualifiers only to reduce length.
- Use one topic per paragraph.
- Use a vertical list when parallel items or conditions are difficult to scan
  in prose.

STE uses exact maximum sentence lengths for procedural and descriptive text.
Treat shortness as a review signal in agent guidance, not a universal word-count
gate. Technical identifiers, links, and necessary compatibility conditions can
make an accurate instruction longer.

## Verbs and voice

- Prefer a direct verb over a noun phrase that describes the action.
- Prefer active voice when the actor is known and relevant.
- Use passive voice when the actor is unknown, deliberately irrelevant, or
  necessary to preserve technical accuracy.
- Avoid complex verb constructions when a simple present, past, future,
  infinitive, or imperative form carries the same meaning.
- Avoid phrasal verbs when a direct technical verb is clearer.

Before:

> Perform an evaluation of whether the token has validity.

After:

> Validate the token.

Do not force active voice into an inaccurate subject:

> During transport, the payload was corrupted.

Keep this form when the corrupting actor is unknown. Do not write that transport
corrupted the payload unless the system establishes that cause.

## Terminology

- Use one term for each concept within the guidance and its related artifacts.
- Use established product, codebase, protocol, and tool names exactly.
- Introduce a project-specific term before relying on it alone.
- Avoid synonyms that imply distinctions the system does not make.
- Avoid idioms, slang, and figurative phrases that carry required meaning.
- Do not invent a metaphor or parallel vocabulary to make a technical
  relationship seem accessible. State the relationship in literal technical
  language.
- Name the actual component and operation. Do not give a component human-like
  agency or describe a technical change as growth, acquisition, emergence, or
  motion when those words obscure what changed.
- Expand an abbreviation on first use unless the intended reader can safely be
  expected to know it.

Do not apply the ASD-STE100 controlled dictionary to code identifiers, commands,
API names, or established domain terms. Do not replace an exact technical term
with a simpler but less accurate word.

## Facts and instructions

STE distinguishes procedural writing from descriptive writing. Use the same
distinction when reviewing agent guidance:

| Content | Form |
|---|---|
| Action the agent must take | Imperative instruction |
| Condition that selects an action | Conditional instruction with the condition first |
| Stable architecture or ownership | Declarative fact near the affected decision |
| Definition | Declarative sentence or field table |
| Several owners or relationships | Ownership table or diagram |

Before:

> The API layer validates request syntax. The domain layer validates business
> rules.

This can be a factual architecture summary, but it is ambiguous when the text
is intended to direct implementation. Make the required action explicit:

> Validate request syntax in the API layer. Validate business rules in the
> domain layer.

Keep both forms when the fact and action each do useful work:

> The domain layer owns business validation. Route new business rules through
> that layer.

## Review questions

For each sentence, ask:

1. Is this an instruction, condition, fact, definition, or explanation?
2. If it is an instruction, does it start with the condition or action?
3. Does it contain more than one independently checkable action?
4. Does the subject name the real actor or owner?
5. Can a direct verb replace a noun phrase?
6. Does each technical term have one consistent meaning?
7. Would a list or table make the relationship easier to scan?
8. Did simplification remove a qualifier or change the technical meaning?

Correct meaning before shortening the text. Plain language that changes a
requirement is not an improvement.

## Rules intentionally not adopted as universal requirements

Do not impose these complete STE constraints on ordinary agent guidance:

- The controlled general dictionary and its approved parts of speech
- Fixed procedural and descriptive sentence-length limits
- American English spelling when the user or repository uses another standard
- Aerospace-specific warning and caution conventions
- STE punctuation restrictions as unconditional style law
- The STE classification system for technical nouns and technical verbs

Apply a stricter rule only when the user, organization, regulatory context, or
artifact explicitly requires STE compliance.
