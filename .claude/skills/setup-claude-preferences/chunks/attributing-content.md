---
id: attributing-content
description: Prefix GitHub and Linear comments with provenance labels (`[AI Generated - Claude]` / `[AI Assisted - Claude / NAME]`) chosen by who authored the text; customisable list of primary-content fields is excepted, with human-overview sections inside them preserved verbatim.
---

## Attributing content on GitHub and Linear

The goal: anyone reading the PR or issue — the user, reviewers, future readers — needs to tell at a glance which content came from an AI agent autonomously, which was AI-drafted with the user in the loop, and which the user wrote themselves. Prefix anything you author or co-author on those platforms with a provenance label.

**Two labels — pick by who authored the text, not who requested the work:**

- **`[AI Generated - Claude]`** — Claude wrote the text autonomously while carrying out a user-requested task. The user asked for an outcome (e.g. "address the review", "reply to the bot"); Claude composed the post itself with no further user involvement.
- **`[AI Assisted - Claude / {{USER_NAME}}]`** — the user shaped the text. Use when *any* of these apply:
  - The user specifically drove the inquiry whose answer became this text (e.g. asked Claude to investigate a question and post the findings).
  - The user approved a draft Claude prepared before it was posted.
  - The user provided text or talking points that Claude altered, expanded, or polished before posting.

<!--
{{USER_NAME}} is a placeholder. When this chunk is rendered into a user's CLAUDE.md,
the setup-claude-preferences skill substitutes the user's preferred attribution name
(typically their first name) into the rendered file. The placeholder stays in the
chunk source. See setup-claude-preferences/SKILL.md → "Placeholder substitution".
-->

**No label** — only when the user gave Claude strictly verbatim text and asked the agent to post it on their behalf. Anything the agent added, rephrased, or restructured moves the post into "AI Assisted".

**Applies to:**

- Any comment on a GitHub pull request, including PR review comments and inline code-review comments
- Any comment on a Linear issue

**Exception — primary-content fields.** The fields listed below are assumed to be Claude-authored by default, so no prefix is needed on the field itself.

The human-overview preservation rule applies inside body fields (titles have no inner sections):

- Never author a `## Human overview` (or similarly named) section yourself. The heading is a provenance claim about the user — writing under it lies about authorship. If you have framing to add, put it in the lede prose, not under that heading.
- If such a section is present, preserve it verbatim. Never modify, rewrite, or overwrite it without explicit permission from the user — it is the user's own words added after the fact.
- When editing a body that has a human overview section, leave that section untouched and only change the surrounding Claude-authored content.

**Self-update.** When the user adds or removes an excepted field (e.g. "stop prefixing PR review summaries", "treat ADR titles as primary content"), edit the list below to match. Only act on explicit directives — do not infer changes from indirect signals.

<!-- customisable: edit the list below per machine. Each entry names a specific platform field where Claude composes primary content (not a comment). -->

### Excepted fields

- GitHub PR title
- GitHub PR body
- Linear issue body
