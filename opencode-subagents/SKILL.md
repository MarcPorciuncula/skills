---
name: opencode-subagents
description: >-
  Run tasks or consult other models using the OpenCode CLI. Use when requested
  to delegate work, run a subagent, or invoke another model via OpenCode.
---

# OpenCode Subagents

Quick reference and execution guidelines for delegating tasks or consulting other models via the OpenCode CLI.

## Subagent Guidelines

- **Model selection:** Always specify an explicit model via `-m <provider/model>`. Never guess or fall back to an unverified default model—unexpected models can incur high costs or route to untrusted providers. Ask the user if no model is specified.
- **Self-contained context:** OpenCode runs in its own context and does not inherit the host conversation. Include all necessary file paths, context, and clear instructions in the prompt.
- **Tool permissions (`--auto`):** In non-interactive shell runs, OpenCode skips or rejects tools requiring user confirmation unless `--auto` is passed. Use `--auto` when authorizing the subagent to run commands or edit files; omit it for read-only or review tasks.
- **Workspace isolation:** OpenCode operates in the current working directory. Run in a separate git worktree if the subagent will make edits to prevent collisions with your active workspace.
- **Session IDs:** Assign an explicit session identifier (`-s <session_id>`) so follow-up prompts can reliably resume the conversation.
- **Verify completion:** Subagents may finish or hit errors without non-zero shell exit codes. Inspect the subagent's response to verify that the requested deliverable was actually completed.

## Models and Providers

List available models and providers:

```bash
opencode models
opencode models | grep -i "sonnet"
```

## Running Tasks

### One-off query (plain text output)
By default, `opencode run` streams the assistant response directly to stdout:

```bash
opencode run -m "$model" 'Review the diff and report actionable findings.'
```

### Multi-turn session (persistent conversation)
Assign a descriptive session ID with `-s` (created automatically if new). Reuse the ID for follow-up turns:

```bash
# Turn 1: Initial task
opencode run -s "task-$id" -m "$model" 'Analyze src/auth.ts and list potential race conditions.'

# Turn 2: Follow-up in the same context
opencode run -s "task-$id" 'Provide the code fix for issue #1.'
```

### With tool execution (`--auto`)
When the subagent needs to edit files or run shell commands non-interactively:

```bash
# Run in an isolated worktree when modifying code
git worktree add ../worker-task branch-name
cd ../worker-task
opencode run --auto -s "task-$id" -m "$model" 'Implement the unit tests for auth.'
```

### Machine-readable output (JSON)
If structured JSON output is needed, use `--format json`. To extract the last assistant reply and session details:

```bash
set -o pipefail
opencode run -m "$model" --format json 'Your task prompt' |
jq -s -e '
  [.[] | select(.type == "text")] as $texts
  | if ($texts | length) == 0 then
      error("No assistant text received")
    else
      $texts[-1] as $last
      | {session_id: $last.sessionID,
         reply: ([$texts[] | select(.part.messageID == $last.part.messageID) | .part.text] | join("\n"))}
    end'
```

## History and Inspection

```bash
# List recent sessions
opencode session list

# Export full session transcript to JSON
opencode session export "$session_id"

# Fetch latest messages from a session via API
opencode api session.message.list --param sessionID="$session_id" --param limit=5
```
