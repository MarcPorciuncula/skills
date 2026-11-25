---
name: dev-servers
description: >
  Manage long-lived development servers and background local services in named
  tmux sessions with discoverable ownership metadata and logs. TRIGGER before
  starting, inspecting, reusing, or stopping a local dev server or background
  service. SKIP short-lived build, lint, or test commands.
---

# Dev Servers

Use `tmux` as the shared process registry for development servers and other long-lived local commands so sessions remain discoverable and distinguishable across concurrent tasks.

## Session conventions

- Inspect existing `tmux` session metadata and listening ports before starting a server.
- Name the session `<repo-or-service>-<stack-or-worktree>-<port>-<owner>`. Use the first eight characters of `CODEX_THREAD_ID` as the owner when available, or a short session slug otherwise.
- Share one short stack slug across related services in different repositories; use the worktree slug when the service is independent.
- Set session metadata options: `@codex_owner`, `@codex_repo`, `@codex_worktree`, `@codex_revision`, `@codex_stack`, `@codex_port`, and `@codex_endpoint`.
- Enable `remain-on-exit` before launching the command and pipe pane output to `${XDG_STATE_HOME:-$HOME/.local/state}/codex-dev-logs/<session>.log`.
- Configure the server to fail on an occupied port rather than silently picking another. When no exact port is required, choose a free port and report the endpoint. Do not kill another task's listener to reclaim a port.
- If the actual endpoint differs from the session metadata, stop the process and fix the command, session name, metadata, and log path before continuing.

## Reusing and stopping sessions

- Before reusing an existing service, verify its stack, checkout, revision, endpoint, and health. When multiple candidates are plausible, ask the user which one to use.
- Before stopping a session owned by another task, ask the user unless the session is stale and no active task depends on it.

## Commands

```bash
# Inspect active sessions
tmux list-sessions -F '#{session_name} owner=#{@codex_owner} repo=#{@codex_repo} stack=#{@codex_stack} port=#{@codex_port} endpoint=#{@codex_endpoint} cwd=#{pane_current_path}'

# Start a tracked server
session=api-search-4310-a1b2c3d4
log_dir="${XDG_STATE_HOME:-$HOME/.local/state}/codex-dev-logs"
mkdir -p "$log_dir"
tmux new-session -d -s "$session"
tmux set-option -t "$session" remain-on-exit on
tmux set-option -t "$session" @codex_owner "${CODEX_THREAD_ID:-manual}"
tmux set-option -t "$session" @codex_repo api
tmux set-option -t "$session" @codex_worktree "$PWD"
tmux set-option -t "$session" @codex_revision "$(git rev-parse HEAD)"
tmux set-option -t "$session" @codex_stack search
tmux set-option -t "$session" @codex_port 4310
tmux set-option -t "$session" @codex_endpoint http://127.0.0.1:4310
tmux pipe-pane -t "$session" -o "cat >> '$log_dir/$session.log'"
tmux send-keys -t "$session" 'exec npm run dev -- --port 4310 --strictPort' Enter

# Inspect output and logs
tmux capture-pane -pt "$session" -S -200
tail -n 200 "$log_dir/$session.log"
```
