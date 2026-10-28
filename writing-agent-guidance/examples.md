# Rewrite Examples for Agent Guidance

Use these before-and-after pairs when revising guidance or stripping common rot patterns.

## Re-synthesize instead of appending bolt-on patches

Before (accumulated patches over several edits):

> Run `pnpm test` before pushing.
>
> Note: Do not run the full test suite for small changes; scope it to the changed file.
>
> Exception: If you only edited documentation or comments, skip tests completely. Also, clean rebases do not need tests.

After (re-synthesized into one coherent rule):

> When verifying locally, run only the test file or package that exercises the changed behaviour. Skip local tests for documentation, comment-only edits, and clean rebases.

## Strip compliance theatre and state the boundary directly

Before (legacy `obra/superpowers` devices):

> **IRON LAW: NO MIGRATIONS WITHOUT BACKWARDS COMPATIBILITY**
>
> Announce at the start of your turn: "I am checking the migration compatibility boundary."
>
> | Thought | Reality |
> |---|---|
> | "This column is unused, I can drop it now" | Old workers still read this column during rolling deploys. |
>
> **Violating the letter of this rule is violating the spirit of it.**

After (direct instruction + observable runtime consequence):

> Keep schema migrations backwards-compatible with the currently deployed worker version. Do not drop or rename a column in the same release that removes its code references, because old workers continue querying the schema until the rolling deployment completes.

## Rewrite declarative commands as imperative instructions

Before (controllable choices disguised as facts):

> Feature modules select semantic roles. `theme.css` owns theme values. Shared primitives own repeated state combinations.

After (explicit actions):

> Use semantic roles in feature modules. Define theme values in `theme.css`. Put repeated state combinations in shared primitives.

Keep genuine architectural boundaries declarative when they inform an adjacent instruction:

> The identity service owns account-locking policy. Route lock and unlock operations through that service.

## Preserve closed-set requirements without inventing invariants

Before (when the source only assigns three responsibilities):

> Each stage owns a single responsibility. Do not duplicate checks across stages. Validate envelope syntax in HTTP handlers, business rules in command services, and public error codes in queue workers.

After (preserves supplied rules without inventing exclusivity):

> Validate envelope syntax in HTTP handlers. Validate business rules in command services. Map failures to public error codes in queue workers.

## Keep technical relationships literal and remove manufactured salience

Before:

> **Two truths:** The key insight: retry behaviour fell out of the worker implementation, and the rule to remember is that schemas steer the ship.

After:

> The worker implementation controls retry behaviour. Edit the schema first, then regenerate the client; do not edit generated files directly.

## Replace vague importance claims with observable consequences

Before:

> Always register error codes in the shared registry. This is very important for consistency across services.

After:

> Register error codes in the shared registry. Inline codes bypass client mapping and surface as generic `UNKNOWN` errors to callers.

## Remove drafting-session leakage while keeping load-bearing rationale

Before (session history):

> We moved this check out of the individual reviewers because the earlier version duplicated the final verification pass.

After (durable ownership rule):

> Run this check only in the final verification pass; do not repeat it in individual reviewers.

Before (load-bearing runtime rationale worth keeping):

> Keep the event field additive during the rolling deployment because old workers can process queued payloads until the previous revision drains.
