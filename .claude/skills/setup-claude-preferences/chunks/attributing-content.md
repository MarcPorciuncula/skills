---
id: attributing-content
description: GitHub and Linear content attribution conventions.
---

## Attributing content on GitHub and Linear

Prefix AI-authored or AI-assisted comments on GitHub pull requests and Linear issues with a provenance label.

Choose the label for the model family producing the content. Do not default to Claude because this guidance is stored in `CLAUDE.md`:

- ChatGPT or Codex using an OpenAI model: **`ChatGPT`**
- Claude or Claude Code using an Anthropic model: **`Claude`**
- Another model or harness: its recognizable model-family or harness name

Then choose authorship:

- **`[AI Generated - <MODEL>]`** when the agent supplied most of the substance and wording. This remains AI Generated when the user chose the topic or outcome, requested or directed the investigation, answered questions, reviewed the result, or approved it for posting.
- **`[AI Assisted - <MODEL> / {{USER_NAME}}]`** only when user-provided source text or substantive talking points are the basis of most of the post. Use this label when the agent paraphrases, reorganizes, polishes, or augments that material, including filling gaps the user could not supply.
- **No label** only when posting strictly verbatim user-provided text.

Do not infer editorial authorship from user involvement in the task. When the contribution is mixed or unclear, use AI Generated unless the user's supplied material plainly accounts for most of the content.

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
