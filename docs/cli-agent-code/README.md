# A Practical Guide to CLI Agent Coding

I've spent considerable time working with various CLI coding agents, and I want to share a practical guide that goes beyond the basics. This isn't just about commands-it's about developing an effective workflow and mindset.

## Understanding the Core Paradigm Shift

CLI coding agents represent a fundamentally different way of programming. Instead of writing code line by line, you're conducting an orchestra of AI capabilities through natural language and strategic direction.

The key insight: **you're becoming a technical director rather than a manual implementer**. Your value shifts from syntax knowledge to system design, problem decomposition, and quality assurance.

## Setting Up Your Environment

### Installation Patterns

Most CLI agents follow similar installation patterns:

```bash
# Claude Code
npm install -g @anthropic-ai/claude-code

# Gemini CLI
pip install google-generativeai-cli

# Qwen Code
pip install qwen-code-cli

# Codex CLI (OpenAI)
pip install openai-codex-cli
```

### First-Run Authentication

```bash
# Most agents require authentication on first run
claude --login              # Opens browser for OAuth
gemini auth login           # API key or OAuth flow
codex login                 # OpenAI API key prompt
qwen-code login             # API key configuration
```

### Essential Configuration

Create a project-level configuration file to maintain consistency:

```yaml
# .agent-config.yaml
model_preferences:
  complex_refactoring: "claude-sonnet-4" # Strong reasoning
  rapid_prototyping: "gemini-2.5-pro"    # Fast iteration
  documentation: "qwen-coder"            # Cost-effective

context_settings:
  auto_include:
    - "README.md"
    - "package.json"
    - "tsconfig.json"
    - ".eslintrc*"
    - "jest.config.*"
  max_context_files: 20
  exclude_patterns:
    - "node_modules/**"
    - "*.min.js"
    - "dist/**"
    - ".next/**"
    - "coverage/**"
```

## The Grammar of Agent Coding: Special Syntax

This is the vocabulary you'll use constantly. Each agent has slight variations, but the concepts are universal.

### The `@` Role System

The `@` symbol references files, directories, or other resources. Think of it as "mentioning" something to the agent.

```bash
# File references - bring specific files into context
claude "Explain the authentication flow in @auth/login.ts"
gemini "Review @src/middleware/ for security issues"
codex "@package.json What dependencies can we update?"

# Directory references - recursive context injection
claude "Find all places where we call the deprecated API in @src/"
gemini "Analyze test coverage across @tests/unit/"

# Multi-file references
claude "Compare the error handling in @auth/login.ts and @auth/register.ts"
qwen "Find inconsistencies between @frontend/types.ts and @backend/schema.ts"

# Glob patterns (Claude Code, Gemini CLI)
claude "Refactor all React components in @src/components/*.tsx to use hooks"
gemini "@src/**/*.test.ts Update all test assertions to the new format"

# Symbol references (Codex, Claude Code)
claude "@UserService - trace all callers of this class"
codex "@handleAuth - show me the full call hierarchy"

# Git references
claude "Review the changes in @HEAD~3..HEAD"
gemini "What changed in @main since @feature/auth-branch?"
```

### The `/` Command System

Slash commands are built-in actions that shortcut common operations:

```bash
# Session management
/clear          # Reset conversation context (all agents)
/compact        # Compress conversation history, keep key decisions
/undo           # Revert last action (Claude Code, Gemini CLI)
/save session-name  # Save current session state
/load session-name  # Restore a saved session

# Codebase exploration
/init           # Initialize agent in current directory, scan codebase
/explain        # Explain selected code or current file
/review         # Code review of current changes or PR
/find "pattern" # Search codebase semantically (not just grep)

# Git integration
/commit         # Generate commit message from staged changes
/pr             # Create pull request with generated description
/diff           # Show and explain current uncommitted changes
/branch feature-name  # Create and switch to new branch

# Code operations
/fix            # Fix linter errors, type errors, or tests
/test           # Run tests and fix failures
/refactor       # Targeted refactoring with explanation
/optimize       # Performance optimization suggestions

# Documentation
/docs           # Generate documentation for current file/module
/readme         # Generate or update README.md
/changelog      # Generate changelog from commits

# Context management
/add-file path  # Explicitly add file to context
/remove-file    # Remove file from context
/context        # Show current context window usage
/memory         # Add persistent memory across sessions
```

### Common Workflow Modifiers

These are natural language flags that change agent behavior:

