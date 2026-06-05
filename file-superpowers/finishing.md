# Finishing a Development Branch

## Overview

Guide completion of development work by presenting clear options and handling chosen workflow.

**Core principle:** Confirm verification is complete → Present options → Execute choice.

## The Process

### Step 1: Confirm Verification

Confirm the final cross-cutting review from `execution.md` "After All Tasks" returned clean. If issues were flagged but not fixed, return to that step before proceeding.

**If verification is incomplete:**
```
Verification incomplete: <what's open>

Cannot proceed with merge/PR until resolved.
```

Stop. Don't proceed to Step 2.

**If verification is clean:** Continue to Step 2.

### Step 2: Determine Base Branch

```bash
# Try common base branches
git merge-base HEAD main 2>/dev/null || git merge-base HEAD master 2>/dev/null
```

Or ask: "This branch split from main - is that correct?"

### Step 3: Present Options

Present exactly these 4 options:

```
Implementation complete. What would you like to do?

1. Merge back to <base-branch> locally
2. Push and create a Pull Request
3. Keep the branch as-is (I'll handle it later)
4. Discard this work

Which option?
```

**Don't add explanation** - keep options concise.

### Step 4: Execute Choice

#### Option 1: Merge Locally

```bash
# Switch to base branch
git checkout <base-branch>

# Pull latest
git pull

# Merge feature branch
git merge <feature-branch>

# If the merge resolved conflicts, re-run the final cross-cutting review.

git branch -d <feature-branch>
```

#### Option 2: Push and Create PR

```bash
# Push branch
git push -u origin <feature-branch>

# Create PR
gh pr create --title "<title>" --body-file pr-body.txt
```

#### Option 3: Keep As-Is

Report: "Keeping branch <name>."

#### Option 4: Discard

**Confirm first:**
```
This will permanently delete:
- Branch <name>
- All commits: <commit-list>

Type 'discard' to confirm.
```

Wait for exact confirmation.

If confirmed:
```bash
git checkout <base-branch>
git branch -D <feature-branch>
```

## Quick Reference

| Option | Merge | Push | Cleanup Branch |
|--------|-------|------|----------------|
| 1. Merge locally | ✓ | - | ✓ |
| 2. Create PR | - | ✓ | - |
| 3. Keep as-is | - | - | - |
| 4. Discard | - | - | ✓ (force) |

## Common Mistakes

**Skipping verification confirmation**
- **Problem:** Merge broken code, create failing PR
- **Fix:** Always confirm verification before offering options

**Open-ended questions**
- **Problem:** "What should I do next?" → ambiguous
- **Fix:** Present exactly 4 structured options

**No confirmation for discard**
- **Problem:** Accidentally delete work
- **Fix:** Require typed "discard" confirmation

## Red Flags

**Never:**
- Proceed with failing tests
- Proceed with unresolved issues from the final cross-cutting review
- Delete work without confirmation
- Force-push without explicit request

**Always:**
- Confirm verification is complete before offering options
- Present exactly 4 options
- Get typed confirmation for Option 4
