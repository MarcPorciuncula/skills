---
id: shell-commands
description: Avoid directory-targeting flags and chained `cd`; establish context cleanly, then execute.
---

## Shell Commands

Directory-targeting flags and chained `cd` commands trigger the same permission prompts as temp file misuse — and carry the same cost. The fix is always the same: establish context cleanly first, then execute.

**Use absolute paths instead of `cd` wherever possible.** Most commands accept a path argument directly.

**When `cd` is necessary, run it as a standalone Bash tool call** — never chain it with `&&` to subsequent commands. Chaining conflates navigation with execution and makes commands harder to read and review.

**Never use directory-targeting CLI flags** to encode the working path into a command. These flags trigger the same permission checks as `/tmp` and obscure context:

| Avoid | Instead |
|-------|---------|
| `cd /path && command` | `cd /path` (standalone), then `command` |
| `git -C /path/to/repo status` | `cd /path/to/repo` (standalone), then `git status` |
| `pnpm --dir /path/to/pkg install` | `cd /path/to/pkg` (standalone), then `pnpm install` |
| `make -C /path/to/project` | `cd /path/to/project` (standalone), then `make` |
| `npm --prefix /path run build` | `cd /path` (standalone), then `npm run build` |

The pattern: establish context first, then execute.
