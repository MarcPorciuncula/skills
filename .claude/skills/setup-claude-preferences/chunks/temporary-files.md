---
id: temporary-files
description: Write-tool-only pattern for temp files; never use system temp dirs, heredocs, or shell substitution for multiline content.
---

## Temporary Files

Permission prompts interrupt the user's flow and require them to stop and approve before work can continue. Each one is a small failure of preparation — a sign that the approach was wrong, not that the user needs to grant more access. The rules below exist to prevent them entirely. Follow them; don't look for alternatives.

**NEVER use the system temp folder (`/tmp`, `/var/tmp`, `$TMPDIR`, `os.tmpdir()`, `tempfile`, or any OS-provided temp directory).** These always trigger permission prompts and are harder to track. There are no exceptions to this rule.

**ALWAYS write temp files in the current working directory/worktree.** Write the file locally, use it, then delete it immediately. Never commit temporary files.

**Any multiline input to a command must be written to a temp file using the Write file tool.** This applies to commit messages, PR bodies, and anything else with more than one line.

**NEVER use heredocs (`<< 'EOF'`) or shell string substitution (`$(...)`) to pass multiline content.** These are convoluted and trigger permission prompts. The Write tool is always the right approach.

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
