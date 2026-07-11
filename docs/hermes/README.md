# Hermes Agent

> **Further Reading:** [Hermes Agent Overview (mosioc.github.io)](https://mosioc.github.io/blog/17-hermes-agent/)

## Official Documents

Hermes provides machine-readable entry points specifically designed for LLM context ingestion. These files are generated fresh on every deployment and are available at the root or `/docs` directory:

* **[`/llms.txt`](https://hermes-agent.nousresearch.com/docs/llms.txt)**: A curated index of every documentation page with short descriptions. At ~17 KB, it is lightweight and safe to load into any standard LLM context window.
* **[`/llms-full.txt`](https://hermes-agent.nousresearch.com/docs/llms-full.txt)**: Every documentation page concatenated into a single Markdown file for comprehensive, one-shot ingestion. At ~1.8 MB, ensure your LLM has a sufficient context window before loading.

*(Note: Both files also resolve at `/docs/llms.txt` and `/docs/llms-full.txt`)*

---

## Accessing Websites

* <https://www.reddit.com/r/hermesagent/comments/1sgqyra/why_my_hermes_agent_is_just_blocked_by_every/>

If you find that Hermes is consistently blocked by websites (e.g., encountering Cloudflare challenges or 403 Forbidden errors), it is due to how the agent handles web navigation. Hermes has two distinct methods for accessing external sites:

**1. `web_extract` (Default)**
Makes basic HTTP requests to pull page content. Because it acts like a raw bot hitting the server directly with no stealth mechanisms, it is frequently blocked by modern web infrastructure.

**2. `browser` tools**
Spins up an actual browser environment that can execute JavaScript, manage cookies, and solve basic bot challenges. This is the required method for modern, heavily protected websites.

### The Fix: Anti-Bot Browser Backends

To bypass bot detection, stop using plain HTTP extraction (`web_extract`) and configure a dedicated browser backend with anti-detection capabilities:

* **Browserbase (Cloud):** The strongest option. It features built-in stealth, residential proxy rotation, and automated CAPTCHA solving. Requires an API key from Browserbase.
* **Camofox (Local, Free):** A customized Firefox fork equipped with fingerprint spoofing. It is self-hosted with no cloud dependency, making it highly effective for bypassing most standard anti-bot detection walls.
* **Local Chrome via CDP:** Connect directly to your local Chrome instance using `/browser connect`. This is highly effective if you are already authenticated into the target site or have the necessary session cookies established.
