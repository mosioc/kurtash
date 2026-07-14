# LLM Context Management

## Introduction

Context management is the discipline of selecting, formatting, and delivering the optimal amount of information to an LLM to achieve a specific task.

An LLM’s "context window" is its short-term memory. While modern models support massive context windows (e.g., 128K to 1M+ tokens), **more context does not equal better performance**. Dumping entire documents into a prompt leads to higher costs, increased latency, diluted attention, and a well-documented phenomenon called "Lost in the Middle," where models ignore information buried in the center of a long prompt. Effective context management transforms a bloated, expensive prompt into a lean, highly targeted, and cost-effective input.

---

## The Anatomy of Context: Core Concepts

1. **Tokens:** The fundamental unit of text for an LLM (roughly 4 characters or 0.75 words in English). Context limits are measured in tokens, not characters.
2. **Context Window:** The maximum number of tokens the model can process in a single request (Input Tokens + Output Tokens).
3. **Signal-to-Noise Ratio:** The proportion of relevant information (signal) to irrelevant information (noise). High noise degrades reasoning and increases hallucination.
4. **The "Lost in the Middle" Phenomenon:** Research shows LLMs exhibit a "U-shaped" attention curve. They recall information best at the very beginning (primacy effect) and the very end (recency effect) of a prompt, often ignoring or hallucinating details buried in the middle.

---

## Fundamental Context Management Strategies

### 1. Token Budgeting and Strict Truncation

Never assume the model will "just figure it out" if you exceed limits. Proactively manage your token budget.

* **Strategy:** Calculate the estimated token count of your system prompt, expected user input, and desired output. Reserve a strict buffer for the output.
* **Implementation:** If a document exceeds the budget, truncate it intelligently. Instead of blindly cutting the end, truncate the *least relevant* sections first (e.g., remove long legal disclaimers or repetitive boilerplate).

### 2. Sliding Window for Conversations

In multi-turn chat applications, sending the entire conversation history with every request quickly exhausts the context window and inflates costs.

* **Strategy:** Maintain a "sliding window" of the most recent $N$ turns (e.g., the last 5-10 exchanges).
* **Enhancement:** When the window slides, summarize the dropped turns.
  > *Example:* Instead of sending 20 turns, send: `[Summary of turns 1-15: User asked about refund policy, Agent explained the 30-day rule. User expressed frustration.]` + `[Full text of turns 16-20]`.

### 3. Smart Chunking (For RAG Pipelines)

When retrieving data from a knowledge base, how you split (chunk) the text dictates retrieval quality.

* **Fixed-Size Chunking:** Splitting text every 500 tokens. *Flaw:* Often cuts sentences or paragraphs in half, destroying context.
* **Semantic Chunking:** Splitting text at natural boundaries (e.g., paragraphs, sections, or using embedding-based similarity to find breakpoints).
* **Overlap:** Always include a token overlap (e.g., 10-20%) between chunks so that context spanning a boundary is not lost.

---

## Advanced Context Management Techniques

### 1. Context Pruning and Compression

Instead of retrieving raw text, compress the context before sending it to the main LLM.

* **LLMLingua / Selective Context:** Use a smaller, cheaper model (or a specialized algorithm) to analyze the retrieved context and strip out filler words, redundant phrases, and irrelevant sentences while preserving the core semantic meaning.
* **Example:** A 2,000-token retrieved document is compressed into a dense 400-token summary containing only the facts relevant to the user's specific query.

### 2. Hierarchical / Recursive Summarization

For massive documents (e.g., a 100-page PDF), you cannot rely on a single retrieval pass.

* **Strategy:**
  1. Chunk the document into small pieces.
  2. Summarize each chunk.
  3. Summarize the summaries.
  4. Store this hierarchy. When a query arrives, search the top-level summaries to find the relevant branch, then drill down to the specific chunk. This is the foundation of frameworks like LangChain's `Map-Reduce` or `Refine` chains.

### 3. Dynamic Context Routing

Not every query needs the same amount or type of context. Route the query dynamically to save cost and latency.

* **Simple Query:** "What is your return policy?" → Route to a small, fast model with a 2-paragraph cached context.
* **Complex Query:** "Compare the return policies of your company with Competitor X based on the 2023 legal documents." → Route to a high-reasoning model, trigger a multi-vector retrieval, and assemble a 10,000-token context.

### 4. Prompt Caching (API-Level Optimization)

Modern LLM providers (like Anthropic, OpenAI, and Google) offer **Prompt Caching**.

