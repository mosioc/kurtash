# Loop Engineering

- <https://www.langchain.com/blog/the-art-of-loop-engineering>
- <https://code.claude.com/docs/en/agent-sdk/agent-loop>
- <https://stevekinney.com/writing/agent-loops>
- <https://strandsagents.com/docs/user-guide/concepts/agents/agent-loop/>

**Core Concept**
Loop engineering (or "loopcraft") is the art of stacking and extending loops to build more effective agents. While the base agent is just a model calling tools in a loop, production-grade reliability requires stacking additional loops to ensure quality, scale operations, and continuously improve the system.

**The 4 Levels of Loop Engineering**

1. **Level 1: The Agent Loop (Automates Work)**
    - *What it does:* The model receives context and calls tools in a loop until the task is complete.
    - *Implementation:* LangChain’s `create_agent`.
2. **Level 2: The Verification Loop (Ensures Quality)**
    - *What it does:* Wraps the agent loop with a "grader" (deterministic or LLM-as-a-judge). It checks the output against a rubric and sends feedback back to the model to retry if it falls short.
    - *Implementation:* `RubricMiddleware` or `after_agent` hooks.
3. **Level 3: The Event-Driven Loop (Automates at Scale)**
    - *What it does:* Connects the agent to your ecosystem so it runs continuously in the background. It triggers agent runs based on events like webhooks, cron schedules, or Slack messages.
    - *Implementation:* LangSmith Deployment (cron/webhooks) or Fleet channels.
4. **Level 4: The Hill Climbing Loop (Automates Improvement)**
    - *What it does:* Analyzes production traces to detect issues and automatically rewrites the harness configuration (prompts, tools, graders) to improve future runs.
    - *Implementation:* LangSmith Engine.

**The Role of Human Oversight**
Automation does not mean removing humans. Human expertise is required at every level:

- *Agent Loop:* Approving sensitive tool calls.
- *Verification Loop:* Acting as the grader for subjective or sensitive outputs.
- *Event-Driven Loop:* Approving outputs before they reach the end user.
- *Hill Climbing Loop:* Reviewing harness improvements before deployment.
