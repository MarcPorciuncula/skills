---
id: attributing-content
description: GitHub and Linear content attribution and review reply authorization.
---

## Attributing content on GitHub and Linear

- Prefix AI-authored or AI-assisted GitHub PR and Linear issue comments by content authorship (using the model family name, e.g. `ChatGPT`, `Claude`):
  - Verbatim user-provided text: no label.
  - Mostly user-provided source text or talking points: `[AI Assisted - <MODEL> / {{USER_NAME}}]`.
  - All other cases: `[AI Generated - <MODEL>]`.
- Exempt fields (no prefix): GitHub PR title, GitHub PR body, Linear issue title.
- Never create `## Human overview` or similarly named sections; preserve existing ones verbatim unless explicitly asked.

<!--
{{USER_NAME}} is replaced with the user's preferred attribution name when this
chunk is rendered. The placeholder remains in the chunk source.
-->

### PR review reply allowlist

Reviewers approved for AI-attributed auto-replies and category-based thread resolution:

{{PR_REVIEW_REPLY_ALLOWLIST}}

- Update this list only on explicit user directives; never infer allowlist status.
- For human reviewers not listed above, draft replies with comment links in chat instead of posting during broad review requests.
- Post a reply to a non-allowlisted reviewer only when the current request explicitly instructs replying to that reviewer or comment; resolve a thread only when explicitly instructed.
