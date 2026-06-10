# Rewrite examples

Before/after pairs showing the register this skill targets. Read them before
composing prose and match the after-forms. Each annotation names the
transformation; the subject matter is incidental.

These pairs are kept verbatim from real guidance. Do not genericise or
paraphrase them — fidelity to the real text is what makes them exemplars.

## Link without summarising; carry emphasis in plain words

Before (110 words):

> Every ent entity has one owning domain. Code that touches an entity routes
> through the owning domain package, even from another domain. Being *a*
> domain service is not enough; the operation must live in *the owner*. Never
> mutate an entity outside its owning domain. The full rule lives in
> `pkg/domains/CLAUDE.md` under "Entity Ownership" and "Write Paths and
> Domain Events": how to find the owner (naming prefix, `// Owns:` doc.go
> headers, the legacy-owned table), the rules for reads, and which events
> write paths emit. The Read-Side Queries in Handlers section applies the
> read rules to handlers.

After (60 words):

> Every ent entity belongs to one domain. Ent code that touches the table for
> that entity should be written in the domain package that owns it,
> especially mutations. Do NOT modify an entity directly in code outside its
> domain package. You must call into a method from the domain package to
> indirectly mutate the entity. See the full rule in `pkg/domains/CLAUDE.md`
> under "Entity Ownership".

What changed: the before enumerates the linked file's contents and restates
one emphasis across three sentences. The after carries the same emphasis in
two words ("especially mutations"), states the prohibition and the required
alternative as two imperatives, and links without summarising. No instruction
was lost.

## Lead with the permission; delete the rule's self-defence

Before (150 words):

> This is an acknowledged exception to strict layering, justified by a
> CQRS-like read/write separation. The write side — creates, updates,
> deletes, and any operation with side effects — flows through the entity's
> owning domain service, which is solely responsible for enforcing invariants
> and protecting the valid state of data and external services. The read side
> has no such responsibility: it queries existing state without modifying it.
>
> Many read queries are tightly coupled to the API request shape: filters map
> 1:1 to proto fields, pagination is API-specific, and the query assembly is
> determined entirely by the API contract rather than domain rules. Forcing
> these through a domain service creates a pass-through layer whose signature
> mirrors the proto request field-for-field, adding indirection without value.
>
> **The rule:** Connect handlers may query the database directly — including
> complex queries with joins, filters, and aggregations — when the query's
> structure is driven by the API shape and no domain logic is required to
> evaluate, transform, or filter the results. If domain rules govern what
> data is returned or how it is interpreted, that logic belongs in the domain
> service. No business logic may be duplicated into the handler layer under
> this exception.

After (90 words):

> Direct ent queries in handlers are permitted when the query shape is
> heavily specialised to the handler. For example, highly configurable joins,
> pagination, or complex overlapping filters. Forcing these queries into the
> domain layer would just add a layer of indirection and a larger interface
> that's shaped exactly for one/few consumers.
>
> If domain rules govern what data is returned, how it's transformed, or how
> it's interpreted, that logic belongs in the domain service. It can still be
> called into from the handler to apply such logic. Do NOT duplicate such
> logic into the handler.

What changed: the before argues the rule's legitimacy for two paragraphs
before stating it, and buries the rule behind a bold label. The after opens
with the permission as a plain statement, gives concrete examples, states the
cost of the alternative in one sentence, and keeps both hard prohibitions.

## State the directive; no coined labels or self-reference

Before:

> Domain events are defined per domain, and not every mutation has one. The
> failure mode this section guards against is the missed emission: sibling
> write paths emit an event for a kind of change, a new path performs the
> same kind of change without emitting, and subscribers miss it.

After:

> A new write path emits the same events that the domain's existing write
> paths emit for that kind of change. When the existing paths emit and a new
> path does not, subscribers show stale data until a full refetch.
>
> Not every mutation has an event. A write with no matching event type emits
> nothing. Do not invent a new event type to cover it.

What changed: the before describes the section's own purpose ("the failure
mode this section guards against"), coins a term ("the missed emission"), and
chains three clauses the reader must hold to resolve the meaning. The after
states the directive first; the consequence and the boundary follow as
standalone sentences, one fact each.
