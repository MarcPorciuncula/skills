---
id: code-removal-and-refactoring
description: Internal code removal and compatibility-boundary conventions.
---

## Code Removal and Refactoring

When refactoring or removing code in an internal codebase, first identify its runtime compatibility boundary.

When in-process code deploys atomically, update every consumer and delete obsolete code in the same change. Do not deprecate internal APIs or leave unused compatibility wrappers.

When consumers cannot update atomically (such as crossing independent services, workers, transport schemas, queues, database schemas, serialized state, or rolling deployments), use a staged rollout:

1. Introduce additive schema or dual read/write support.
2. Migrate callers and persisted data.
3. Remove the compatibility path after obsolete callers and data no longer exist.

When call sites are direct and in-process, count usages before considering staged cleanup. If there are more than 10 to 15 consumers and the user requested a narrow change, ask before adding compatibility scaffolding.

When deleting obsolete code, confirm that every source consumer and runtime path has been removed, then delete it completely.
