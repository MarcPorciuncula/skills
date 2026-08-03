---
id: design-and-change-proposals
description: For architectural choices, name the responsible owner, boundary, and rejected alternative before implementation.
---

## Design and Change Proposals

Before implementing a change with multiple plausible owners or an architectural boundary, state:

- where responsibility belongs and why;
- which responsibility or runtime boundary the change establishes or crosses;
- one plausible alternative and why it is worse.

Responsibility follows ownership of the behavior or invariant, not file proximity.

Skip this declaration for localized changes whose owner and boundaries are already unambiguous.
