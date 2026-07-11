# Caveman

Caveman is a token-saving skill and proxy mode that forces your AI assistant to drop filler words and respond in terse, highly compressed "caveman-speak." This preserves all technical accuracy and code byte-for-byte while reducing output tokens by up to 65%.

## Setup & Installation

### Option 1: Enable via 9router

If you are already using `9router`, **Caveman Mode** is built-in. You can activate it directly in the `9router` dashboard or by enabling it in your configuration to apply token compression globally across all routed LLM traffic.

### Option 2: Standalone CLI Install

To install Caveman directly as a standalone skill for AI coding agents (such as Claude Code, Cursor, Codex, or Windsurf), run:

```bash
npx caveman-skill install

```

Alternatively, you can install it system-wide via the official shell script:

```bash
curl -fsSL https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.sh | bash

```

## Compression Levels

You can adjust the intensity of the token compression based on your readability preferences. Switch levels anytime during a session using the `/caveman <level>` command:

* **Lite**: Drops basic filler words but remains grammatically complete. Lowest token savings, easiest to read.
* **Full** (Default): Drops articles and relies on sentence fragments. The optimal balance of cost savings and readability.
* **Ultra**: Uses bare fragments, heavy abbreviations, and arrows (`->`) for causality. Maximum token savings, hardest to read.

## Usage

Once installed, Caveman activates automatically on supported agents. You can also manually toggle the mode mid-session:

* **Turn On:** Type `/caveman` or simply prompt the agent to "talk like caveman".
* **Turn Off:** Type `/caveman off` or tell the agent to use "normal mode".
