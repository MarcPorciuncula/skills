# Rewrite and technique examples

Use these examples when the main skill identifies the applicable pattern. The
subjects are generic so the examples do not bias a review toward the artifact
that prompted the guidance.

## Rewrite declarative commands as instructions

Before:

> Feature modules select semantic roles. `theme.css` owns theme values. Shared
> primitives own repeated state combinations.

After:

> Use semantic roles in feature modules. Define theme values in `theme.css`.
> Put repeated state combinations in shared primitives.

The before-form presents three choices the agent controls as if they were facts.
The after-form makes each required action explicit.

Keep a genuine ownership fact declarative when it supports later choices:

> The identity service owns account-locking policy. Route lock and unlock
> operations through that service.

The first sentence states a stable boundary. The second tells the agent how to
act within it.

## Put the condition before the action

Before:

> Use the cached result, unless the request asks for a fresh read.

After:

> When the request asks for a fresh read, bypass the cache. Otherwise, use the
> cached result.

The after-form makes both paths explicit and preserves the exception.

## Add a post-load bailout

Use a bailout for a recognizable false-positive class that can remain after
metadata routing:

```markdown
## Check applicability after loading

If this task only reads or summarizes an existing incident report, ignore the
remainder of this skill. Continue without applying the report-authoring
workflow.
```

Do not write:

> If this skill does not seem relevant, ignore it.

The vague form permits convenience-based escape after the skill is applicable.

## Calibrate constraint strength

### High freedom

> Organize the explanation around the reader's primary decision. Use prose, a
> table, or a diagram according to the relationships that need explanation.

Several structures can satisfy the outcome. Selection criteria provide enough
guidance.

### Preferred default

> Put one behavior change in each commit by default. Combine changes when
> separating them would create an invalid intermediate state.

The instruction establishes a default and preserves a legitimate exception.

### Ordered procedure

> 1. Capture the current schema version.
> 2. Apply the additive migration.
> 3. Verify that old and new readers accept the schema.
> 4. Enable the new writer.

The order protects compatibility and each step has an observable result.

### Hard gate

> Do not enable the new writer until old and new readers accept the additive
> schema.

The gate earns its place because crossing it early breaks a compatibility
boundary.

## Use a cost statement only when it changes the choice

Without a useful cost:

> Always use the shared error registry. This is important for consistency.

With an observable cost:

> Add error codes to the shared registry. Inline codes bypass client mapping
> and appear as unknown errors.

The second sentence explains a consequence the agent needs to understand. It
does not merely assert importance.

## Add anti-rationalisation only from evidence

Weak row:

| Thought | Response |
|---|---|
| "I will ignore the validation step" | Run validation |

This restates the prohibited act and does not capture a plausible reason for
overriding it.

Evidence-based row:

| Thought | Response |
|---|---|
| "The generated file is mechanical, so validating one sample proves the whole batch" | Generation can preserve a template defect across every output. Validate the generated set required by the repository. |

Use the second form only after this rationalisation appears in a trace, review,
or repeated failure.

## Remove drafting-session leakage

Before:

> We moved this check out of the reviewer because the earlier version duplicated
> the final verification pass.

After, when only the current responsibility matters:

> The final verification pass owns this check.

After, when the agent also needs an action:

> Run this check only in the final verification pass. Do not repeat it in each
> reviewer.

The rewrite keeps the durable ownership boundary and removes branch history.

## Preserve load-bearing rationale

Do not remove rationale merely because it contains `because`:

> Keep the event field additive during the rolling deployment because old
> workers can process queued payloads until the previous revision drains.

The rationale defines a runtime compatibility boundary. Removing it would make
the temporary additive requirement look arbitrary and easier to delete early.

## Link without maintaining a parallel copy

Before:

> Validate request payloads at the handler boundary. The shared validation
> guide explains schema selection, error conversion, nested fields, and custom
> validators. See `docs/validation.md` under "Handler validation."

After:

> Validate request payloads at the handler boundary. See "Handler validation"
> in `docs/validation.md`.

Add a short fallback only when the linked source might not be available to the
reader and the agent cannot act safely without it.
