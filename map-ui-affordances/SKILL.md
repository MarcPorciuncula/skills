---
name: map-ui-affordances
description: >-
  TRIGGER: Use when the user asks to scope, design, redesign, revise,
  implement, investigate, or review the structure of a user-facing screen,
  page, panel, dialog, navigation area, or substantial UI region; questions
  whether UI content or controls are necessary; asks about UX, UI,
  information architecture, hierarchy, discoverability, filler, or
  affordances; or explicitly asks for an affordance tree. SKIP: isolated
  spacing, colour, typography, token, icon, or exact-copy changes that do not
  change an element's purpose or hierarchy; non-product graphics; and
  implementation where a current affordance tree is supplied and remains
  unchanged.
---

# Map UI Affordances

An affordance tree is a plain-text outline of a UI surface's user-perceived hierarchy, where each node states what the visible region, group, or control lets the user do or understand. Every structural UI element must trace to a settled user need and occupy a clear place in the affordance tree.

## 1. Write the affordance tree

Model the interface the user perceives, not its DOM or component wrappers:

- Include meaningful regions, groups, controls, disclosed surfaces, status indicators, feedback, and required informational content.
- Nest menu items, dialog actions, and disclosed details beneath the control that reveals them, qualifying conditional nodes inline with `[when ...]`.
- Allow interactive parents (such as tabs, rows, or menus) to contain child affordances when that matches the perceived hierarchy.
- Use a separate tree only when a state materially reorganises the surface; put multi-screen flows in a separate sequence or flow representation.
- Omit layout wrappers, implementation-only components, decorative elements, component prop slots, and visual styling tokens.

## 2. Design or audit a surface

| Mode | Workflow |
|---|---|
| **Design or revise** (creating or restructuring a UI surface) | 1. State the **primary user task** and completion condition from settled requirements.<br>2. List **required affordances**; record plausible but unconfirmed capabilities as **Open decisions** rather than promoting them into the UI.<br>3. Draft the **intended affordance tree** before choosing layout or styling: keep the primary path direct, group sibling actions together, place utility actions outside the primary path, present peer alternatives at the same level, and strip any node that does not map to a settled user need.<br>4. When delegating implementation, pass the accepted tree, exclusions, and open decisions, and require the implementer to stop before adding, removing, or reparenting user-visible nodes. |
| **Review an existing surface** (auditing code, a mockup, or a screenshot) | 1. Establish the **primary user task** and **required affordances** from settled user needs (existing UI proves presence, never necessity).<br>2. Reconstruct the **observed tree** faithfully from the screenshot, markup, or code: use displayed labels, write `<unlabelled group>` when a group lacks orientation, write `?` when an item's purpose is unclear, and preserve repetition, asymmetry, or buried nesting without charitable cleanup.<br>3. Report **affordance coverage** (present, missing, and unmatched filler such as unrequested subtitles, marketing blurbs, or empty slot padding) and **structural findings** (split actions, skewed hierarchy, competing utility content).<br>4. Provide a **recommended intended tree**, **open decisions**, and the resulting user-visible changes. |

## 3. Worked example (review and redesign)

- **Settled requirements:** A workspace member can connect their organisation to Claude or ChatGPT using one shared MCP URL, copy the URL, see that the client uses their existing workspace permissions, and follow client-specific setup steps or open a detailed guide.
- **Primary task:** Connect the organisation to a supported client.

```text
Observed tree:                                      Recommended intended tree:
Integrations & MCP                                  Integrations & MCP
├─ Intro: read generic connection benefits          └─ Connect to MCP
├─ Claude                                              ├─ MCP URL
│  ├─ Why use Claude: read benefits                    │  ├─ Endpoint: use the same URL with either client
│  ├─ Copy MCP URL: copy the shared connection value   │  └─ Copy: copy the URL
│  ├─ Quick setup: follow Claude steps                 ├─ Access notice: understand that the client uses existing permissions
│  └─ View Claude guide: open detailed help            └─ Client setup
├─ Explore AI workflows: read educational content         ├─ Claude: choose Claude setup
├─ More integrations                                      │  ├─ Setup steps [when selected]: connect Claude
│  └─ ChatGPT                                             │  └─ Detailed guide [when selected]: open further help
│     ├─ Why use ChatGPT: read benefits                   └─ ChatGPT: choose ChatGPT setup
│     └─ View ChatGPT guide: open detailed help              ├─ Setup steps [when selected]: connect ChatGPT
└─ Advanced connection details                               └─ Detailed guide [when selected]: open further help
   └─ MCP URL: view the shared connection value
```

- **Affordance coverage:** Present: choose client, view/copy URL, follow Claude steps, open guides. Missing: permission notice, ChatGPT setup steps. Unmatched filler: provider-benefit and educational blurbs.
- **Structural findings:** The shared MCP URL is split between the Claude section and "Advanced connection details"; "More integrations" demotes ChatGPT below its peer Claude; educational filler interrupts the primary task.
- **Open decisions (kept outside the tree until settled):** Whether an org owner must pre-authorise a client, whether to show live connection status, and whether a client can be unavailable.

## 4. Visual-review boundary

Use screenshots or a running UI only when they already exist or the user supplies them. Do not start a dev server, launch a browser, or capture screenshots solely to build an affordance tree; state when the review is based on code, markup, or a spec, and treat visual polish (spacing, contrast, typography) as a separate review pass.
