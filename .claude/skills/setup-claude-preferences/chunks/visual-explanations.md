---
id: visual-explanations
description: ASCII diagram and markdown table guidance for leading explanations with structure before prose.
---

## Visual Explanations

When explaining code, designs, or proposed changes, lead with a diagram, table, or call tree before prose. Assume the reader has not read the code under discussion.

Use ASCII for diagrams — boxes-and-arrows (`┌ ─ ┐ │ └ ┘ ├ ┤ ┬ ┴ ┼`), indented call trees, bordered boxes for data shapes. ASCII renders in the terminal and copy-pastes cleanly. For tabular data, use regular markdown tables — Claude Code renders them more reliably than hand-drawn ASCII tables.

Match the form to the intent:

| Intent | Form |
|---|---|
| Component topology — who calls whom, where data lives | ASCII boxes-and-arrows |
| Request path with branching or fan-out | numbered steps or indented lanes |
| Lifecycle or states | labelled boxes with arrow transitions |
| Schema / relationships | indented field lists with arrows for relations |
| Before/after, enumerable mappings, file inventory | markdown table |
| Execution path through functions | indented call tree |
| Data or payload shape | bordered ASCII box |

Keep one abstraction layer per diagram. Don't mix domain or user-visible flow with code-level call paths in the same picture — produce two diagrams.

Highlight what's new or changed with markers like `*` or `[new]`. Include file paths and line numbers as navigation aids. State what the diagram does not cover.
