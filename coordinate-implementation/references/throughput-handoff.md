# Throughput handoff

Use a throughput implementer only when the work is already an exact
transformation with deterministic verification. Use a balanced implementer when
the implementer must choose behavior, interpret an incomplete mapping, or
design the local implementation.

Add these facts to the normal handoff:

- The exact before-and-after mapping
- The prescribed source for every new value or argument
- Compatibility and rollout boundaries already decided
- The search, compile, generation, or targeted test that will confirm every
  affected case was changed
- Cases known to be outside the transformation

Before assigning a signature or API migration that may not apply uniformly,
tell the implementer to enumerate consumers and confirm that the prescribed
mapping fits each one.

Tell the implementer to stop and report when:

- A required value is unavailable from the prescribed source
- Existing behavior has no defined representation in the new API
- A caller crosses a process boundary, persistence format, generated client,
  plugin boundary, or rollout boundary not covered by the handoff
- Applying the mapping requires new state, I/O, passing context through more
  call layers, or expanded scope
- Verification produces a failure other than an expected compile or test
  failure caused by the transformation

Tell the implementer not to invent a default, make a required value optional,
add an adapter, or redesign the API. Require it to preserve useful work
and report the exact location, observed facts, available options, verification
state, and worktree state.

Leave routine imports, formatting, caller updates, and compile fixes with the
implementer when they follow directly from the prescribed transformation.

## Handle an exception

Classify why the implementer stopped before changing models:

| Cause | Coordinator action |
|---|---|
| A deterministic instruction was omitted | Add the missing rule and resume the throughput implementer |
| An already-decided local exception was omitted | Add the exception and resume the throughput implementer |
| Ordinary implementation judgment remains | Continue the work with a balanced implementer |
| Architecture or compatibility is invalid | Resolve it in the coordinator; involve the user when behavior or scope changes |
| Tools, permissions, or environment failed | Fix the environment without choosing a stronger model |
| A clear handoff was ignored | Clarify or narrow the handoff before choosing a stronger model |

Use a stronger model only for the part that needs additional reasoning. Return
the remaining exact changes to a throughput implementer by changing the model
for a follow-up or handing the work to another implementer agent.
