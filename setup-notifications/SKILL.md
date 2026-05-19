---
name: setup-notifications
description: >
  Set up Claude Code notification hooks that play sounds and show macOS notifications
  when Claude finishes work or needs approval, but only when the terminal is not focused.
  Use when the user says "set up notifications", "set up hooks", "set up notification hooks",
  or similar.
allowed-tools: [Bash, Read, Write, Edit]
---

# Set Up Notification Hooks

Set up macOS notification hooks for Claude Code so the user gets alerted (sound + notification banner) when Claude finishes work or needs permission approval — but only when the terminal app is not in focus.

## What gets set up

1. **A shell script** at `~/.claude/hooks/notify-if-unfocused.sh` that:
   - Reads the hook JSON from stdin to extract the working directory
   - Derives a short location label (e.g. `repo-name/worktree`) from the cwd
   - Checks if the frontmost app is a terminal (Terminal, iTerm2, Alacritty, kitty, Warp, WezTerm, VS Code, Cursor, Zed, Hyper)
   - If the terminal is NOT focused: plays a sound via `afplay` and shows a macOS notification via `osascript`
   - If the terminal IS focused: does nothing (the user is already looking at it)

2. **Hook entries** in `~/.claude/settings.json` for two events:
   - `Stop` — fires when Claude finishes working. Uses the default submarine sound.
   - `PermissionRequest` — fires when Claude needs approval. Uses a distinct ping sound at lower volume to differentiate.

## Step 1: Create the notification script

Write `~/.claude/hooks/notify-if-unfocused.sh` with this content and make it executable:

```bash
#!/bin/bash
# Only notify if the terminal app is NOT in focus
# Reads JSON from stdin to extract cwd for context.
# Usage: notify-if-unfocused.sh [message] [sound] [volume]

# Read stdin JSON for cwd context
INPUT=$(cat)
CWD=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('cwd',''))" 2>/dev/null)

# Extract repo name and worktree/branch from cwd
# e.g. /Users/marc/repos/acme/backend/my-feature -> "backend/my-feature"
LOCATION="$CWD"
if [[ -n "$CWD" ]]; then
    # Check if this looks like a git worktree (parent is a bare repo or repo dir)
    PARENT=$(basename "$(dirname "$CWD")")
    DIR=$(basename "$CWD")
    if [[ -n "$PARENT" && "$PARENT" != "/" ]]; then
        LOCATION="$PARENT/$DIR"
    fi
fi

MESSAGE="${1:-Claude is waiting...}"
if [[ -n "$LOCATION" ]]; then
    MESSAGE="$MESSAGE
$LOCATION"
fi
SOUND="${2:-/System/Library/Sounds/Submarine.aiff}"
VOLUME="${3:-1}"

# Get the frontmost application
frontmost=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true')

# List of terminal apps where Claude Code might be running
terminal_apps=("Terminal" "iTerm2" "Alacritty" "kitty" "Hyper" "Warp" "WezTerm" "Code" "Cursor" "Zed")

# Check if frontmost app is a terminal
is_terminal=false
for app in "${terminal_apps[@]}"; do
    if [[ "$frontmost" == "$app" ]]; then
        is_terminal=true
        break
    fi
done

# Only notify if NOT focused on a terminal app
if [[ "$is_terminal" == false ]]; then
    afplay -v "$VOLUME" "$SOUND" &
    osascript -e "display notification \"$MESSAGE\" with title \"Claude Code\""
fi
```

Then run: `chmod +x ~/.claude/hooks/notify-if-unfocused.sh`

## Step 2: Add hooks to settings.json

Read the existing `~/.claude/settings.json` and merge in the following hooks configuration (preserve any existing settings):

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/notify-if-unfocused.sh 'Claude completed its work'"
          }
        ]
      }
    ],
    "PermissionRequest": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/notify-if-unfocused.sh 'Claude requires approval' /System/Library/Sounds/Ping.aiff 0.7"
          }
        ]
      }
    ]
  }
}
```

**Important:** If the user already has hooks configured, you MUST merge carefully — read the existing config first and add entries without overwriting. Clobbering existing hooks silently breaks them.

## Step 3: Verify

1. Confirm the script exists and is executable: `ls -la ~/.claude/hooks/notify-if-unfocused.sh`
2. Confirm the hooks are in settings.json: `cat ~/.claude/settings.json | python3 -m json.tool`
3. Tell the user the setup is complete and they can test by switching away from the terminal and letting Claude finish a task.

## Notes

- This is macOS-only (uses `osascript` and `afplay`).
- The submarine sound (`/System/Library/Sounds/Submarine.aiff`) is used for "work complete" — it's calm and non-urgent.
- The ping sound (`/System/Library/Sounds/Ping.aiff`) at 0.7 volume is used for "needs approval" — distinct enough to notice.
- The script checks against a list of known terminal apps. If the user uses an unlisted terminal, they should add it to the `terminal_apps` array in the script.
