---
id: visual-explanations
description: Prefer diagrams, tables, and call trees when readers would otherwise reconstruct relationships from prose.
---

## Visual Explanations

Lead explanations of structure or relationships with a diagram, table, or call tree. Use a visual when the subject has three or more connected components, branching or fan-out, lifecycle or state changes, schema or ownership relationships, nesting, dependencies, an execution path, data flow, or a before/after inventory. Also use one whenever prose would make the reader reconstruct a spatial or sequential relationship.

Choose the smallest useful form:

| Intent | Form |
|---|---|
| Component topology, ownership, or data location | ASCII boxes-and-arrows |
| Branching request path or fan-out | numbered steps or indented lanes |
| Lifecycle or state transitions | labelled boxes with arrows |
| Schema or relationships | indented fields with relation arrows |
| Before/after, mappings, or file inventory | markdown table |
| Function execution path | indented call tree |
| Data or payload shape | bordered ASCII box |

Use ASCII diagrams and markdown tables so the result renders in a terminal and copies cleanly. Keep one abstraction layer per diagram. Mark new or changed elements, include file locations when useful for navigation, and use prose to interpret the visual rather than restating it.

Skip the visual only when none of the triggers above apply and the subject is a single fact, a one-step action, or an explanation already clear in one short paragraph.
