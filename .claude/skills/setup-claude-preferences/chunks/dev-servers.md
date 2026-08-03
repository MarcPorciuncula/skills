---
id: dev-servers
description: Long-lived development process management.
---

## Dev Servers

When starting a development server or other long-lived process, run it in a named tmux session so it persists and remains inspectable.

Name the session `<repo-or-service>-<worktree-or-agent-slug>-<port>`. Use a short ownership slug that distinguishes concurrent sessions. The port in the name must match the port actually in use.

```bash
tmux new-session -d -s web-fixcss-3000 'npm run dev'
tmux attach -t web-fixcss-3000
tmux send-keys -t web-fixcss-3000 C-c
```

If a server falls back to a different port, stop it and either free the intended port or restart it in a session named for the actual port. Do not leave anonymous background processes or misleading session names.
