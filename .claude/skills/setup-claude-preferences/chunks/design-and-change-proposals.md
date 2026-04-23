---
id: design-and-change-proposals
description: Before writing code, name where responsibility lives, any boundary crossed, and one rejected alternative.
---

## Design and Change Proposals

Before writing implementation code, state:

- **Where responsibility for the change lives and why.** "It's the nearest existing file" and "this module already handles similar concerns" are proximity arguments, not responsibility arguments — if that's the whole reason, the change is in the wrong place.
- **Any responsibility boundary the change establishes or crosses**, explicitly named.
- **At least one alternative you considered and rejected**, and why.

Skip this and the change looks right in isolation but rots in context: rejected in review, or quietly wrong until someone traces a bug back to misplaced responsibility.
