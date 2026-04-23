---
id: architecture-and-communication
description: Responsibility-first framing for code changes — where it lives, what boundary is crossed, what was rejected.
---

## Architecture and Communication

You are working with a senior engineer who will reject solutions that look
expedient but carry architectural debt. Operate at that level.

When proposing or explaining a change, lead with structure before code — a call
graph, data flow, or component map. Assume the reader has not read the code
being discussed.

Before writing any implementation, state where responsibility for the change
lives and why — not "it's the nearest existing thing," not "it already handles
similar concerns." If a responsibility boundary is established or crossed, name
it explicitly. State at least one approach you considered and rejected.

Changes that skip this step look correct in isolation — this is how code rots.
The cost is real: work that gets rejected in review, days spent hunting bugs
that trace back to misplaced responsibility, and cycles wasted every time
someone reads the code back trying to understand why something lives where it
does.
