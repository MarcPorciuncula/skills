---
id: review-findings
description: Audit gate for review findings and intermediate checkpoint handoffs.
---

## Review Findings

- Before changing code in response to findings from an internal, delegated, or automated review, and before final handoff after receiving them, load `review-findings`.
- Treat explicit intermediate checkpoints (plan step, commit, work-in-progress push, draft PR, or intermediate user inspection) as handoffs, not completion; show the requested artifact and yield without running automatic self-review.
