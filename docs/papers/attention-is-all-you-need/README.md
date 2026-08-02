# Attention Is All You Need (2017) Summary

**Paper:** *Attention Is All You Need*  
**Authors:** Ashish Vaswani and colleagues at Google  
**Published:** 2017  

## One-Sentence Summary

The paper introduced the **Transformer**, a neural network architecture that relies entirely on attention mechanisms instead of recurrence (RNNs) or convolutions (CNNs), making language models significantly faster to train and better at capturing long-range dependencies.

---

## Why Was This Paper Important?

Before Transformers, most NLP models used:

* Recurrent Neural Networks (RNNs)
* LSTMs
* GRUs

These models processed words one at a time.

Example:

```

I → love → machine → learning

```

Each word had to wait for the previous one.

Problems:

* Slow training
* Difficult to parallelize
* Difficulty remembering information from earlier parts of a sentence
* Long sequences were hard to model

The authors asked:

> What if we remove recurrence completely?

The answer became the Transformer.

---

## Main Idea

Instead of reading a sentence sequentially, every word looks at every other word using **self-attention**.

Example:

Sentence:

```

The animal didn't cross the street because it was tired.

```

To understand "it", the model pays attention to:

```

The animal
street
tired

```

and determines that "it" refers to "animal".

Instead of remembering everything through hidden states, the model directly examines relevant words.

---

# Transformer Architecture

The original Transformer model consists of two main components:

```

Input
│
Encoder
│
Context Representation
│
Decoder
│
Output Sentence

```

It was designed for machine translation.

Example:

```

English
↓
Encoder
↓
Decoder
↓
French

```

---

## Encoder

The encoder converts the input sentence into contextual representations.

Example:

```

I love AI

```

Each word becomes a vector:

```

I      → vector
love   → vector
AI     → vector

```

After passing through multiple encoder layers, each vector contains information about the entire sentence.

---

## Decoder

The decoder generates the output one token at a time.

Example:

```

Je
↓

Je aime
↓

Je aime IA

```

At every step it:

1. Looks at previously generated words.
2. Looks at encoder outputs.
3. Predicts the next word.

---

# Attention Mechanism

## What Is Attention?

Attention tells the model:

> Which words should I focus on while processing this word?

Example:

Sentence:

```

The cat sat on the mat.

```

When processing:

```

cat

```

attention might assign:

```

cat      0.40
sat      0.30
mat      0.10
the      0.10
on       0.10

```

More important words receive higher attention weights.

---

## Self-Attention

Self-attention allows every word to attend to every other word in the sentence.

Example:

```

The bank approved the loan.

```

For "bank", attention may focus on:

```

loan
approved

```

instead of unrelated words.

This helps the model determine that "bank" refers to a financial institution.

---

## Query, Key, and Value (Q, K, V)

Each word is transformed into three vectors:

```

Word

↓

Query
Key
Value

```

They represent:

**Query**  
"What information am I looking for?"

**Key**  
"What information do I contain?"

**Value**  
"The information I provide."

The attention score is calculated by comparing Queries and Keys.

```

Query × Key

↓

Similarity Score

↓

Softmax

↓

Attention Weights

↓

Weighted Sum of Values

```

---

## Scaled Dot-Product Attention

Formula:

```

Attention(Q,K,V)

=

softmax(QKᵀ / √dk)V

```

Where:

* Q = Queries
* K = Keys
* V = Values
* dk = Key dimension

The scaling factor √dk prevents extremely large dot products, making training more stable.

---

## Multi-Head Attention

Instead of performing one attention operation, the Transformer performs multiple attention operations in parallel.

Example:

```

Head 1
Grammar

Head 2
Verb Relationships

Head 3
Objects

Head 4
Long-Range Dependencies

```

Each head learns different types of relationships.

Their outputs are concatenated:

```

Head 1
Head 2
Head 3
Head 4

↓

Concatenate

↓

Linear Layer

```

This creates richer representations.

---

# Positional Encoding

Because the Transformer processes all words simultaneously, it has no built-in understanding of word order.

The authors introduced positional encodings.

Example:

```

I love AI

Position:

0
1
2

```

Position information is added to each word embedding.

The paper used sinusoidal functions:

```

sin(...)
cos(...)

```

This allows the model to understand order without recurrence.

---

# Transformer Layer Components

## Encoder Layer

Each encoder layer contains:

```

Input

↓

Multi-Head Attention

↓

Add & Normalize

↓

Feed Forward Network

↓

Add & Normalize

```

The original Transformer stacks **6 encoder layers**.

---

## Decoder Layer

Each decoder layer contains:

```

Masked Multi-Head Attention

↓

Encoder-Decoder Attention

↓

Feed Forward Network

↓

Output

```

Masked attention prevents the decoder from seeing future words during training.

Example:

Predicting:

```

I love ___

```

The model cannot see the correct next word.

---

## Feed Forward Network (FFN)

Each position independently passes through a small neural network.

```

Linear

↓

ReLU

↓

Linear

```

This increases the model's capacity beyond attention alone.

---

## Residual Connections

Every sub-layer uses residual (skip) connections.

```

Input

↓

Attention

↓

*

Input

↓

Normalize

```

Benefits:

* Easier optimization
* Better gradient flow
* Enables deeper models

---

## Layer Normalization

Layer normalization stabilizes activations during training.

It improves convergence and training stability.

---

# Training

The model was trained using:

* Adam optimizer
* Learning rate warmup followed by decay
* Dropout for regularization
* Label smoothing to improve generalization

---

# Why Is the Transformer Faster?

RNN:

```

Word 1

↓

Word 2

↓

Word 3

↓

Word 4

```

Sequential processing.

Transformer:

```

Word 1
Word 2
Word 3
Word 4

↓

All processed simultaneously

```

Advantages:

* Massive parallelism
* Better GPU utilization
* Much faster training

---

# Computational Complexity

Self-attention compares every token with every other token.

Complexity:

```

O(n²)

```

where *n* is the sequence length.

This works well for moderate sequence lengths but becomes expensive for very long documents, which motivated later research into more efficient attention mechanisms.

---

# Results

The Transformer achieved state-of-the-art performance on machine translation benchmarks, including English-to-German and English-to-French tasks.

It trained faster than previous recurrent models while achieving better translation quality.

---

# Impact on Modern AI

Nearly every modern large language model is based on the Transformer architecture, including:

* OpenAI GPT series
* Google BERT and T5
* Meta Llama
* Anthropic Claude
* Mistral AI Mistral

The same core idea has also been adapted for:

* Computer vision
* Speech recognition
* Multimodal AI
* Robotics
* Protein structure prediction

---

# Key Takeaways

* The paper replaced recurrence and convolutions with attention as the main mechanism for sequence modeling.
* Self-attention allows every token to directly interact with every other token.
* Multi-head attention enables the model to learn different types of relationships simultaneously.
* Positional encoding provides information about token order.
* Parallel processing makes training significantly faster than RNN-based models.
* The Transformer became the foundation of modern generative AI and large language models.
