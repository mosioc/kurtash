# Harness Engineering

- <https://www.langchain.com/blog/how-to-build-a-custom-agent-harness>

**Core Concept**
A harness is the scaffolding around the model that connects it to the real world. The fundamental equation of an agent is **`agent = model + harness`**. The primary job of the harness is to provide the right context, tools, and guardrails to the model at every step. Achieving "Task-Harness Fit"—tailoring the scaffolding to the specific demands of the task—is what makes an agent truly useful.

**The Base Harness & Middleware**
LangChain’s `create_agent` provides a minimalistic base harness (model + tools + system prompt). To customize it, builders use **Middleware**, which hooks into the agent loop at every step (before/after model calls, before/after tool calls, startup/teardown).

**Key Harness Capabilities (via Middleware)**
Middleware allows you to bundle related logic into composable units to add specific capabilities to your agent:

- **Context Management:** Prevent context overflow in long sessions (`SummarizationMiddleware`, `ContextEditingMiddleware`).
- **Memory & State:** Load knowledge at startup and save it after runs (`FilesystemMiddleware`, `MemoryMiddleware`).
- **Environment Access:** Unlock creative solutions via filesystem and execution environments (`ShellToolMiddleware`, `CodeInterpreterMiddleware`).
- **Delegation:** Handle complex sub-tasks with clean context windows (`SubAgentMiddleware`, `TodoListMiddleware`).
- **Resilience:** Handle unpredictable model/tool failures with retries and fallbacks (`ToolRetryMiddleware`, `ModelFallbackMiddleware`).
- **Policy & Steering:** Enforce PII handling, compliance, and pause for human approval (`PIIMiddleware`, `HumanInTheLoopMiddleware`).
- **Cost Control:** Prevent runaway costs with call limits and prompt caching (`ModelCallLimitMiddleware`, `PromptCachingMiddleware`).

**Best Practices**

- **Keep logic out of prompts:** If a behavior is deterministic (business logic, policy enforcement, dynamic control), put it in middleware, not the system prompt.
- **Tailor the stack:** A customer service agent requires a vastly different middleware stack than a long-running coding agent. Choose middleware based on the specific context, failure modes, and environment of your task.
