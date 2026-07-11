# RTK

`9router` supports RTK by default.

RTK (Token Saver) is an intelligent compression engine that automatically intercepts and shrinks large tool outputs—such as `git diff`, `grep`, `ls`, and `tree`, before forwarding the request to the LLM.

By safely stripping redundant data and formatting from raw `tool_result` content, RTK minimizes your context window usage and saves **20% to 40% of input tokens** per request. This helps you stretch your API limits, maximize free model quotas, and reduce costs on paid subscriptions without degrading the AI's coding accuracy.

### How it Works

Because RTK is active out-of-the-box, no extra configuration is required. When your connected AI coding assistant (e.g., Claude Code, Cursor, Codex, or Cline) executes a local command, `9router` seamlessly:

1. Parses the outgoing request payload.
2. Identifies bulky command-line tool execution outputs.
3. Compresses the text while retaining the critical semantic code structure.
4. Routes the optimized payload to your selected AI provider.

*Tip: You can monitor your exact token savings per request and overall quota usage in real-time by checking the **9router Dashboard** (typically available at `http://localhost:20128`).*
