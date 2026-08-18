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

Use a scoped subagent as the implementer agent. Do not create a separate
user-visible task or thread for the implementer.

1. Inspect the project, host, model, and reasoning options exposed by the
   scoped-agent tool.
2. Prepare the worktree before creating the subagent. Put its absolute path in
   the handoff and require every repository command and edit to use that
   working directory.
3. Create the subagent with fresh context. Set `fork_turns: "none"`, the
   concrete model, and reasoning effort explicitly.
4. Select Luna for throughput work when the scoped-agent tool exposes it.
   Otherwise use Terra. Use Sol only for intentionally delegated reasoning.
5. Use the subagent follow-up tool for decisions and corrections. Use the agent
   wait tool for progress and completion.
6. Keep the user in the coordinator task.

If the scoped-agent tool cannot provide explicit model selection, the required
reasoning effort, follow-up, waiting, or worktree access, stop and report the
missing capability. Do not create a top-level task as a substitute.

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
