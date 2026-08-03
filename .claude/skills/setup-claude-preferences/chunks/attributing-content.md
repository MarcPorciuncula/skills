---
id: attributing-content
description: Label AI-authored GitHub and Linear comments by authorship; preserve human-authored overview sections.
---

## Attributing content on GitHub and Linear

Prefix AI-authored or AI-assisted comments on GitHub pull requests and Linear issues with a provenance label.

Choose the label for the model family producing the content. Do not default to Claude because this guidance is stored in `CLAUDE.md`:

- ChatGPT or Codex using an OpenAI model: **`ChatGPT`**
- Claude or Claude Code using an Anthropic model: **`Claude`**
- Another model or harness: its recognizable model-family or harness name

Then choose authorship:

- **`[AI Generated - <MODEL>]`** when the agent composed the text without the user shaping the wording or investigation.
- **`[AI Assisted - <MODEL> / {{USER_NAME}}]`** when the user supplied talking points, directed the investigation that became the post, edited or approved a draft, or otherwise shaped the content.
- **No label** only when posting strictly verbatim user-provided text. Any rewording makes it AI Assisted.

<!--
{{USER_NAME}} is replaced with the user's preferred attribution name when this
chunk is rendered. The placeholder remains in the chunk source.
-->

The excepted primary-content fields below need no prefix.

Never create a `## Human overview` or similarly named section. Preserve any existing human-overview section verbatim unless the user explicitly asks to edit it; change only the surrounding agent-authored content.

Update the excepted-field list only when the user explicitly changes it.

<!-- customisable: each entry names a platform field where the agent composes primary content rather than a comment. -->

### Excepted fields

- GitHub PR title
- GitHub PR body
- Linear issue title
