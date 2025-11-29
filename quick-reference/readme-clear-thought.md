# Clear Thought MCP Quick Reference

**MCP:** `clear-thought`
**Command:** `/clear-thought <flag> <prompt>`
**Operations:** 38 reasoning tools via single unified interface

---

## Quick Start

```bash
/clear-thought --help              # Show all flags
/clear-thought --seq <prompt>      # Default: step-by-step reasoning
/clear-thought --debug <prompt>    # Structured debugging
/clear-thought --decide <prompt>   # Decision framework
```

---

## All Flags by Category

### Core Thinking
| Flag | Operation | Use When |
|------|-----------|----------|
| `--seq` | `sequential_thinking` | Step-by-step chain-of-thought |
| `--model` | `mental_model` | Apply First Principles, Pareto, Inversion, etc. |
| `--debug` | `debugging_approach` | Structured troubleshooting |
| `--creative` | `creative_thinking` | Brainstorming, idea generation |
| `--visual` | `visual_reasoning` | Diagrams, flowcharts |
| `--meta` | `metacognitive_monitoring` | Assess your reasoning process |
| `--science` | `scientific_method` | Hypothesis, experiment, conclusion |

### Collaborative & Decision
| Flag | Operation | Use When |
|------|-----------|----------|
| `--collab` | `collaborative_reasoning` | Multi-persona discussion |
| `--decide` | `decision_framework` | Weigh options systematically |
| `--socratic` | `socratic_method` | Question-driven refinement |
| `--argue` | `structured_argumentation` | Build/analyze formal arguments |

### Systems & Analysis
| Flag | Operation | Use When |
|------|-----------|----------|
| `--systems` | `systems_thinking` | Model interconnected components |
| `--analogy` | `analogical_reasoning` | Draw parallels between domains |
| `--causal` | `causal_analysis` | Investigate cause-and-effect |
| `--stats` | `statistical_reasoning` | Summary, Bayes, hypothesis, Monte Carlo |
| `--sim` | `simulation` | Run simple simulations |
| `--optimize` | `optimization` | Find best solution |
| `--ethics` | `ethical_analysis` | Evaluate ethical frameworks |
| `--research` | `research` | Generate research findings |

### Reasoning Patterns
| Flag | Operation | Use When |
|------|-----------|----------|
| `--tree` | `tree_of_thought` | Branching exploration |
| `--beam` | `beam_search` | Keep top-k paths |
| `--mcts` | `mcts` | Monte Carlo tree search |
| `--graph` | `graph_of_thought` | Non-linear reasoning network |

### Strategic / Metagame
| Flag | Operation | Use When |
|------|-----------|----------|
| `--ooda` | `ooda_loop` | Rapid Observe-Orient-Decide-Act |
| `--ulysses` | `ulysses_protocol` | High-stakes debugging (critical incidents) |

### Session Management
| Flag | Operation | Use When |
|------|-----------|----------|
| `--info` | `session_info` | Get current session state |
| `--export` | `session_export` | Save session for later |
| `--import` | `session_import` | Restore previous session |

---

## Examples

```bash
# Core reasoning
/clear-thought --seq How should I refactor the authentication system?
/clear-thought --model first_principles Why is our API slow?
/clear-thought --debug Find why the build is failing

# Decisions
/clear-thought --collab Microservices vs monolith?
/clear-thought --decide Postgres vs MongoDB vs DynamoDB

# Analysis
/clear-thought --causal Why did deploy times increase 3x?
/clear-thought --systems How does payment flow interact with auth?

# Patterns
/clear-thought --tree Different approaches to state management

# High-stakes
/clear-thought --ooda Production incident response
/clear-thought --ulysses critical Checkout broken, revenue impacted
```

---

## Mental Models (--model flag)

When using `--model`, specify the model name after the flag:

| Model | Description |
|-------|-------------|
| `first_principles` | Break down to fundamentals, rebuild |
| `pareto` | 80/20 analysis - find the vital few |
| `inversion` | Think backwards from failure |
| `occams_razor` | Simplest explanation wins |
| `second_order` | Consider downstream effects |
| `opportunity_cost` | What are you giving up? |

```bash
/clear-thought --model first_principles Why is onboarding slow?
/clear-thought --model inversion How could this feature fail?
```

---

## Statistical Modes (--stats flag)

```bash
/clear-thought --stats summary Analyze API response times
/clear-thought --stats bayes Update probability given new evidence
/clear-thought --stats hypothesis_test Is the new algorithm faster?
/clear-thought --stats monte_carlo Simulate 1000 scenarios
```

---

## Ulysses Protocol (--ulysses flag)

For critical incidents. Add stakes level:

```bash
/clear-thought --ulysses high Database connection issues
/clear-thought --ulysses critical Users cannot checkout, revenue blocked
```

Phases: Containment → Diagnosis → Resolution → Verification → Postmortem

---

## MCP Details

**Server:** `@waldzellai/clear-thought-onepointfive`
**Location:** `_explore/_MCPs/clearthought-onepointfive/`
**Transport:** stdio via `dist/cli/stdio-server.js`

The MCP exposes a single `clear_thought` tool. The `/clear-thought` command wraps it with memorable flags.

---

## When to Use What

| Situation | Flag |
|-----------|------|
| General problem-solving | `--seq` |
| Architecture decisions | `--collab` or `--decide` |
| Debugging | `--debug` |
| Root cause analysis | `--causal` |
| Exploring options | `--tree` |
| Production incident | `--ooda` or `--ulysses` |
| Challenge assumptions | `--socratic` |
| Complex system analysis | `--systems` |

---

_Version: OS 2.4.1_
