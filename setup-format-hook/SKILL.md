---
name: setup-format-hook
description: >
  Set up a Claude Code PreToolUse hook that auto-formats code before git commits and blocks
  the commit if the formatter changed anything. Use when the user says "set up formatting hook",
  "set up format hook", "set up pre-commit formatting", or wants consistent formatting in
  Claude Code (including environments without git hooks, like Claude Code web).
allowed-tools: [Bash, Read, Write, Edit, Glob, Grep]
---

# Set Up Pre-Commit Formatting Hook

Set up a Claude Code `PreToolUse` hook that runs the project's formatter before any `git commit` command. If the formatter changes files, the commit is blocked and Claude is told to re-stage and retry.

This works in all Claude Code environments (CLI, web, IDE extensions) regardless of whether git hooks are available.

## What gets set up

A `PreToolUse` hook entry in `.claude/settings.json` (project-level, committed to the repo) that:

1. Triggers on any `Bash` call matching `git commit`
2. Snapshots the working tree diff before formatting
3. Runs the project's formatter(s) on the appropriate file patterns
4. Compares the diff after formatting
5. If changed: blocks the commit with `permissionDecision: deny` and tells Claude to re-stage
6. If unchanged: lets the commit proceed

## Step 1: Discover the project's formatter setup

Look for existing formatter configuration. Check these in order:

1. **lint-staged config** — `package.json` (`lint-staged` key), `.lintstagedrc`, `lint-staged.config.*`
   - This tells you which formatters run on which file patterns
2. **Formatter configs** — `.prettierrc`, `biome.json`, `.oxfmtrc.json`, `rustfmt.toml`, `.gofmt`, `pyproject.toml` (black/ruff)
3. **Package scripts** — `package.json` scripts like `format`, `fmt`, `lint:fix`
4. **Makefile/Taskfile** — `fmt` or `format` targets

Identify:
- **What formatter command(s)** to run (e.g. `pnpm exec oxfmt --write`, `npx prettier --write`, `cargo fmt`)
- **What file patterns** each formatter covers (e.g. `'**/*.{js,ts,tsx,json,css}'`)
- **How to invoke** the formatter (pnpm exec, npx, bunx, yarn, globally installed, etc.)

## Step 2: Build the hook command

The hook command follows this template:

```bash
BEFORE=$(git diff); <FORMATTER_COMMANDS>; AFTER=$(git diff); if [ "$BEFORE" != "$AFTER" ]; then echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Formatter changed files in the working tree. Re-stage all changes (git add -u) and re-commit."}}'; else echo '{}'; fi
```

**Formatter command rules:**
- Suppress stdout/stderr: `>/dev/null 2>&1`
- For optional formatters (e.g. cargo fmt when Rust may not be present), guard with availability checks: `command -v cargo >/dev/null 2>&1 && [ -d crates ] && cargo fmt --all 2>/dev/null`
- Scope formatters to the correct file patterns — don't format the entire repo if the project only formats specific file types
- Chain multiple formatters with `;`

**Example for a project using oxfmt + cargo fmt:**
```
BEFORE=$(git diff); pnpm exec oxfmt --write '**/*.{js,ts,tsx,jsx,mjs,cjs,json,css,yaml,yml}' >/dev/null 2>&1; command -v cargo >/dev/null 2>&1 && [ -d crates ] && cargo fmt --all 2>/dev/null; AFTER=$(git diff); if [ "$BEFORE" != "$AFTER" ]; then echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Formatter changed files in the working tree. Re-stage all changes (git add -u) and re-commit."}}'; else echo '{}'; fi
```

**Example for a project using prettier:**
```
BEFORE=$(git diff); npx prettier --write '**/*.{js,ts,tsx,json,css,md}' >/dev/null 2>&1; AFTER=$(git diff); if [ "$BEFORE" != "$AFTER" ]; then echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Formatter changed files in the working tree. Re-stage all changes (git add -u) and re-commit."}}'; else echo '{}'; fi
```

## Step 3: Write the hook to settings

Read the existing `.claude/settings.json` (or create it if it doesn't exist). Merge in:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "if": "Bash(git commit:*)",
        "hooks": [
          {
            "type": "command",
            "command": "<YOUR BUILT COMMAND FROM STEP 2>",
            "timeout": 30,
            "statusMessage": "Formatting before commit..."
          }
        ]
      }
    ]
  }
}
```

**Important:** If the user already has hooks configured, merge carefully — don't overwrite existing hook entries.

## Step 4: Test the hook — mandatory

**Do not skip this step.** A misconfigured hook silently returns `{}` unconditionally — letting every commit through unformatted without any indication it's broken. Without running these tests, there is no evidence the hook works.

1. **Validate JSON syntax:**
   ```bash
   jq -e '.hooks.PreToolUse[] | select(.matcher == "Bash") | .hooks[] | .command' .claude/settings.json
   ```

2. **Test clean path** (no formatting needed — should return `{}`):
   ```bash
   echo '{}' | bash -c '<YOUR COMMAND>'
   ```

3. **Test dirty path** (misformat a file, should return deny JSON):
   - Introduce a formatting violation (bad indentation, extra spaces)
   - Run the command
   - Verify it returns the deny JSON
   - Verify the file was fixed by the formatter

4. **Clean up** any test modifications to source files.

## Notes

- This hook is idempotent alongside git pre-commit hooks. If both fire, the formatter runs twice with no effect the second time.
- The `git diff` comparison captures the full working tree state, so it correctly detects changes regardless of staging state.
- The hook fires before the entire Bash command executes, so it works even when Claude combines `git add && git commit` in one call.
