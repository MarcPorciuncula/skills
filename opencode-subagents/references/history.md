# History and recovery

These recipes target OpenCode v2.1.2. Use the same service as the original
invocation. If using an explicit server, add `--server "$server_url"` to each
OpenCode command and provide its password through `OPENCODE_PASSWORD` without
printing it. Separate `--standalone` invocations do not share a live server.

## Read the final stored reply

After the invocation completes, retrieve the newest assistant message:

```bash
set -o pipefail
opencode api session.message.list \
  --param sessionID="$session_id" \
  --param type=assistant --param order=desc --param limit=1 |
jq -e '
  .data[0]
  | if . == null then error("No assistant message")
    elif .error != null then error(.error | tojson)
    elif .time.completed == null then error("Assistant message is incomplete")
    else {message_id: .id, finish: .finish,
          reply: ([.content[] | select(.type == "text") | .text] | join("\n"))}
    end'
```

If the latest message has no text or ends in tool calls, inspect recent messages
and execution state. Do not substitute an older answer and report it as the
current prompt's successful reply. When recovering after an uncertain failure,
check that the stored reply follows the intended user message. A timestamp or
known message ID can distinguish it from a previous turn.

## Wait for independently started work

```bash
opencode api experimental.session.wait --param sessionID="$session_id"
```

This experimental operation waits for the agent loop to become idle. Idle
alone does not establish success. Retrieve the resulting message and check for
errors and the requested deliverable. `opencode run` already waits, so ordinary
send-and-receive invocations do not need this extra call.

## Recover a session ID

```bash
opencode session list --max-count 20 --format json
```

Match the session's title and location to the delegated task before reusing it.
If several sessions plausibly match, inspect their messages before choosing.

## Read and search earlier conversation

```bash
set -o pipefail
opencode api session.message.list \
  --param sessionID="$session_id" --param order=desc --param limit=10 |
jq '.data | reverse'
```

Search a bounded page without displaying unrelated message content:

```bash
set -o pipefail
opencode api session.message.list \
  --param sessionID="$session_id" --param order=desc --param limit=50 |
jq --arg term "$term" '
  .data[]
  | select((.text // (.content | tojson)) | contains($term))'
```

User messages store their prompt in `.text`. Assistant messages use `.content`
for text, tool results, and any available reasoning. To inspect the last few
assistant messages, add `--param type=assistant`. Follow `.cursor.next` with
`--param cursor="$cursor"` for older pages. Keep the same type filter and omit
`order` when passing a cursor. A page search does not search the entire session.

For a complete transcript, use `opencode session export "$session_id"` and
filter the exported JSON locally. Inspect its schema before choosing selectors.
Use `--sanitize` when preparing an export for sharing.

## Inspect event details

The CLI's JSONL output contains `step_start`, `text`, `tool_use`, `step_finish`,
and `error` records. `--thinking` also exposes available reasoning records.
Each record identifies its session; text and tool parts identify their message.
Inspect stored assistant content first when tracing tool activity or available
reasoning. A model may not expose reasoning content.

V2 also advertises an experimental durable event-log endpoint:

```bash
opencode api session.log --param sessionID="$session_id" \
  --param after=0 --param follow=false
```

Its response is SSE, not JSONL. If it returns only a `log.synced` marker, use
stored messages rather than assuming historical events were replayed. Verify
the installed version's replay behavior before relying on this experimental
endpoint. If exact emitted CLI events are needed for a particular
investigation, add `tee "$trace_path"` before the
send-and-receive filter and inspect that file with `jq`, `tail`, or `rg`.
