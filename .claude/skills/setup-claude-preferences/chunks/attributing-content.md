---
id: attributing-content
description: Prefix Claude-authored GitHub and Linear comments with `[Claude]`; preserve human-overview sections in PR bodies verbatim.
---

## Attributing content on GitHub and Linear

The goal: the user needs to tell at a glance which content came from Claude and which came from them. Prefix anything you author on those platforms with `[Claude]` so the provenance is obvious.

**Applies to:**

- Any comment on a GitHub pull request, including PR review comments and inline code-review comments
- Any comment on a Linear issue
- The body of any Linear issue you create or modify

**Exception — PR body:** The GitHub PR body is assumed to be written by Claude by default, so no prefix is needed there. But:

- If a `## Human overview` (or similarly named) section is present in the PR body, preserve it verbatim. Never modify, rewrite, or overwrite it without explicit permission from the user — it is the user's own words added after the fact.
- When editing a PR body that has a human overview section, leave that section untouched and only change the surrounding Claude-authored content.
