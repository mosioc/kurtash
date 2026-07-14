# Prompt Engineering Guide

- <https://www.promptingguide.ai/>

---

## Introduction

Prompt engineering is the discipline of constructing textual interfaces for Large Language Models (LLMs). Think of it as "programming in natural language." Instead of writing code, you design and refine inputs (prompts) to guide the model toward generating desired outputs.

The model is a powerful function approximator, and your prompt is the function signature and instructions. Its importance stems from a core paradox: LLMs are trained to be general, but business applications require specific, reliable, and safe behavior. Effective prompt engineering bridges this gap, transforming a stochastic text generator into a deterministic, scalable component of a production system.

---

## LLM Settings

Before crafting a prompt, you must understand the hyperparameters that control the output distribution. These settings dramatically affect creativity and determinism.

- **Temperature (`0.0` to `2.0`):** Modulates the softmax function before token sampling, controlling randomness.
  - *Low (e.g., 0.0 - 0.2):* Makes the model deterministic, focusing on the highest-probability tokens. Ideal for fact extraction, coding, and classification. *(Example: Extracting an author's name will consistently yield "F. Scott Fitzgerald".)*
  - *High (e.g., 0.8 - 1.5):* Increases randomness and creative noise. Ideal for brainstorming or story writing. *(Example: At 1.5, the model might hallucinate "Ernest Hemingway" as the author of Gatsby).*
- **Top_p (`0.0` to `1.0`):** Nucleus sampling. An alternative to temperature where the model considers only the tokens whose cumulative probability exceeds `top_p`. It dynamically cuts off the "long tail" of improbable tokens.
  - *Usage:* Use `top_p=0.1` with a moderate temperature for a focused-but-not-repetitive effect. Excellent for technical writing where you want clarity and vocabulary range without wild tangents.
- **Max Tokens:** Limits the length of the output. Setting this too low will cut off responses mid-sentence; setting it too high can waste compute and invite rambling.
- **Stop Sequences:** Character strings that halt generation. A structural tool to prevent rambling and enable multi-turn chat formats.
  - *Example:* In a chatbot, if your prompt ends with `Agent:`, without a stop sequence, the model might generate the user's next reply. Setting a stop sequence of `\nUser:` ensures the model *only* generates the agent's reply and stops, returning control to your application.

---

## Basics of Prompting

A prompt is the input text you provide to the model. The model's goal is to predict the most likely sequence of text that follows.

**Key Principle: Clarity is Honesty.** An LLM is not a mind-reader. An ambiguous prompt is a request for hallucination. If an output can be interpreted in multiple ways, be explicit about your desired interpretation.

- **Bad:** "Tell me about cats." / "Write a script about a bank robbery."
- **Good:** "In three bullet points, summarize the evolutionary history of the domestic cat, focusing on its divergence from the African wildcat."
- **Better:** "Write a 3-page, single-spaced screenplay excerpt about a bank robbery. The genre is silent slapstick comedy. The two robbers are incompetent mimes who never speak. The scene ends when the safe door falls on them. Use standard screenplay formatting."

---

## Prompt Elements

Deconstruct your intent into these reusable components. A well-structured prompt often contains one or more of these:

1. **Instruction / System Message:** The specific task and the immutable rules of engagement. Sets the persona or tone.
    > **System:** You are GrumpyCodeBot, a senior C++ developer with 40 years of experience. You loathe unnecessary abstraction. You answer with a sarcastic, pessimistic tone but with technically flawless, memory-safe code. You never say "hello."
2. **Context:** Background information to steer the model's understanding.
3. **Input Data with Delimiters:** The primary text the instruction acts upon. The non-negotiable source of truth.
    > Analyze the customer review delimited by triple backticks.
>
    > ```
    > The camera's autofocus is lightning-fast, but the battery drains in 2 hours.
    > ```
>
1. **Output Indicator:** A hint at the start of the desired output to enforce format and prime the model.
    > Write a product description for the above camera.
    > Product Name:
    > Key Features (as a bulleted list):
    > Target Audience:

---

## General Tips for Designing Prompts

1. **Use Delimiters:** Clearly separate parts of the prompt using `###`, `---`, `"""`, or XML tags `<context>`. This helps the model parse the structure and prevents prompt injection.
2. **Ask for Specific Output Formats:** If you need JSON, a table, or a bulleted list, explicitly ask for it. *(e.g., "Output a valid JSON object with keys 'name' and 'date'.")*
3. **Condition Instead of Forbidding:** The model often ignores the word "don't" and focuses on the forbidden concept. Tell it *what to do*.
    - *Weak:* "Don't talk about competitors."
    - *Strong:* "Write copy that exclusively describes our product's patented cooling technology. Mention no other brands."
4. **Use the "Sandwich" Technique:** Lead with the instruction, provide the context/data in the middle, and re-state the instruction with the desired output format at the end. This grounds the model.
5. **Break Down Complex Tasks:** Instead of one giant prompt, decompose a task into smaller, sequential steps. This is the foundation of Prompt Chaining.
6. **Test and Iterate:** Prompt engineering is an empirical science. Run your prompt multiple times (especially with a temperature > 0) to observe variance, then refine.

---

## Basic Examples

**Simple Q&A:**
> Answer the question based on the context below.
> Context: Seattle is famous for its coffee and rainy weather.
> Question: What is Seattle's weather known for?
> Answer:

**Text Classification with Reasoning:**
> Classify this support ticket. First, identify the core complaint. Second, identify any immediate business impact. Finally, classify the ticket as 'Billing Issue', 'Technical Bug', or 'Account Inquiry'.
> Ticket: "My credit card was charged three times for the same service, and I can't log in to cancel it. This is urgent!"
> Reasoning:
> Core Complaint:
> Business Impact:
> Classification:

---

## Advanced Prompting Techniques

This is your core toolkit. Start with the basics and scale up to these advanced frameworks as needed.

### 1. Zero-shot Prompting

Provide only the instruction, with no examples. This relies entirely on the model's pre-trained knowledge.

- **Weak:** "Summarize this."
- **Strong:** "Write a 2-sentence executive summary of the following quarterly earnings report, focusing on revenue growth and market headwinds."

### 2. Few-shot Prompting

Provide a few examples (the "shots") of input-output pairs *inside the prompt* to condition the model on the pattern you want. You are performing implicit gradient descent through the context window.
> Create a catchy, portmanteau product name from the two inputs. Format exactly as shown.
> Input: spoon + fork
> Output: "Spork - The Utensil, Evolved."
> Input: blanket + sleeve
> Output: "The Snuggie - Warmth Without Confinement."
> Input: keyboard + wallet
> Output:

### 3. Chain-of-Thought (CoT) Prompting

Instruct the model to break down its reasoning step-by-step before providing a final answer. This externalizes the reasoning scratchpad and drastically improves performance on math and logic.

- **Zero-shot CoT:** Simply append the magic phrase: *"Let's think step by step."*
- **Few-shot CoT:** Your examples must model the unspoken reasoning process.
    > Q: An orchestra has 10 violinists. 2 leave, and a cellist is promoted to conductor. How many people are playing instruments?
    > A: The orchestra has 10 violinists. If 2 leave, there are 8 left. A cellist is promoted to conductor, so they stop playing an instrument. This means 1 fewer person is playing. So 8 - 1 = 7. Answer is 7.
    > Q: A library has 50 books. It sells 15 and buys 6 more. 2 are lost. How many books remain?

### 4. Meta Prompting

Use one LLM to generate, critique, or refine prompts for another LLM. Treat a prompt as a generated artifact.

- **Step 1 (Meta-Prompt):** "You are a prompt engineer. Create a detailed prompt for an AI to act as a skeptical venture capitalist analyzing a startup pitch."
- **Step 2 (Generated Output):** The AI outputs a highly specific, structured prompt.
- **Step 3 (Execution):** You feed a startup pitch into that *generated* prompt.

### 5. Self-Consistency

An enhancement to CoT. Instead of taking the first greedy answer, run the model multiple times with a high temperature. Gather all the reasoning paths and final answers, then return the most common answer (majority vote). This smooths out individual reasoning errors and hallucinations.

### 6. Generate Knowledge Prompting

First, ask the LLM to generate relevant background knowledge. Then, inject that generated knowledge into a *new* prompt that asks the question.

- **Step 1:** "Generate 5 scientific facts about the diet of the Greenland shark."
- **Step 2:** "Using *only* the facts below, answer: What is the most surprising prey of the Greenland shark? [Insert generated facts]"

### 7. Prompt Chaining

Decompose a complex task into a series of simpler, sequential API calls. The output of Prompt 1 becomes the input for Prompt 2.

- **Chain:** Draft -> Critique -> Rewrite -> Format.
- *Why use it?* Allows for deterministic control flow, debugging, and error handling between steps, unlike a single massive prompt.

### 8. Tree of Thoughts (ToT)

An advanced exploration technique for complex planning. The LLM generates multiple "thought" steps, evaluates the promise of each, and uses a search algorithm (like BFS or DFS) to explore the most promising paths, looking ahead multiple steps before committing. Ideal for creative problem-solving and strategic planning.

### 9. Retrieval Augmented Generation (RAG)

Not just a prompt, but a design pattern. You retrieve relevant, up-to-date, or proprietary information from a vector database and inject it into the prompt as context.
> Answer the question based **exclusively** on the provided context. If the answer is not in the context, say "I don't have that information." Provide a direct quote to support your answer.
> Context: {retrieved_chunks}
> Question: {user_query}

### 10. ReAct & Automatic Tool-Use

A paradigm that synergizes **Rea**soning and **Act**ing. The prompt is structured as an interleaved sequence of Thoughts, Actions, and Observations. The model recognizes when it can't answer internally and calls external tools (APIs, calculators).
> **Thought:** I need to find the total hours required. 5500 / 150 = ?
> **Action:** `CALCULATE: 5500 / 150`
> **Observation:** 36.666... *(Returned by external Python interpreter)*
> **Thought:** The factory needs 36.667 hours. It runs 16 hours/day. I need to divide and round up.
> **Action:** `CALCULATE: ceil(36.667 / 16)`
> **Observation:** 3
> **Final Answer:** It will take 3 full days.

### 11. Program-Aided Language Models (PAL)

Instead of having the LLM perform complex arithmetic itself, have it write code (e.g., Python) to do the computation. The code is executed by an external interpreter, and the result is returned. This delegates precise, iterative computation to a deterministic runtime, eliminating LLM math errors.

### 12. Automatic Prompt Engineer (APE)

An automated framework where an LLM generates a batch of candidate prompts, evaluates them against a test set (fitness function), selects the top performers, and mutates them to generate new candidates. This evolutionary loop "evolves" highly effective, non-intuitive prompts without human intervention.

### 13. Active-Prompt

A method to improve CoT by identifying the most helpful few-shot examples. It queries the model to find the most uncertain or highest-entropy examples. A human then annotates these *specific* examples with high-quality reasoning chains, which are used as the few-shot examples for the final prompt.

### 14. Directional Stimulus Prompting

Instead of full few-shot examples, use a smaller, tunable "policy" model to generate a single hint or keyword (the stimulus) for each input to guide the main LLM's generation in a desired direction (e.g., generating specific keywords to force a left-leaning or right-leaning summary of a neutral article).

### 15. Reflexion

A framework for autonomous agents paired with a "verbal reinforcement learner." When an agent fails a task, a separate Reflective LLM analyzes the trajectory, provides a verbal critique, and stores this reflection in long-term memory. The Actor accesses these reflections on future trials to improve performance without gradient updates.

### 16. Multimodal CoT

An extension of Chain-of-Thought to non-text modalities (like images). The model first generates a textual rationale describing the visual reasoning, and then produces the final answer based on that rationale. This provides interpretable steps for visual Q&A and allows for debugging *why* a visual question was answered incorrectly.

### 17. Graph Prompting

A technique for tasks involving graph-structured data (like knowledge graphs). The prompt is augmented with a sampled subgraph relevant to the query (translated into a linear, textual narrative of relationships). This allows the LLM to directly reason over the structural relationships (nodes and edges) in the graph, enabling structured reasoning beyond its standard training data.