* **How it works:** If you send the exact same prefix of tokens (e.g., a massive system prompt, a 50-page constitution, or a large codebase) in multiple requests, the provider caches the computed key-value (KV) states of those tokens.
* **Benefit:** Subsequent requests with that cached prefix see up to an 80% reduction in latency and a massive discount on input token costs. *Always place static, large context at the very beginning of your prompt to maximize cache hits.*

### 5. Entity and State Tracking (Memory)

For long-running autonomous agents, raw conversation history is inefficient. Maintain a structured "Memory Bank" alongside the chat.

* **Strategy:** Use a background process to extract and update key-value pairs or a JSON object representing the user's state.
* **Example Memory Object:**

  ```json
  {
    "user_name": "Mehdi",
    "preferences": {"tone": "concise", "format": "bullet points"},
    "current_project": "Building a RAG pipeline",
    "constraints": ["No external API calls", "Python only"]
  }
  ```

  Inject this compact JSON into the system prompt instead of making the LLM re-read 50 turns of conversation to remember the user's name or coding constraints.

---

## Best Practices for Structuring Context

How you format the context is just as important as the content itself. LLMs are highly sensitive to structure.

### 1. Leverage the Primacy and Recency Effects

Because of the "Lost in the Middle" phenomenon, structure your prompt like a sandwich:

* **Top (Primacy):** The most critical, non-negotiable instructions and the user's core query.
* **Middle:** The supporting context, retrieved documents, or data.
* **Bottom (Recency):** The final output format instructions and a restatement of the core constraint.

> *Example:* "Answer the user's question. [Insert 10 pages of context here]. Remember: Answer ONLY using the context above. If the answer is not present, state 'Unknown'."

### 2. Use Heavy Delimiters

When injecting external context, clearly separate it from your instructions to prevent "prompt injection" (where the model confuses the data for instructions).

* Use XML tags: `<context> ... </context>`, `<user_history> ... </user_history>`
* Use Markdown: `### CONTEXT START ###` ... `### CONTEXT END ###`

### 3. Inject Metadata into Context

When passing retrieved chunks, include metadata so the LLM can weigh the information's credibility and relevance.
> **Document 1**
>
> * Source: Employee Handbook v2.4
> * Date: January 2026
> * Author: HR Department
> * Content: The remote work policy allows...

### 4. Condition the Model on Missing Information

Explicitly instruct the model on how to handle gaps in the context. This is the #1 defense against hallucination.
> "You are a helpful assistant. Answer the question based **exclusively** on the provided `<context>`. If the answer cannot be definitively found in the context, you must reply: 'I do not have enough information in the provided context to answer this.' Do not use outside knowledge."

---

## Context Management Checklist for Production

Before deploying an LLM feature, run your context strategy through this checklist:

* [ ] **Token Count:** Have I estimated the max input + output tokens to ensure it fits the model's limit?
* [ ] **Relevance:** Have I removed boilerplate, headers, footers, and irrelevant tangents from the injected context?
* [ ] **Ordering:** Are the most critical instructions at the very top and very bottom of the prompt?
* [ ] **Delimiters:** Is the external data clearly separated from the system instructions using XML or Markdown?
* [ ] **Fallback:** Does the prompt explicitly tell the model what to do if the context does not contain the answer?
* [ ] **Cost/Latency:** Am I using prompt caching for static context? Could a smaller model summarize this context before passing it to the main model?
* [ ] **State:** For multi-turn chats, am I using summarization or a structured memory JSON instead of raw, endless history?

---

## Example: Bad vs. Good Context Management

### ❌ Bad Context Management (The "Data Dump")
>
> System: You are a helpful assistant.
> User: What is the warranty on the X200 router?
> [Pastes entire 40-page, unformatted PDF text of the company's global terms of service, including sections on software licenses, EU privacy laws, and maritime shipping, totaling 15,000 tokens]
> Answer the question.

*Flaws:* Massive token cost, high latency, high chance of "Lost in the Middle," no clear delimiters, no fallback for missing info.

### ✅ Good Context Management (Optimized)
>
> **System:** You are a customer support agent. Answer the user's question based **only** on the provided `<warranty_context>`. If the answer is not in the context, reply: "I cannot find that specific warranty detail in our current documentation."
>
> **User:** What is the warranty on the X200 router?
>
> `<warranty_context>`
> **Document:** Hardware Warranty Policy (v3.1, Updated: 2026)
> **Product:** X200 Wireless Router
> **Coverage:** 24 months from date of purchase. Covers manufacturing defects. Does not cover water damage or unauthorized modifications.
> `</warranty_context>`
>
> **Instruction:** Provide a concise, 1-2 sentence answer.

*Strengths:* Strict token budget, clear XML delimiters, explicit hallucination guardrail, metadata included, output format constrained, leverages recency/primacy.
