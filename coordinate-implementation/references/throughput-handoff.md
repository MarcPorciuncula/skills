# Throughput handoff

Use a throughput implementer only when the work is already an exact
transformation with deterministic verification. Use a balanced implementer when
the implementer must choose behavior, interpret an incomplete mapping, or
design the local implementation.

Add these facts to the normal handoff:

- The exact before-and-after mapping
- The prescribed source for every new value or argument
- Compatibility and rollout boundaries already decided
- The completeness search, compile, generation, or targeted test evidence
- Cases known to be outside the transformation

Before dispatching a signature or API migration that may not apply uniformly,
tell the implementer to enumerate consumers and confirm that the prescribed
mapping fits each one.

Tell the implementer to stop and report when:

- A required value is unavailable from the prescribed source
- Existing behavior has no defined representation in the new contract
- A caller crosses an uncovered process, persistence, generated, plugin, or
  rollout boundary
- Applying the mapping requires new state, I/O, context propagation, or scope
- Verification exposes a different failure class rather than another instance
  of expected mechanical fallout

Tell the implementer not to invent a default, make a required value optional,
add an adapter, or redesign the contract. Require it to preserve useful work
and report the exact location, observed facts, evident options, verification
state, and worktree state.

Leave routine imports, formatting, caller updates, and compile fallout with the
implementer when they follow directly from the prescribed transformation.

## Handle an exception

Classify why the implementer stopped before changing models:

| Cause | Coordinator action |
|---|---|
| A deterministic instruction was omitted | Add the missing rule and resume throughput |
| An already-decided local exception was omitted | Add the exception and resume throughput |
| Ordinary implementation judgment remains | Continue the work with a balanced implementer |
| Architecture or compatibility is invalid | Resolve it in the coordinator; involve the user when behavior or scope changes |
| Tools, permissions, or environment failed | Fix the environment without upgrading the model |
| A clear handoff was ignored | Clarify or narrow the handoff before considering an upgrade |

Upgrade only the work that needs additional reasoning. Return remaining exact
propagation to throughput when the harness supports a model override or
sequential handoff.
