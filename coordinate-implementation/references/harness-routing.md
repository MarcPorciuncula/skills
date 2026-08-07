# Choose the implementer tool and model

Resolve the model role using the models available in the current environment.
Treat the names below as family examples. Do not request a model that the
available tools do not expose.

## Model roles

| Role | Codex examples | Claude Code examples | Gemini-like examples |
|---|---|---|---|
| Throughput | Luna family | Haiku family | Flash-Lite family |
| Balanced | Terra family | Sonnet family | Flash family |
| Reasoning | Sol family | Opus family | Pro family |

Use the cheapest available model in the role that supports the required tools,
permissions, context, and reasoning effort. Prefer stable family names over
version-pinned identifiers when the available tools document those names.

## Codex

Create a separate user-visible task or thread through the top-level thread
creation tool, currently exposed as `create_thread` in the Codex app. Do not use
`spawn_agent` or another scoped-agent tool as the implementer agent.

1. Inspect the project, host, model, and reasoning options exposed by the
   available tools.
2. For repository work, create the implementer task in an isolated worktree
   unless the user explicitly requests the saved checkout.
3. Set the concrete model and reasoning effort in the creation call. Do not
   omit them or inherit the coordinator model.
4. Title it `IMPLEMENTER: <scope> (use coordinator)`.
5. Use the thread messaging tool for decisions and corrections. Use the thread
   wait tool for progress. Read the thread when you need evidence or need to
   answer a question.
6. Keep the user in the coordinator task. In the initial handoff, instruct the
   implementer to redirect any direct human message to the coordinator and
   wait.
7. When follow-up calls allow the model to change, use a stronger model only for
   the part that needs it. Keep the same task and worktree.

If top-level thread creation, explicit model selection, follow-up, or waiting is
unavailable, stop and report the missing capability. Do not substitute a scoped
Codex subagent.

## Claude Code

Use a scoped subagent as the implementer agent. Give it independent context and
set its model explicitly. Create a custom agent definition only when useful.

1. Inspect the available agent definitions, model names, permissions, and any
   configuration that changes the requested model.
2. Pass `model` on the initial implementation assignment and every follow-up.
   Never use `inherit`, an omitted value, or a built-in general-purpose agent
   whose model inherits from the coordinator.
3. Pass the effort explicitly when the tool supports per-agent effort.
4. Keep one implementer active against the working tree.
5. Resume the same subagent for clarified exact work. Use a stronger model only
   after the coordinator identifies an unresolved decision about behavior,
   architecture, or compatibility.

When an environment or organization setting prevents the requested lower-cost
model, report which model will actually run. Do not claim lower-cost execution
from the requested value alone when the available tools show a different model.

## Other environments

Inspect the available tools before choosing how to create the implementer:

1. List or read the tools that can create or message another agent or task.
   Inspect their real inputs and outputs.
2. Determine whether model and effort are explicit for each assignment, fixed
   for the agent's lifetime, or inherited.
3. Determine how follow-up, waiting, status, worktree access, and permissions
   work.
4. Build an ordered list of available models from cheapest to strongest using
   documented or tool-provided information.
5. Use a child agent only when its model can be selected explicitly and it
   meets the requirements in
   [Create the implementer agent](../SKILL.md#create-the-implementer-agent).
6. Otherwise, use a top-level task or session only when it meets the
   requirements in
   [Create the implementer agent](../SKILL.md#create-the-implementer-agent)
   and can be clearly labelled.
7. When the tool documentation and outputs do not establish the ordering, ask
   the user which available model corresponds to each role.

Do not infer what a tool can do from its name. Do not infer model cost ordering
from marketing names.
Do not use a tool that cannot confirm or enforce the selected model.
