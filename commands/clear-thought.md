# Clear Thought - Unified Reasoning

All 38 reasoning operations via Clear Thought MCP in one command.

## Usage
```
/clear-thought <flag> <prompt>
/clear-thought --help
```

---

## Instructions

**If user passes `--help` (or no arguments):** Display this reference and stop:

```
/clear-thought - Unified Reasoning Operations

CORE THINKING
  --seq         Sequential thinking, step-by-step chain-of-thought
  --model       Mental model (first_principles, pareto, inversion, occams_razor, second_order)
  --debug       Structured debugging approach (binary search, rubber duck, etc.)
  --creative    Brainstorming & idea generation
  --visual      Diagrams, flowcharts, visual reasoning
  --meta        Metacognitive monitoring - assess your own reasoning
  --science     Scientific method (hypothesis → experiment → conclusion)

COLLABORATIVE & DECISION
  --collab      Multi-persona discussion (PM, engineer, designer perspectives)
  --decide      Decision framework - weigh options systematically
  --socratic    Socratic method - question-driven refinement
  --argue       Structured argumentation - build/analyze formal arguments

SYSTEMS & ANALYSIS
  --systems     Model interconnected components and relationships
  --analogy     Draw parallels and map insights between domains
  --causal      Investigate cause-and-effect relationships
  --stats       Statistical reasoning (modes: summary, bayes, hypothesis_test, monte_carlo)
  --sim         Run simple simulations
  --optimize    Find best solution from alternatives
  --ethics      Evaluate using ethical frameworks
  --research    Generate research findings and citations

REASONING PATTERNS
  --tree        Tree of thought - branching exploration
  --beam        Beam search - keep top-k promising paths
  --mcts        Monte Carlo tree search
  --graph       Graph of thought - non-linear reasoning network

STRATEGIC / METAGAME
  --ooda        OODA loop - rapid Observe→Orient→Decide→Act cycles
  --ulysses     Ulysses protocol - high-stakes debugging (add: high or critical)

SESSION
  --info        Get current session info
  --export      Export session for persistence
  --import      Import previous session

EXAMPLES
  /clear-thought --seq How should I refactor the auth system?
  /clear-thought --model first_principles Why is our API slow?
  /clear-thought --debug Find why tests are failing
  /clear-thought --collab Microservices vs monolith architecture?
  /clear-thought --decide Postgres vs MongoDB vs DynamoDB
  /clear-thought --causal Why did deploy times increase 3x?
  /clear-thought --tree Different approaches to state management
  /clear-thought --ooda Production incident response
  /clear-thought --ulysses critical Checkout broken, revenue impacted
```

---

Parse the user's input to extract the flag and prompt.

**Flag mapping:**

Core:
- `--seq` or `--sequential` → operation: `sequential_thinking`
- `--model` → operation: `mental_model` (check for model name after flag)
- `--debug` → operation: `debugging_approach`
- `--creative` → operation: `creative_thinking`
- `--visual` → operation: `visual_reasoning`
- `--meta` → operation: `metacognitive_monitoring`
- `--science` → operation: `scientific_method`

Collaborative:
- `--collab` → operation: `collaborative_reasoning`
- `--decide` → operation: `decision_framework`
- `--socratic` → operation: `socratic_method`
- `--argue` → operation: `structured_argumentation`

Analysis:
- `--systems` → operation: `systems_thinking`
- `--analogy` → operation: `analogical_reasoning`
- `--causal` → operation: `causal_analysis`
- `--stats` → operation: `statistical_reasoning` (check for mode: summary, bayes, hypothesis_test, monte_carlo)
- `--sim` → operation: `simulation`
- `--optimize` → operation: `optimization`
- `--ethics` → operation: `ethical_analysis`
- `--research` → operation: `research`

Patterns:
- `--tree` → operation: `tree_of_thought`
- `--beam` → operation: `beam_search`
- `--mcts` → operation: `mcts`
- `--graph` → operation: `graph_of_thought`

Strategic:
- `--ooda` → operation: `ooda_loop`
- `--ulysses` → operation: `ulysses_protocol` (check for stakes: high, critical)

Session:
- `--info` → operation: `session_info`
- `--export` → operation: `session_export`
- `--import` → operation: `session_import`

**If no flag provided:** Default to `sequential_thinking`.

Call the MCP tool:
```
mcp__clear-thought__clear_thought
  operation: <mapped operation>
  prompt: <user's prompt>
  parameters: {
    model: "<if --model>",
    mode: "<if --stats>",
    stakes: "<if --ulysses>"
  }
```

Present the structured response clearly, preserving any sections, steps, or recommendations from the MCP output.
