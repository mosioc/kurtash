# Graph Engineering

- <https://www.langchain.com/blog/3-years-of-graph-engineering-with-langgraph>

**Core Concept**
Graph engineering is the practice of modeling agentic systems as graphs (state machines) to impose structure on LLM workflows. It allows builders to encode their "world knowledge" into the system, balancing deterministic code paths with agentic LLM reasoning to create predictable, efficient, and reliable agents.

**Architecture**

- **Nodes:** The components that do the work. A node can be deterministic code, a single LLM call, a tool execution, or even a full sub-agent.
- **Edges:** The transitions that define what happens next. They can be deterministic or conditional (based on node results, state, or external signals).

**When to Use vs. When Not to Use**

- **Use Graphs When:** Your workflow has a predictable structure (e.g., classify issue $\rightarrow$ search $\rightarrow$ synthesize). Graphs are ideal when you want to enforce specific paths and not rely solely on the LLM's judgment for routing.
- **Avoid Graphs When:** The task is highly agentic and unpredictable (e.g., generic deep research). For tasks where planning, delegation, and context management need to emerge dynamically, a flexible agent harness is a better fit than a hardcoded graph.

**Key Lessons from Production**

1. **Agents need cycles, not just DAGs:** Production agents require loops for retrying failed tools, asking users for info, revising answers, and pausing for human input. They are rarely simple Directed Acyclic Graphs (DAGs).
2. **Loops are just simple graphs:** Loop engineering isn't an alternative to graph engineering; it is simply a basic, directed, cyclic graph.
3. **Dynamic transitions are crucial:** You can't always hardcode every edge. Use dynamic routing (like LangGraph's `Send`) to handle runtime variability, such as map-reduce operations where the number of downstream workers depends on the input.
4. **Nodes can be full agents:** The modern evolution of graph engineering allows a single node to be an entire agent run, enabling you to orchestrate complex, multi-agent systems.
