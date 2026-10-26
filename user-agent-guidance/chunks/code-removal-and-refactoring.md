---
id: code-removal-and-refactoring
description: Internal code removal and compatibility boundaries.
---

## Code Removal and Refactoring

When refactoring or removing code in an internal codebase, establish its runtime compatibility boundary before deleting code.

When in-process code deploys atomically, update all consumers and delete obsolete code in the same change. Do not leave deprecation wrappers or unused internal APIs.

When changes cross independent processes, services, queues, transport schemas, database schemas, or rolling deployments, use a staged rollout:
1. Introduce additive schema or dual read/write support.
2. Migrate callers and persisted data.
3. Remove the compatibility path after old callers and persisted records no longer exist.

When call sites are direct and in-process, count usages before considering staged cleanup. If there are more than 10 to 15 consumers and the user requested a narrow change, ask before adding compatibility scaffolding.

When deleting obsolete code, confirm all source callers and runtime paths have been removed, then delete it completely.