```bash
# Permission modifiers
"Review the auth system --read-only"           # No file modifications
"Fix the bug -n" or "--dry-run"                # Show what would change
"Refactor --auto-approve"                      # Skip confirmation prompts
"Update deps --interactive"                    # Confirm each change

# Execution style
"Explain the caching layer --verbose"          # Detailed explanations
"Optimize queries --concise"                   # Minimal output
"Add tests --incremental"                      # One file at a time
"Debug the issue --step-by-step"               # Guided debugging

# Context scope
"Find bugs --include-tests"                    # Also search test files
"Refactor --ignore-docs"                       # Skip documentation files
"Review security --deep"                       # Thorough analysis
"Check types --shallow"                        # Quick surface check
```

## The Strategic Workflow

### Phase 1: Initialization and Context Building

Before writing a single line, invest time in context. This is the most underappreciated aspect of agent coding.

```bash
# Start a session with project context
claude
> /init
> "Review the entire codebase structure. I need you to understand:
   1. The architectural patterns used (check @src/core/ and @src/modules/)
   2. Testing conventions (look at @tests/ and @jest.config.ts)
   3. Error handling approach (trace ErrorBoundary usage with @ErrorBoundary)
   4. Any performance-critical paths (find all @cache/ implementations)
   
   Don't make changes yet-just build understanding."
```

**Why this matters:** Agents work best when they understand the full picture. Rushing to implementation without context leads to inconsistent code and architectural violations.

### Phase 2: Specification Through Conversation

Instead of writing detailed specs upfront, develop them through dialogue:

```bash
claude "I need to add rate limiting to our API. Before implementing, let's discuss:
- Where should the rate limit logic live? Look at @src/middleware/ for patterns
- What storage backend makes sense given our Redis in @src/lib/redis.ts?
- How should we handle rate limit headers? Check @src/utils/headers.ts
- What's our testing strategy? See @tests/middleware/ for conventions

Don't write code yet-just explore the design space."
```

This conversational approach surfaces edge cases and architectural decisions that you might miss in a static specification.

### Phase 3: Incremental Implementation

Break work into small, verifiable chunks using targeted commands:

```bash
# Step 1: Interface first
claude "Create the TypeScript interface for the rate limiter in @src/types/rate-limiter.ts. 
Include JSDoc comments explaining each method. Follow patterns in @src/types/auth.ts"

# Step 2: Core logic with tests
claude "Implement the sliding window algorithm in @src/lib/rate-limiter.ts. 
Write tests first in @tests/unit/rate-limiter.test.ts, then the implementation.
Use the Redis client from @src/lib/redis.ts"

# Step 3: Integration
claude "Wire the rate limiter into the existing middleware chain in @src/middleware/.
Preserve all existing behavior. Use /diff to show changes before applying."

# Step 4: Documentation
/docs @src/lib/rate-limiter.ts
/commit
```

## Advanced Patterns I've Discovered

### The "Explain Your Reasoning" Pattern

When the agent makes questionable decisions, use this:

```bash
claude "Refactor @src/modules/auth/ but for each significant change:
1. Explain what you're changing and WHY
2. Why you chose that approach over alternatives (mention specific trade-offs)
3. What edge cases you're handling
4. What could go wrong with your approach

Show me the reasoning before writing the code. Use --dry-run first."
```

### Context Window Management

See [Context Managment](../llm-context-management/README.md)

Long sessions degrade performance. Use these checkpoint patterns:

```bash
# Save session state
/save feature-rate-limiting
/memory "We decided to use sliding window algorithm with Redis. 
Key constraint: Must handle 10k requests/second.
Current blocker: Need to coordinate with team on header format."

# In a new session
/load feature-rate-limiting
claude "Continue from where we left off. What was the last thing we implemented?"

# Manual context snapshot
claude "Summarize our current context and save to @CONTEXT.md:
- What we've built so far
- Key decisions made (especially the Redis vs Memcached choice)
- Current blockers
- Next steps planned"
```

### The "Agent as Junior Developer" Mental Model

This was a game-changer for me. Treat the agent like a brilliant but inexperienced junior developer who:

- Has encyclopedic knowledge but lacks judgment
- Can implement anything but might miss nuance
- Works incredibly fast but needs clear direction
- Requires code review like anyone else
- Benefits from `/explain` to verbalize its understanding

### Multi-File Orchestration

Coordinate changes across many files:

