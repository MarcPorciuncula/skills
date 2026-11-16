# PR body examples

These examples demonstrate level of abstraction and information shape. Adapt
them to the actual change; do not copy their headings mechanically.

## Multi-PR review navigation

These historical examples illustrate the navigation format using linked PRs
from the tickets. Verify the live review unit and order when writing a body;
these are not current deployment instructions. Each block appears at the top
of every involved PR with only the `this PR` marker moved. The prose describing
that particular PR follows the separator.

### Cross-repository change: AG-UI

```markdown
## Review bundle

Ticket: [AI-2129: Migrate to AG-UI](https://linear.app/alcova/issue/AI-2129/migrate-to-ag-ui)

1. Alcova-AI/alcova-backend#3086 — Add AG-UI endpoints.
2. Alcova-AI/operator-ui#1399 — Cut over the frontend after backend deploy. **(this PR)**

---
```

The parent ticket identifies the shared change. PR-specific child-ticket
references and any closing keywords stay in their respective bodies. Independent
mobile and frontend-tool follow-ups are outside this review unit.

### Same-repository stack: meeting briefing fan-out

```markdown
## Review bundle

Ticket: [AI-2901: Run automatic meeting briefings as per-user River jobs](https://linear.app/alcova/issue/AI-2901/run-automatic-meeting-briefings-as-per-user-river-jobs)

1. Alcova-AI/alcova-backend#3130 — Prepare per-user jobs and readiness. **(this PR)**
2. Alcova-AI/alcova-backend#3131 — Cut over Temporal after worker fleet deploy.

---
```

Both bodies carry both PRs, even though stack tooling already links their
ancestry. Detailed fleet deployment and history compatibility constraints belong
in the body below the navigation block.

### Coordinated rollout: durable pubsub

```markdown
## Review bundle

Ticket: [AI-2989: Durable domain events and push assembly](https://linear.app/alcova/issue/AI-2989/route-domain-events-durably-via-river-and-migrate-push-notification)

1. Alcova-AI/alcova-backend#3087 — Add durable routing and deduplication.
2. Alcova-AI/pulumi#416 — Enable dual publishing after backend fleet deploy.
3. Alcova-AI/pulumi#417 — Switch to River after dual rollout verification.
4. Alcova-AI/alcova-backend#3088 — Remove legacy assembly after River verification. **(this PR)**
5. Alcova-AI/pulumi#418 — Remove retired cutover config.

---
```

This block is a map, not a runbook. Drain conditions, telemetry, rollback and
configuration instructions stay in the relevant body sections or linked ticket.
The separate meeting-list SQL-trigger retirement is outside this review unit.

## Small behaviour change

```markdown
Adds cancellation for individual file uploads. Cancelling one file no longer
discards the rest of the batch; completed files remain attached and in-flight
files continue uploading.

Failed or cancelled files stay in the picker with a retry action, so the user
can recover without selecting the batch again.
```

The opening is the complete body. The change has no new architectural boundary
or rollout constraint, so headings and an implementation inventory would add no
review value.

## Multi-surface functional change

```markdown
Adds a support inbox for triaging customer conversations without switching
between the customer directory and email. Agents can find unassigned work,
inspect the customer context, reply, and leave internal notes from one area.

## Changed surfaces

The feature changes three reviewable surfaces:

- **Inbox:** Filters conversations by assignment and status, supports bulk
  assignment, and keeps the current selection while filters change.
- **Conversation:** Shows the message history beside customer and account
  context. Agents can reply, add an internal note, resolve, or reopen it.
- **Saved replies:** Lets agents search shared replies and insert one into the
  composer without sending it immediately.

Draft replies survive navigation within the inbox. Leaving the inbox with an
unsent reply requires confirmation.

Attachments are view-only in this iteration; uploading and deleting attachments
remain in the existing email workflow.
```

The body inventories product surfaces and affordances. It mentions draft and
attachment behaviour because they affect the experience, without explaining
component state, request construction, or rendering.

## Functional change with a consequential boundary

```markdown
Adds policy authoring to the administration area. Administrators can create a
policy, edit its rules as a draft, inspect published history, and publish a new
version without changing the versions already assigned to past decisions.

## Changed surfaces

The feature changes three administrator-facing surfaces:

- **Policy list:** Creates policies and opens either the current published
  version or a new draft when no version exists.
- **Policy editor:** Adds, removes, and reorders rules; validates incomplete or
  conflicting rules without discarding the draft.
- **Version history:** Compares published versions and restores one into a new
  editable draft.

## Publishing boundary

Publishing follows one immutable-version path:

    Policy list ──► Local draft ── validate ──► New published version
                         ▲                              │
                         └──── restore older version ──┘

Editing never mutates a published version. Publishing creates the version used
by future decisions, while completed decisions keep their original version.
```

The user-facing inventory remains primary. The plain-text diagram earns its
place because the immutable publishing boundary changes product behaviour and
what reviewers must verify.

## Architecture and runtime flow

```markdown
Moves transactional email delivery out of API requests and into the existing
job runtime. API handlers now commit the product state and an email intent
together; delivery retries no longer hold the request open or risk losing the
email after the product write succeeds.

## Runtime flow

The request and delivery paths separate at the transaction boundary:

    API handler
        │ commits state + email intent
        ▼
    transaction outbox
        │ publishes after commit
        ▼
    email dispatcher ──► provider adapter ──► delivery receipt
        │
        └── retry state and terminal failure

Responsibility stays divided along that flow:

- **Outbox:** Owns the atomic boundary between the product write and delivery
  intent.
- **Dispatcher:** Owns retry policy and provider-independent status.
- **Provider adapters:** Translate requests and receipts without deciding
  whether to retry.

## Relationship to existing notifications

In-app notifications still render synchronously from committed product state
because they have no external delivery step. Email shares their template and
preference resolution, then crosses into the job runtime at the provider
boundary. This keeps channel policy shared without putting external I/O back in
the API request.
```

The lead-ins make the diagram and responsibility bullets part of one readable
account. The flow remains visible at scan depth, while the relationship
paragraph answers a separate review question instead of listing job types,
handler names, or changed files.

## Compatibility and release path

```markdown
Moves authenticated sessions from self-contained cookies to server-side records
so administrators can revoke a single session without rotating every user's
credentials. The browser keeps the same cookie name; its value becomes an
opaque session ID rather than the complete signed session.

## Runtime model

Request authentication resolves the opaque ID through the session store,
applies the existing expiry and account checks, and records last-seen activity
asynchronously. Logout and administrator revocation delete the record, which
makes subsequent requests fail authentication immediately.

## Compatibility

During the transition, readers accept both the old signed value and the new
opaque ID. A request carrying an old value creates a server-side record and
returns the new cookie. Writers issue only the new form, so active users migrate
without a coordinated logout.

## Release path

Deploy the dual reader before enabling server-side writers. Remove legacy reads
only after the maximum old-cookie lifetime has elapsed; otherwise dormant
sessions would be invalidated earlier than the current contract allows.
```

The body separates the steady-state mechanism from version skew and rollout. It
names the compatibility boundary a reviewer must validate without inventorying
storage methods or migration files.
