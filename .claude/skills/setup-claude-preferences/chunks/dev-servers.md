---
id: dev-servers
description: Run dev servers in named tmux sessions (`<repo>-<port>`) so they persist and are easy to find.
---

## Dev Servers

When starting a dev server (e.g., `npm run dev`, `pnpm dev`, `go run .`), run it in a **named tmux session** so it persists and is easy to find later.

Name the session `<repo>-<port>` — the repo/service name and the port the server listens on. Examples:

```bash
tmux new-session -d -s api-8080 'pnpm dev'
tmux new-session -d -s web-3000 'npm run dev'
tmux new-session -d -s auth-service-9090 'go run ./cmd/server'
```

To check on a running server: `tmux attach -t api-8080`
To list all sessions: `tmux ls`
To send a signal: `tmux send-keys -t api-8080 C-c`

**Why named sessions:** Anonymous background processes (`&`, nohup) are invisible and hard to manage. Named tmux sessions make it trivial to reattach, inspect logs, restart, or kill a server — especially when multiple services run concurrently.
