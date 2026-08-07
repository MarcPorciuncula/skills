# Harness routing

Resolve the role to a concrete model from the live harness surface. Treat the
names below as family examples. Do not request a model the harness does not
expose.

## Model roles

| Role | Codex examples | Claude Code examples | Gemini-like examples |
|---|---|---|---|
| Throughput | Luna family | Haiku family | Flash-Lite family |
| Balanced | Terra family | Sonnet family | Flash family |
| Reasoning | Sol family | Opus family | Pro family |

Use the cheapest live model in the role that supports the required tools,
permissions, context, and reasoning effort. Prefer explicit family aliases over
version-pinned identifiers when the harness documents those aliases.

## Codex

Create a separate user-visible task or thread through the top-level thread
creation tool, currently exposed as `create_thread` in the Codex app. Do not use
`spawn_agent` or another scoped-agent tool as the managed implementer.

1. Inspect the available project, host, model, and reasoning metadata exposed
   by the live tools.
2. For repository work, create the managed task in an isolated worktree unless
   the user explicitly requests the saved checkout.
3. Set the concrete model and reasoning effort in the creation call. Do not
   omit them or inherit the coordinator model.
4. Title it `MANAGED IMPLEMENTER — <scope> — use coordinator`.
5. Use the thread messaging tool for decisions and corrections, the thread
   wait tool for progress, and targeted thread reads for evidence or questions.
6. Keep the user in the coordinator task. In the initial handoff, instruct the
   implementer to redirect any direct human message to the coordinator and
   wait.
7. When follow-up calls support a model override, change models only for the
   work unit that needs it. Keep the same task and worktree.

If top-level thread creation, explicit model selection, follow-up, or waiting is
unavailable, stop and report the missing capability. Do not substitute a scoped
Codex subagent.

## Claude Code

Use a scoped subagent with independent context and explicit model control.
Create a custom implementer definition only when useful.

1. Inspect the available agent definitions, model aliases, permissions, and
   effective model overrides.
2. Pass `model` on every implementation dispatch or resume. Never use
   `inherit`, an omitted value, or a built-in general-purpose worker whose model
   inherits from the coordinator.
3. Pass the effort explicitly when the surface supports per-agent effort.
4. Keep one implementer active against the working tree.
5. Resume the same subagent for clarified mechanical work. Use a stronger model
   only after the coordinator identifies a remaining semantic decision.

When an environment or organization override prevents the requested lower
model, report the effective constraint. Do not claim lower-tier execution from
the requested value alone when the harness exposes contrary evidence.

## Other harnesses

Inspect the live capabilities before selecting a surface:

1. List or read the available delegation tools and their real inputs and
   outputs.
2. Determine whether model and effort are explicit per dispatch, fixed per
   worker, or inherited.
3. Determine how follow-up, waiting, status, worktree access, and permissions
   work.
4. Build a concrete cheapest-to-strongest model ladder from documented or
   tool-provided metadata.
5. Use a model-selectable child when it satisfies the complete contract.
6. Otherwise use a controlled top-level task or session when it satisfies the
   contract and can be clearly labelled.
7. Ask the user for a model mapping when the available metadata does not
   establish one.

Do not infer capability from a tool name or cost ordering from marketing names.
Do not use a surface that cannot confirm or enforce the selected model.
