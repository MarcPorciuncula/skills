---
id: visual-explanations
description: Visual formats for code and design explanations.
---

## Visual Explanations

When explaining structure, component topology, lifecycles, branching execution paths, dependencies, schemas, or before/after mappings involving three or more connected elements, lead with a visual instead of prose that requires spatial or sequential reconstruction.

Choose the smallest useful form:
- Use ASCII boxes and arrows for component topology, lifecycles, and state transitions.
- Use numbered steps or indented call trees for execution paths and branching flows.
- Use markdown tables for before/after comparisons, inventories, and mappings.

Render visuals cleanly using ASCII or markdown tables so they display in a terminal and copy cleanly. Keep one abstraction layer per diagram, mark new or changed elements, and include file locations for navigation.

Use prose to interpret the visual rather than restating it. Skip visuals for single facts, one-step actions, or explanations clear in a single short paragraph.
