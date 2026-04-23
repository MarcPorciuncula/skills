---
id: refactoring-and-cleanup
description: Proceed with user-directed cleanup without pushback; don't propose separate PRs when scope has been expanded.
---

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
