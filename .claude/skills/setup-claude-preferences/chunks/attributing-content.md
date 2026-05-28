---
id: attributing-content
description: Prefix AI-generated or AI-assisted GitHub and Linear content with provenance labels (`[AI Generated - Claude]` / `[AI Assisted - Claude / NAME]`); preserve human-overview sections in PR bodies verbatim.
---

## Attributing content on GitHub and Linear

The goal: anyone reading the PR or issue — the user, reviewers, future readers — needs to tell at a glance which content came from an AI agent autonomously, which was AI-drafted but human-posted, and which the human wrote themselves. Prefix anything you author or co-author on those platforms with a provenance label.

**Two labels — pick by who is actually posting:**

- **`[AI Generated - Claude]`** — content Claude wrote and posted directly with no human review before posting. Use for autonomous replies, comments, status updates, and anything else the agent posts on behalf of the user without first surfacing it for review.
- **`[AI Assisted - Claude / {{USER_NAME}}]`** — content Claude drafted that the human ({{USER_NAME}}) posts themselves, with or without editing. Use when surfacing a drafted reply for the user to post, and keep the prefix on the drafted text so the user can post it verbatim and the provenance stays accurate.

<!--
{{USER_NAME}} is a placeholder. When this chunk is rendered into a user's CLAUDE.md,
the setup-claude-preferences skill substitutes the user's preferred attribution name
(typically their first name) into the rendered file. The placeholder stays in the
chunk source. See setup-claude-preferences/SKILL.md → "Placeholder substitution".
-->

**Applies to:**

- Any comment on a GitHub pull request, including PR review comments and inline code-review comments
- Any comment on a Linear issue
- The body of any Linear issue you create or modify

**Exception — PR body:** The GitHub PR body is assumed to be Claude-authored by default, so no prefix is needed there. But:

- Never author a `## Human overview` (or similarly named) section yourself. The heading is a provenance claim about the user — writing under it lies about authorship. If you have framing to add, put it in the lede prose, not under that heading.
- If such a section is present in the PR body, preserve it verbatim. Never modify, rewrite, or overwrite it without explicit permission from the user — it is the user's own words added after the fact.
- When editing a PR body that has a human overview section, leave that section untouched and only change the surrounding Claude-authored content.