```bash
# Start with impact analysis
claude "I need to rename getCwd to getCurrentWorkingDirectory across the project.
First, use @getCwd to find all references. Show me every file that needs changing."

# Batch the changes
claude "Now update all 15 files. For each one:
- Show the before/after with /diff
- Group related files together
- Update tests last to confirm they still pass"

# Verify completeness
/find "getCwd"  # Should return nothing
```

### Testing Strategy

Agents write tests well but sometimes miss edge cases. Use this layered approach:

```bash
# Layer 1: Agent writes happy path tests
claude "Write comprehensive tests for @src/services/user-registration.ts
Follow patterns in @tests/services/ - use describe/it blocks, mock external calls"

# Layer 2: You identify edge cases  
claude "Add tests in the same file for these specific scenarios:
- Registration with Unicode characters in email (emoji domains)
- Race condition on duplicate username (use jest.useFakeTimers)
- Timeout during email verification (mock setTimeout)
- SQL injection attempts in username field"

# Layer 3: Agent finds its own edge cases
claude "Review @src/services/user-registration.ts and the tests.
Suggest edge cases I might have missed. Be creative with failure modes."

# Layer 4: Property-based testing
claude "Add property-based tests using fast-check for the validation functions.
Test invariants like: email normalization should be idempotent"
```

## Handling Common Challenges

### When the Agent Gets Stuck

```bash
# Reset approach entirely
/clear
claude "Forget your current approach. Let's solve this differently.
The problem is: [restate problem clearly]
Constraints: [list specific constraints]
Start fresh with a new architectural approach. Explain before implementing."

# Change the abstraction level
claude "You're overthinking this. Show me the simplest possible solution first.
We can optimize later. Target: get it working in under 20 lines."

# Switch to pair debugging
claude "Let's debug this together. Add console.log statements at key points.
I'll run the code and paste the output back to you."
```

### Maintaining Code Consistency

Create and reference style guides:

```bash
# Generate a style guide from existing code
claude "Analyze @src/components/ and generate a STYLE_GUIDE.md documenting:
- Component patterns (when to use hooks vs HOCs)
- Naming conventions (event handlers, state variables)
- File structure conventions
- Error handling patterns

Look at the 5 most recently modified components for examples."

# Enforce the guide
claude "Before writing any code, read @STYLE_GUIDE.md.
Key patterns we follow:
- Functional components over classes
- Explicit error handling (no try/catch swallowing)
- Descriptive variable names (no abbreviations)
- Comments explain 'why', not 'what'
Use /review to check your work against the guide."
```

### Performance-Critical Code

For optimization work, provide benchmarks:

```bash
claude "This query in @src/db/slow-query.ts currently takes 200ms with 10k records.
Target: under 50ms.
Steps:
1. Profile the query first (add timing instrumentation)
2. Check existing indexes (look at @src/db/migrations/)
3. Suggest specific optimizations
4. Measure the improvement

Don't just guess, show me the numbers. Use --incremental to try one change at a time."
```

### Merging and Conflict Resolution

```bash
# Pre-merge review
claude "Review the diff between @main and @feature/new-auth.
Highlight potential conflicts, breaking changes, and test coverage gaps."

# Conflict resolution
claude "Resolve the merge conflicts in @src/auth/login.ts.
Prefer the changes from @feature/new-auth but keep the security fixes from @main.
Show conflicts and your resolution reasoning with /diff."
```

## Tool Orchestration

Different agents have different strengths. Here's my typical workflow:

```bash
# Exploration and understanding (Gemini - fast, large context)
gemini "Map out all the authentication flows in @src/modules/. 
Show me a dependency graph of files involved."

# Implementation and refactoring (Claude - strong reasoning)
claude "Implement the new OAuth provider following patterns in @src/auth/providers/*.
Write tests, implementation, and update types."

# Quick fixes and documentation (Qwen - cost-effective)  
qwen "/docs @src/auth/ - generate comprehensive JSDoc"
qwen "/fix @src/ - resolve all TypeScript errors"

# Code review (switch agents for fresh perspective)
gemini "/review @feature/new-auth - look for security issues"
claude "/review @feature/new-auth - look for logic errors and edge cases"
```

## Session Management Best Practices

### Starting a Productive Session

```bash
# Always start with context restoration
claude
> "Good morning. Here's where we are:
   - Yesterday we implemented rate limiting (@src/lib/rate-limiter.ts)
   - Integration tests are passing (run /test to verify)
   - Today we need to add the admin dashboard
   Ready to continue?"
```

### Handling Interruptions

