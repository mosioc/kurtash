# OpenClaw

> **Further Reading:** [OpenClaw Overview (mosioc.github.io)](https://mosioc.github.io/blog/16-openclaw/)

OpenClaw (often referred to affectionately as "Molty") is a viral, open-source autonomous AI agent that runs entirely on your local machine. Unlike standard chatbots, it functions as a continuous background service (a local gateway) that connects Large Language Models (LLMs) directly to your file system, web browsers, and daily messaging platforms to execute real-world tasks.

## Setup & Installation

OpenClaw requires Node.js (v22+) and the `pnpm` package manager. To install the core gateway and CLI directly from the source repository:

```bash
# Clone the repository
git clone https://github.com/OpenClaw/openclaw.git
cd openclaw

# Install dependencies and build
pnpm install
pnpm build

# Link globally and initialize
pnpm link --global
openclaw init

```

To start the agent, launch it in development mode or as a background service. By default, the OpenClaw RPC server runs and listens on port `18789`.

## Key Capabilities & Integrations

OpenClaw bridges the gap between AI reasoning and actionable execution through a highly extensible plugin and skills ecosystem:

* **Messaging Channels:** Interact with your agent natively through WhatsApp, Telegram, Signal, Discord, or Slack instead of relying on a dedicated web UI.
* **Model Agnostic:** Connect to cloud provider APIs (OpenAI, Anthropic's Claude, DeepSeek) or run entirely offline models.
* **MCP & Tooling:** Extensible via Model Context Protocol (MCP). Connects directly to Zapier, local files, shell commands, headless browsers for web scraping, and smart home devices (like Home Assistant).
* **Agentic Memory:** Retains persistent conversation history and contextual preferences locally across all sessions and platforms, enabling proactive automation.

## Running Local AI Models (with Ollama)

If you prefer to keep your data completely private and avoid API costs, you can configure OpenClaw to run against a local model using Ollama.

1. Ensure Ollama is installed and running (`ollama serve`).
2. Pull your desired model (e.g., `ollama pull llama3`).
3. Update your OpenClaw configuration file (typically located at `~/.openclaw/openclaw.json`) to point to your local instance:

```json
{
  "llm": {
    "provider": "ollama",
    "endpoint": "http://localhost:11434",
    "model": "llama3"
  }
}

```

1. Restart the OpenClaw gateway to apply the new model configuration.

---

> **Security Note:** Because OpenClaw operates with high-level system permissions (including file read/write access and shell execution capabilities), ensure your RPC port and webhook endpoints are properly secured. Avoid exposing your local gateway directly to the public internet without rigorous authentication tunnels (such as Cloudflare Tunnels).
