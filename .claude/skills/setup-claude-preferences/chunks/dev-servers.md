---
id: dev-servers
description: Run dev servers in named tmux sessions (`<repo>-<slug>-<port>`) so they persist, are easy to find, and don't collide between agents.
---

## Dev Servers

When starting a dev server (e.g., `npm run dev`, `pnpm dev`, `go run .`), run it in a **named tmux session** so it persists and is easy to find later.

Name the session `<repo>-<slug>-<port>` — the repo/service name, a short slug identifying *which worktree or agent* owns the session, and the port the server listens on. The slug doesn't need to mirror the branch name; just enough to recognise the owner at a glance (3–8 chars is plenty: e.g. `feat-3`, `fixcss`, `revw`, `main`). Examples:

```bash
tmux new-session -d -s api-feat3-8080 'pnpm dev'
tmux new-session -d -s web-fixcss-3000 'npm run dev'
tmux new-session -d -s auth-service-main-9090 'go run ./cmd/server'
```

To check on a running server: `tmux attach -t api-feat3-8080`
To list all sessions: `tmux ls`
To send a signal: `tmux send-keys -t api-feat3-8080 C-c`

**Why named sessions:** Anonymous background processes (`&`, nohup) are invisible and hard to manage. Named tmux sessions make it trivial to reattach, inspect logs, restart, or kill a server — especially when multiple services run concurrently.

**Why the worktree slug:** Multiple agents (or you + an agent) often share one host. Encoding the worktree into the session name means each agent can find *its* server, port collisions surface immediately (`web-fixcss-3000` already exists → pick another port or kill the other session deliberately), and `tmux ls` doubles as a who's-running-what board.