```bash
# Quick save before interruption
/memory "CURRENT STATE: Mid-refactoring of auth module. 
The UserService class is split but validation tests are failing.
When I return: fix the password validation in @tests/unit/user-validation.test.ts"
/save auth-refactor-partial
```

### Ending a Session

```bash
# Prepare for next session
/save feature-complete
/claude "Summarize today's accomplishments:
- What we built (with file paths)
- What's working (passing tests)
- What needs attention tomorrow
- Any decisions the morning team should know about
Save this to @DAILY_SUMMARY.md"
```

## Security Considerations

Always use permission boundaries:

```bash
# Start with read-only exploration
claude --read-only "Analyze the deployment configuration"

# Write with confirmation for each file
claude --permission=prompt "Update the CI/CD pipeline"

# Network access control
claude --allow-network=api.github.com,registry.npmjs.org "Check for dependency updates"

# Sensitive file handling
claude "Review security of @.env.example but never read @.env or @.env.local"
```

### Never Commit These Patterns

```bash
# DON'T DO THIS
claude "Fix the bug in @.env"  # Never share secrets
claude --auto-approve "Update production database schema"  # Dangerous
claude "Here's my API key: sk-xxxx..."  # NEVER include credentials in prompts
```

## Measuring Success

Track these metrics to improve your agent workflow:

- **Implementation accuracy**: How often does the first attempt work?
- **Iteration count**: How many back-and-forth exchanges per feature?
- **Context efficiency**: How much context before productive work begins?
- **Bug rate**: Are agent-written sections more or less buggy?
- **Session length**: Optimal duration before needing /compact or /clear

## Advanced: Custom Commands and Shortcuts

Most agents support aliases and custom commands:

```bash
# Claude Code custom commands (.claude/commands/)
/mystyle "Always use: functional components, TypeScript strict mode, 
and the error handling pattern from @src/utils/errors.ts"

# Gemini CLI shortcuts
/alias review-js "Review for: missing error handling, 
unoptimized React renders, and accessibility issues"

# Codex custom instructions (.codex/instructions.md)
"# Project instructions
Always prefer async/await over .then()
Use the database helper from @db/connection.ts
Never introduce new dependencies without discussion"
```

## The Meta-Skill: Knowing When Not to Use Agents

This might be the most important section. Agents aren't suitable when:

- You're learning a new concept and need to struggle with it
- The problem requires deep domain expertise the agent lacks
- The codebase is highly sensitive, regulated, or involves financial transactions
- You're doing novel architectural design that requires creative leaps
- The task is trivial (simple rename, formatting)
- You need to build intuition about the system's behavior

Use agents to amplify your capabilities, not replace your thinking.

## Quick Reference Card

```
SESSION CONTROL:
  /clear          Reset context
  /compact        Compress history
  /save name      Save session
  /load name      Restore session
  /undo           Revert last change

CODE OPERATIONS:
  /fix            Fix errors
  /test           Run and fix tests
  /refactor       Targeted refactoring
  /review         Code review
  /explain        Explain code
  /docs           Generate docs

GIT INTEGRATION:
  /commit         Generate commit
  /pr             Create pull request
  /diff           Show changes
  /branch name    Create branch

CONTEXT MANAGEMENT:
  @file.ts        Reference file
  @dir/           Reference directory
  @src/**/*.ts    Glob pattern
  @functionName   Symbol reference
  /add-file       Add to context
  /context        Show usage
  /memory         Set persistent memory

WORKFLOW MODIFIERS:
  --read-only     No modifications
  --dry-run       Show plan only
  --verbose       Detailed output
  --incremental   Step by step
  --auto-approve  Skip confirmations
```

## Final Thoughts

The developers who thrive with agent coding aren't necessarily the best programmers in the traditional sense. They're the ones who excel at:

1. **Clear communication**: Describing intent precisely
2. **Systems thinking**: Understanding how pieces fit together  
3. **Critical evaluation**: Quickly assessing generated code quality
4. **Iterative refinement**: Improving through multiple passes
5. **Context management**: Keeping the agent focused on what matters

This is still programming! it's just programming at a higher level of abstraction. The syntax changes, but the fundamental skills of problem decomposition, logical reasoning, and attention to detail remain essential.

Start small. Try `/explain` on unfamiliar code. Use `/review` before your own PRs. Graduate to `/refactor` on well-tested modules. Build your intuition gradually, and remember: the goal isn't to type less, it's to think better.
