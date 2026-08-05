# PR body examples

These examples demonstrate level of abstraction and information shape. Adapt them to the actual change; do not copy their headings mechanically.

## Small behavior change

```markdown
Adds cancellation for individual file uploads. Cancelling one file no longer discards the rest of the batch; completed files remain attached and in-flight files continue uploading.

Failed or cancelled files stay in the picker with a retry action, so the user can recover without selecting the batch again.
```

The opening is the complete body. The change has no new architectural boundary or rollout constraint, so headings and an implementation inventory would add no review value.

## Architecture and runtime flow

```markdown
Moves transactional email delivery out of API requests and into the existing job runtime. API handlers now commit the product state and an email intent together; delivery retries no longer hold the request open or risk losing the email after the product write succeeds.

## Runtime flow

    API handler
        │ commits state + email intent
        ▼
    transaction outbox
        │ publishes after commit
        ▼
    email dispatcher ──► provider adapter ──► delivery receipt
        │
        └── retry state and terminal failure

The outbox owns the atomic boundary between the product write and the delivery intent. The dispatcher owns retry policy and provider-independent status. Provider adapters translate requests and receipts but do not decide whether to retry.

## Relationship to existing notifications

In-app notifications still render synchronously from committed product state because they have no external delivery step. Email shares their template and preference resolution, then crosses into the job runtime at the provider boundary. This keeps channel policy shared without putting external I/O back in the API request.
```

The flow establishes the topology first. The following paragraphs explain ownership and the nearest existing path instead of listing job types, handler names, or changed files.

## Compatibility and release path

```markdown
Moves authenticated sessions from self-contained cookies to server-side records so administrators can revoke a single session without rotating every user's credentials. The browser keeps the same cookie name; its value becomes an opaque session ID rather than the complete signed session.

## Runtime model

Request authentication resolves the opaque ID through the session store, applies the existing expiry and account checks, and records last-seen activity asynchronously. Logout and administrator revocation delete the record, which makes subsequent requests fail authentication immediately.

## Compatibility

During the transition, readers accept both the old signed value and the new opaque ID. A request carrying an old value creates a server-side record and returns the new cookie. Writers issue only the new form, so active users migrate without a coordinated logout.

## Release path

Deploy the dual reader before enabling server-side writers. Remove legacy reads only after the maximum old-cookie lifetime has elapsed; otherwise dormant sessions would be invalidated earlier than the current contract allows.
```

The body separates the steady-state mechanism from version skew and rollout. It names the compatibility boundary a reviewer must validate without inventorying storage methods or migration files.
