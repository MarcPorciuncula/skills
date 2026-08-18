---
id: temporary-files
description: Temporary-file location and creation conventions.
---

## Temporary Files

Permission prompts interrupt the user's flow and require them to stop and approve before work can continue. Each one is a small failure of preparation — a sign that the approach was wrong, not that the user needs to grant more access. The rules below exist to prevent them entirely. Follow them; don't look for alternatives.

**When creating a temporary file, never use the system temp folder (`/tmp`, `/var/tmp`, `$TMPDIR`, `os.tmpdir()`, `tempfile`, or any OS-provided temp directory).** These locations trigger permission prompts and are harder to track. There are no exceptions.

**When a temporary file is needed, write it in the current working directory or worktree.** Use it, then delete it immediately. Never commit temporary files.

**When passing multiline input to a command, write it to a temporary file with the Write file tool.** This includes commit messages, PR bodies, and any other multiline content.

**When passing multiline content, do not use heredocs (`<< 'EOF'`) or shell string substitution (`$(...)`).** Use a temporary file written with the Write file tool.

The required pattern:

1. Use the **Write file tool** (not Bash, not echo, not cat heredoc) to write the content to a temp file in the current directory (e.g., `./commit-msg.txt`)
2. Pass it to the command via flag (e.g., `git commit -F commit-msg.txt` or `gh pr create --body-file pr-body.txt`)
3. Delete the temp file immediately after with a Bash tool call

**Violating the letter of this rule is violating the spirit of it.** These are all violations even though they don't use `/tmp`:

| Temptation | Reality |
|-----------|---------|
| "It's a short message, `-m` is fine" | Any message worth writing deserves the Write tool |
| "Heredoc is faster than a tool call" | Heredocs trigger permission prompts — Write tool is faster |
| "I'm not using `/tmp` so the rule doesn't apply" | The rule covers every approach except Write tool + flag |
| "Shell substitution `$(cat ...)` avoids the temp file" | Still triggers permission prompts — Write tool only |
