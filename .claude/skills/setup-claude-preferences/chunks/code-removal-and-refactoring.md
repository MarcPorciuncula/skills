---
id: code-removal-and-refactoring
description: Internal code removal and compatibility-boundary conventions.
---

## Code Removal and Refactoring

Treat a compatibility boundary as a runtime property, not a repository property.

When in-process code deploys atomically, update every consumer and delete the old code in the same change. Do not deprecate internal APIs or leave unused compatibility wrappers.

Before assuming all consumers can change atomically, inspect for boundaries such as:

- separate services, workers, CLIs, binaries, plugins, or independently deployed processes;
- HTTP, RPC, queues, events, tasks, sockets, or generated clients;
- persisted jobs, serialized payloads, database rows, caches, or object storage;
- rolling deployments or any period when old and new versions can overlap;
- external consumers outside the repository.

When auditing consumers, do not rely on source call-site search alone. Check deployment units, transport handlers and schemas, task or event names, persisted data, and version-skew behavior.

When consumers cannot move atomically, use the smallest compatible rollout: additive schemas, dual read or write, staged producer and consumer changes, data migration, or a temporary compatibility layer. Remove the compatibility path after old producers, consumers, and persisted data can no longer use it.

When call sites are direct and in-process, count usages before considering a staged cleanup. If there are more than 10–15 consumers and the user explicitly wants a narrow change, ask before choosing deprecation or compatibility scaffolding.

When deleting old code, first confirm that every source consumer and runtime path has been removed, then delete it completely.
