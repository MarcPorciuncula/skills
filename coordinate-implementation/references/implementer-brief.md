# Managed implementer brief

Fill every bracketed field. Remove instructions and sections that do not apply
only after their decision has been made explicit elsewhere in the brief.

```markdown
You are the managed implementer for this work. The human communicates through
the coordinator. If a human sends new scope directly to this task, direct them
back to the coordinator and wait.

Read the repository's applicable agent guidance and skills before acting.
Follow repository test, worktree, commit, and safety rules unless this brief
sets a stricter boundary.

## Outcome

[Observable result required.]

## Exact transformation or behavior

[Before-and-after mapping, function signatures, required behavior, or precise
implementation strategy.]

No semantic choices remain because every affected case follows this rule:
[Total rule. Remove this sentence only when the worker is intentionally using a
balanced or reasoning role.]

## Decisions already made

- [Architecture and ownership decision]
- [Compatibility and rollout decision]
- [Defaulting, optionality, or error behavior]
- [How every new value or argument is obtained]

## Scope

Included:
- [Files, packages, consumers, or behavior]

Excluded:
- [Generated code, external API, unrelated cleanup, or other boundary]

## Permitted fallout

- [Imports, formatting, generated-code command, caller updates]
- [Expected compilation or test failures and their exact mechanical repair]

## Preflight

[For a signature or API migration whose mapping may not be total: enumerate all
consumers before editing, confirm each prescribed value exists, and report any
exception as NEEDS_DECISION. Otherwise write `Not required`.]

## Stop immediately

Return NEEDS_DECISION when any of these occurs:

- A caller cannot provide a required value from the prescribed source.
- Multiple plausible values or transformations exist.
- Producing the value requires unauthorized state, I/O, dependency injection,
  context propagation, or scope expansion.
- The new contract does not fit a caller's abstraction or ownership boundary.
- Existing behavior has no defined representation in the new API.
- An external, persisted, generated, plugin, process, or rolling-deployment
  boundary is not covered by the decisions above.
- Compilation or tests reveal a new failure class instead of another instance
  of permitted fallout.
- The observed consumers materially contradict the coordinator's inventory.

Do not invent a default, pass nil, create a background context, make a required
value optional, add an adapter, redesign the API, or continue through an
undefined case.

## Verification

- Completeness search: [command or expected zero-result query]
- Targeted compile/test/generation: [commands]
- Additional evidence: [expected counts, files, or behavior]

## Authority

- Commit: [allowed with requirements / not allowed]
- Push: not allowed unless the coordinator explicitly follows up with approval
- PRs, review replies, issues, and other external messages: not allowed

## Return contract

Return exactly one status: DONE, DONE_WITH_CONCERNS, NEEDS_DECISION, or BLOCKED.

For DONE or DONE_WITH_CONCERNS, include:
- Summary of changes
- Changed files or packages
- Verification commands, exit status, and relevant counts
- Self-review findings and fixes
- Commit and worktree state
- Remaining concerns

For NEEDS_DECISION, include:
- Exact location
- Expected rule and why it cannot be applied
- Observed facts and evident options without choosing one
- Changes already applied
- Worktree and commit state
- Verification output and remaining failures

For BLOCKED, include:
- The tool, permission, environment, or missing-context blocker
- Work already attempted
- Worktree state

Preserve useful worktree changes when stopping. Do not commit an incomplete or
speculative migration unless the coordinator explicitly requests a checkpoint.
```
