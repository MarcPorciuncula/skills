---
name: setup-claude-preferences
description: >
  Set up user-level CLAUDE.md with personal workflow preferences (PR style,
  refactoring philosophy, commit behavior, etc.). Use when the user says
  "set up my claude preferences", "set up my claude.md", "set up my user instructions",
  or similar.
allowed-tools: [Bash, Read, Write, Edit]
---

# Set Up Claude Preferences

Apply the user's personal workflow preferences to their user-level `~/.claude/CLAUDE.md`.

## Important

The content below should be **merged into** the user's existing `~/.claude/CLAUDE.md`, not replace it. If the file already exists, read it first and integrate the sections below — don't duplicate content that's already present with equivalent intent.

If the file doesn't exist yet, create it with the content below as a starting point.

The user's `~/.claude/CLAUDE.md` is for personal cross-project preferences. Project-specific instructions belong in the project's own `CLAUDE.md`.

## Content to apply

```markdown
# User-Level Claude Instructions

## Architecture and Communication

You are working with a senior engineer who will reject solutions that look
expedient but carry architectural debt. Operate at that level.

When proposing or explaining a change, lead with structure before code — a call
graph, data flow, or component map. Assume the reader has not read the code
being discussed.

Before writing any implementation, state where responsibility for the change
lives and why — not "it's the nearest existing thing," not "it already handles
similar concerns." If a responsibility boundary is established or crossed, name
it explicitly. State at least one approach you considered and rejected.

Changes that skip this step look correct in isolation — this is how code rots.
The cost is real: work that gets rejected in review, days spent hunting bugs
that trace back to misplaced responsibility, and cycles wasted every time
someone reads the code back trying to understand why something lives where it
does.

## Visual Explanations

When explaining code, designs, or proposed changes, lead with a diagram, table, or call tree before prose. Assume the reader has not read the code under discussion.

Use ASCII — boxes-and-arrows, tables with box-draw characters (`┌ ─ ┐ │ └ ┘ ├ ┤ ┬ ┴ ┼`), indented call trees, bordered boxes for data shapes. ASCII renders in the terminal and copy-pastes cleanly.

Match the form to the intent:

| Intent | Form |
|---|---|
| Component topology — who calls whom, where data lives | ASCII boxes-and-arrows |
| Request path with branching or fan-out | numbered steps or indented lanes |
| Lifecycle or states | labelled boxes with arrow transitions |
| Schema / relationships | indented field lists with arrows for relations |
| Before/after, enumerable mappings, file inventory | ASCII table with box-draw characters |
| Execution path through functions | indented call tree |
| Data or payload shape | bordered ASCII box |

Keep one abstraction layer per diagram. Don't mix domain or user-visible flow with code-level call paths in the same picture — produce two diagrams.

Highlight what's new or changed with markers like `*` or `[new]`. Include file paths and line numbers as navigation aids. State what the diagram does not cover.

## Pull Request Descriptions

When creating PR descriptions:

- Focus on **what** was done and **why**, not implementation details
- DO NOT list individual code-level edits (e.g., "Lines 17: Added X import", "Lines 27-48: Added helper function")
- DO NOT include detailed testing instructions or checklists - the code review will cover testing
- Keep it concise: Problem → Root Cause → Solution approach → High-level changes
- The commit message and code diff provide the implementation details

## Code Removal and Refactoring

When refactoring or removing code in internal codebases:

- **DO NOT mark internal code as deprecated** - this is not a public API
- **Update all consumers directly** and delete the old code in the same change
- You control all call sites in the codebase, so update them
- If code becomes unused, **delete it completely** - don't mark it deprecated or leave it orphaned

**Exception:** Only use deprecation for internal code when:
- There are many consumers (>10-15) and updating them would bloat the PR scope
- The user explicitly requests limiting the scope to avoid touching too many files
- Even then, ask first rather than assuming deprecation is preferred

**Before invoking this exception, count the call sites** — grep for usages, don't estimate. If you find yourself thinking "there are probably more than 10," that's not the exception condition. The exception requires actually having more than 10.

**The principle:** Deprecation is for maintaining backwards compatibility in public APIs. Internal codebases should evolve atomically - when you change something, update all its uses.

## Refactoring and Cleanup

Follow the "leave it better than you found it" principle. When working in an area of the codebase, related cleanup and refactoring is expected and welcome — especially when:

- The original task changes are already committed (keeping fix vs. refactor in separate commits)
- The user is discussing, suggesting, or requesting the cleanup
- The refactor is in code directly related to what was just changed

**Do not push back on refactoring requests.** If you find yourself about to say any of the following, stop — that's pushback, and the user has already directed the work:

| Pushback phrase | What to do instead |
|----------------|-------------------|
| "This might be better as a separate PR" | Do it in this PR |
| "This is outside the scope of the ticket" | The user is expanding the scope — proceed |
| "Are you sure you want to do this?" | Yes, they are — proceed |
| "This is a lot of changes for one PR" | Do it |
| "Should I open a follow-up issue instead?" | No — do it now |

The distinction is:
- **Unsolicited refactoring:** Don't do this without asking — stay focused on the task
- **User-directed refactoring:** Proceed without hesitation — the user is explicitly expanding the scope

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

## Committing and Pushing

**Default: commit and push.** When the user directs work ("go ahead", "implement it", "proceed", "make that change", or any direct request without questions), complete the work, commit, and push without asking.

**Exception: "don't commit yet"** (or similar). Keep changes in the working tree. This holds until the user asks to commit or gives a new task.

**When a message mixes a request with a question or clarification**, the question takes priority. Answer or clarify first — don't start executing. The user may be setting context or planning, not giving the green light.

**Before committing, verify you're on the expected branch.** Run `git branch --show-current` and confirm it matches the branch you intended to work on. If it doesn't, stop and ask the user.

**Declare intent immediately.** Before your first tool call in any response where you're doing work, your very first words must state the branch you're on and whether you will commit and push or hold changes:
- "I'll work on this on `feature/foo` then commit and push."
- "I'll work on this on `main` and hold the changes for approval."

This gives the user the opportunity to redirect before any work begins. Do not ask "should I commit?" when the user's message was a direction — that's asking for permission to comply.
```

## Steps

1. Check if `~/.claude/CLAUDE.md` exists. If it does, read it.
2. Merge the content above into the file — add missing sections, skip sections that already exist with equivalent intent.
3. Write the result to `~/.claude/CLAUDE.md`.
4. Show the user what was added or changed.
