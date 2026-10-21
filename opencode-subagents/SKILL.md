---
name: opencode-subagents
description: >-
  Delegate work to other models through OpenCode from a shell-capable agent
  harness. Use for persistent model conversations, second opinions, reviews,
  or delegated implementation through the OpenCode CLI, including follow-ups
  and inspection of earlier messages.
---

# OpenCode Subagents

Use OpenCode's CLI and standard shell tools to exchange messages with another
model. Return its final reply by default. Keep its session ID for follow-ups.

| Responsibility | Owner |
|---|---|
| Task, supplied context, acceptance of results | Host agent |
| Transcript, model execution, tool permissions | OpenCode |
| Session ID and working directory for each delegated conversation | Host agent's task context |

## Prepare a conversation

Check `opencode --version`, `opencode run --help`, and `command -v jq`.
These recipes target OpenCode v2.1.2. If the installed interface differs,
inspect its help before adapting the commands. V1 flags and API schemas differ.

Run `opencode models` to discover model identifiers. Use the requested model
when available. If the user did not choose one, select an available model
suited to the task. Do not silently replace a requested unavailable model.

Use the configured OpenCode service and credentials. If OpenCode cannot start
or authenticate, report the specific prerequisite. Preserve the host's sandbox
and approval requirements. Do not use delegation to bypass them.

Run from the intended working directory. For concurrent editing, give each
worker an isolated worktree or follow the repository's established isolation
workflow. For review-only work, configure permissions appropriate to that scope.
Do not assume a prompt such as "do not edit" enforces tool restrictions.

Supply the task, relevant context or file locations, constraints, and expected
deliverable. OpenCode does not inherit the host conversation. Keep delegated
actions within the user's authorization. Avoid enabling `--auto` merely to
make a non-interactive invocation succeed. V2 non-interactive runs can reject
permission requests and cancel questions, then continue without those actions.
Check whether the reply actually completed the requested work.

## Send and receive

Set `model` to a discovered `provider/model` identifier. Use this pipeline
for a new conversation; replace the example prompt with the delegated task:

```bash
set -o pipefail
opencode run --model "$model" --format json \
  'Review the supplied implementation and report actionable findings.' |
jq -s -e '
  if any(.[]; .type == "error") then
    error([.[] | select(.type == "error") | .error] | tojson)
  else
    [.[] | select(.type == "text")] as $texts
    | if ($texts | length) == 0 then
        error("No assistant text; inspect the stored session")
      else
        $texts[-1] as $last
        | {session_id: $last.sessionID, message_id: $last.part.messageID,
           reply: ([$texts[]
             | select(.part.messageID == $last.part.messageID)
             | .part.text] | join("\n"))}
      end
  end'
```

The pipeline waits for command completion and returns only identifiers and
the text blocks associated with the last emitted text message. It keeps event
details out of the host context. It does not require a `step_finish` event.

For a follow-up, add `--session "$session_id"` to the same invocation and
reuse the filter. Keep the working directory and model choice associated with
that conversation. Use explicit session IDs rather than `--continue` when
managing multiple conversations. A descriptive `--title` helps recovery.

Check the pipeline's exit status before accepting its output. If it fails,
inspect the existing session before retrying; the prompt may already have run.
If output is empty, incomplete, or ambiguous, read the stored newest assistant
message using [history and recovery](references/history.md). A final message
can contain several text blocks; do not return only the last block.

If the host shell tool yields a running process handle, retain it and use the
host's wait mechanism until the pipeline completes. Do not start another prompt
in the same session while waiting for the first reply. Independent sessions
can run concurrently when the task authorizes parallel delegation.

## Inspect only when needed

Use [history and recovery](references/history.md) to retrieve the final stored
message, wait for independently started execution, recover a session ID, search
earlier conversation, or inspect available reasoning and tool results.
OpenCode stores the transcript; a separate registry or duplicate event log is
not required for the normal workflow.

Treat the delegated reply as evidence to assess, then incorporate the useful
result into the host's task. Report failures or missing work that affect the
requested outcome.
