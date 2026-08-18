---
id: attributing-content
description: GitHub and Linear content attribution conventions.
---

## Attributing content on GitHub and Linear

Attribution describes who supplied the posted content, not who initiated or participated in the task.

When posting an AI-authored or AI-assisted comment on a GitHub pull request or Linear issue, prefix it with a provenance label.

Choose the label for the model family producing the content. Do not infer it from the guidance filename or active harness:

- ChatGPT or Codex using an OpenAI model: **`ChatGPT`**
- Claude or Claude Code using an Anthropic model: **`Claude`**
- Another model or harness: its recognizable model-family or harness name

Then choose authorship in this order:

1. When posting strictly verbatim user-provided text, use **no label**.
2. When user-provided source text or substantive talking points are the basis of most of the post, use **`[AI Assisted - <MODEL> / {{USER_NAME}}]`**. This includes the agent paraphrasing, reorganizing, polishing, or augmenting that material, or filling gaps the user could not supply.
3. In every other case, use **`[AI Generated - <MODEL>]`**. This includes the user choosing the topic or outcome, requesting or directing the investigation, answering questions, reviewing the result, or approving it for posting.

Do not infer editorial authorship from user involvement in the task.

<!--
{{USER_NAME}} is replaced with the user's preferred attribution name when this
chunk is rendered. The placeholder remains in the chunk source.
-->

The excepted primary-content fields below need no prefix.

Never create a `## Human overview` or similarly named section. Preserve any existing human-overview section verbatim unless the user explicitly asks to edit it; change only the surrounding agent-authored content.

When the user explicitly changes the excepted fields, update the list. Do not infer changes from indirect signals.

<!-- customisable: each entry names a platform field where the agent composes primary content rather than a comment. -->

### Excepted fields

- GitHub PR title
- GitHub PR body
- Linear issue title
