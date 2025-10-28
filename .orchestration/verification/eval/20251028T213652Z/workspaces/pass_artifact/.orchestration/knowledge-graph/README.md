# Agentic Knowledge Graph - Pattern-Agent-Outcome Correlations

**Purpose:** Graph database connecting patterns, agents, and outcomes with weighted correlation edges

**Version:** 1.0.0 (Stage 6)

---

## Overview

The Agentic Knowledge Graph is a **directed weighted graph** that captures correlations between:
- User request patterns (nodes)
- Specialist agents (nodes)
- Orchestration strategies (nodes)
- Task outcomes (nodes)
- Temporal patterns (nodes)

**Edges** represent correlations with weights derived from telemetry:
- Strong correlation: weight > 0.8
- Moderate correlation: weight 0.5 - 0.8
- Weak correlation: weight < 0.5

**Philosophical Position:** Emergent intelligence from correlation mining. The graph reveals non-obvious relationships that humans miss.

---

## Why a Knowledge Graph?

### Problem: Isolated Data Points

**Current telemetry (flat log):**

```json
{"request": "Build login screen", "agent": "swiftui-developer", "outcome": "PASSED"}
{"request": "Add dark mode", "agent": "swiftui-developer", "outcome": "FAILED"}
{"request": "Build login screen", "agent": "ui-engineer", "outcome": "PASSED"}
```

**Questions we CAN'T answer:**
- ❌ Does "swiftui-developer" fail more with "dark mode" requests?
- ❌ Do "authentication" patterns correlate with specific failure modes?
- ❌ Do certain agent combinations yield better outcomes?
- ❌ What patterns predict "user frustration" signals?

### Solution: Graph Relationships

**Knowledge graph representation:**

```
[Pattern: login_screen]
    │
    ├─(0.95)→ [Agent: swiftui-developer] ─(0.88)→ [Outcome: PASSED]
    │
    └─(0.82)→ [Agent: ui-engineer] ─(0.92)→ [Outcome: PASSED]

[Pattern: dark_mode]
    │
    ├─(0.45)→ [Agent: swiftui-developer] ─(0.40)→ [Outcome: FAILED]
    │
    └─(0.91)→ [Agent: design-system-architect] ─(0.95)→ [Outcome: PASSED]
```

**Insights revealed:**
- ✅ swiftui-developer: HIGH success for "login_screen" (0.88), LOW for "dark_mode" (0.40)
- ✅ design-system-architect: BEST for "dark_mode" (0.95)
- ✅ Pattern-specific specialist selection improves outcomes

---

## Graph Schema

### Node Types

**1. Pattern Nodes**
```json
{
  "type": "pattern",
  "id": "pattern:login_screen",
  "keywords": ["login", "authentication", "email", "password"],
  "embedding": [0.823, -0.412, ...],
  "occurrence_count": 47,
  "created_at": "2025-10-20T14:00:00Z"
}
```

**2. Agent Nodes**
```json
{
  "type": "agent",
  "id": "agent:swiftui-developer",
  "category": "ios-specialists",
  "certification": "CERTIFIED",
  "success_rate": 0.85,
  "total_tasks": 120
}
```

**3. Strategy Nodes**
```json
{
  "type": "strategy",
  "id": "strategy:deep_path",
  "description": "Comprehensive context loading",
  "avg_tokens": 75000,
  "avg_latency": 650
}
```

**4. Outcome Nodes**
```json
{
  "type": "outcome",
  "id": "outcome:PASSED",
  "description": "Task verified successfully"
}
```

**5. Signal Nodes**
```json
{
  "type": "signal",
  "id": "signal:user_frustration",
  "keywords": ["just read", "entire session", "didn't even"],
  "severity": "high"
}
```

### Edge Types

**1. Pattern → Agent (Correlation)**
```json
{
  "source": "pattern:login_screen",
  "target": "agent:swiftui-developer",
  "type": "correlated_with",
  "weight": 0.88,
  "success_count": 42,
  "failure_count": 5,
  "confidence": 0.95
}
```

**2. Agent → Outcome (Performance)**
```json
{
  "source": "agent:swiftui-developer",
  "target": "outcome:PASSED",
  "type": "results_in",
  "weight": 0.85,
  "task_count": 120,
  "context": "overall"
}
```

**3. Signal → Strategy (Trigger)**
```json
{
  "source": "signal:user_frustration",
  "target": "strategy:deep_path",
  "type": "triggers",
  "weight": 0.99,
  "trigger_count": 23,
  "success_rate_after": 1.0
}
```

**4. Pattern → Strategy (Recommendation)**
```json
{
  "source": "pattern:architecture_question",
  "target": "strategy:deep_path",
  "type": "recommends",
  "weight": 0.98,
  "evidence_count": 35
}
```

---

## Graph Construction

### Building from Telemetry

**Script:** `.orchestration/knowledge-graph/build-graph.py`

```python
import json
import networkx as nx

# Load telemetry
with open('.orchestration/meta-learning/telemetry.jsonl') as f:
    telemetry = [json.loads(line) for line in f]

# Initialize graph
G = nx.DiGraph()

# Add nodes and edges from telemetry
for entry in telemetry:
    # Extract pattern
    pattern_id = f"pattern:{entry['pattern_matched']}"
    if not G.has_node(pattern_id):
        G.add_node(pattern_id, type='pattern', **entry['pattern_metadata'])

    # Extract agents
    for agent in entry['agents_used']:
        agent_id = f"agent:{agent}"
        if not G.has_node(agent_id):
            G.add_node(agent_id, type='agent')

        # Add Pattern → Agent edge
        if G.has_edge(pattern_id, agent_id):
            # Update weight based on outcome
            edge_data = G[pattern_id][agent_id]
            if entry['outcome'] == 'PASSED':
                edge_data['success_count'] += 1
            else:
                edge_data['failure_count'] += 1

            # Recalculate weight
            total = edge_data['success_count'] + edge_data['failure_count']
            edge_data['weight'] = edge_data['success_count'] / total
        else:
            # Create new edge
            G.add_edge(
                pattern_id,
                agent_id,
                type='correlated_with',
                weight=1.0 if entry['outcome'] == 'PASSED' else 0.0,
                success_count=1 if entry['outcome'] == 'PASSED' else 0,
                failure_count=0 if entry['outcome'] == 'PASSED' else 1
            )

        # Add Agent → Outcome edge
        outcome_id = f"outcome:{entry['outcome']}"
        if not G.has_node(outcome_id):
            G.add_node(outcome_id, type='outcome')

        if G.has_edge(agent_id, outcome_id):
            G[agent_id][outcome_id]['count'] += 1
        else:
            G.add_edge(agent_id, outcome_id, type='results_in', count=1)

# Save graph
nx.write_gpickle(G, '.orchestration/knowledge-graph/graph.gpickle')
```

### Correlation Calculation

**Weight formula:**

```
weight = success_count / (success_count + failure_count)

Confidence = 1 - (1 / sqrt(total_count))
  - Low sample (n=5): confidence = 0.55
  - Medium sample (n=25): confidence = 0.80
  - High sample (n=100): confidence = 0.90
```

---

## Query Patterns

### 1. Best Agent for Pattern

**Query:** "Which agent is best for 'login screen' pattern?"

```python
import networkx as nx

G = nx.read_gpickle('.orchestration/knowledge-graph/graph.gpickle')

pattern_id = 'pattern:login_screen'

# Get all agents connected to this pattern
agents = []
for source, target, data in G.edges(pattern_id, data=True):
    if G.nodes[target]['type'] == 'agent':
        agents.append({
            'agent': target,
            'weight': data['weight'],
            'success_count': data['success_count'],
            'confidence': data.get('confidence', 0)
        })

# Sort by weight * confidence
agents.sort(key=lambda x: x['weight'] * x['confidence'], reverse=True)

# Best agent
best = agents[0]
print(f"Best agent: {best['agent']}")
print(f"Success rate: {best['weight']:.2%}")
print(f"Confidence: {best['confidence']:.2f}")
```

**Output:**
```
Best agent: agent:swiftui-developer
Success rate: 88%
Confidence: 0.95
```

---

### 2. Failure Pattern Detection

**Query:** "What patterns predict 'user frustration' signal?"

```python
# Find all paths: pattern → ... → signal:user_frustration

frustration_predictors = []

for pattern in [n for n, d in G.nodes(data=True) if d['type'] == 'pattern']:
    if nx.has_path(G, pattern, 'signal:user_frustration'):
        paths = list(nx.all_simple_paths(G, pattern, 'signal:user_frustration', cutoff=3))

        for path in paths:
            # Calculate path weight (product of edge weights)
            path_weight = 1.0
            for i in range(len(path) - 1):
                edge_data = G[path[i]][path[i+1]]
                path_weight *= edge_data.get('weight', 0.5)

            if path_weight > 0.6:  # Strong correlation
                frustration_predictors.append({
                    'pattern': pattern,
                    'path': ' → '.join(path),
                    'correlation': path_weight
                })

# Sort by correlation
frustration_predictors.sort(key=lambda x: x['correlation'], reverse=True)

for pred in frustration_predictors[:5]:
    print(f"{pred['pattern']}: {pred['correlation']:.2%}")
    print(f"  Path: {pred['path']}\n")
```

**Output:**
```
pattern:architecture_question: 92%
  Path: pattern:architecture_question → strategy:fast_path → outcome:FAILED → signal:user_frustration

pattern:system_understanding: 87%
  Path: pattern:system_understanding → agent:system-architect → outcome:INCOMPLETE → signal:user_frustration
```

**Insight:** Architecture questions + fast-path → user frustration with 92% correlation

**Action:** meta-orchestrator should ALWAYS use deep-path for architecture questions

---

### 3. Agent Team Composition

**Query:** "What agent combinations work best for 'dark mode' pattern?"

```python
# Find agent co-occurrence in successful tasks

pattern_id = 'pattern:dark_mode'

# Get all tasks with this pattern
tasks_with_pattern = [t for t in telemetry if t['pattern_matched'] == 'dark_mode']

# Separate by outcome
successful_tasks = [t for t in tasks_with_pattern if t['outcome'] == 'PASSED']
failed_tasks = [t for t in tasks_with_pattern if t['outcome'] == 'BLOCKED']

# Count agent combinations in successful tasks
from collections import Counter

successful_teams = Counter()
for task in successful_tasks:
    team = tuple(sorted(task['agents_used']))
    successful_teams[team] += 1

# Best team
best_team = successful_teams.most_common(1)[0]
print(f"Best team: {best_team[0]}")
print(f"Successes: {best_team[1]}")
```

**Output:**
```
Best team: ('design-system-architect', 'state-management-specialist', 'visual-designer')
Successes: 12
```

**Insight:** Dark mode requires design system + state + visual design specialists

---

### 4. Temporal Patterns

**Query:** "Do certain patterns fail more on Fridays?"

```python
import datetime

# Add temporal nodes
for entry in telemetry:
    timestamp = datetime.datetime.fromisoformat(entry['timestamp'])
    day_of_week = timestamp.strftime('%A')

    day_node = f"temporal:day_{day_of_week}"
    if not G.has_node(day_node):
        G.add_node(day_node, type='temporal', day=day_of_week)

    pattern_id = f"pattern:{entry['pattern_matched']}"

    # Add edge: temporal → pattern → outcome
    if not G.has_edge(day_node, pattern_id):
        G.add_edge(day_node, pattern_id, type='occurs_on', count=1)
    else:
        G[day_node][pattern_id]['count'] += 1

# Query: Friday failure rate
friday_tasks = [t for t in telemetry if datetime.datetime.fromisoformat(t['timestamp']).strftime('%A') == 'Friday']
friday_failure_rate = sum(1 for t in friday_tasks if t['outcome'] == 'BLOCKED') / len(friday_tasks)

print(f"Friday failure rate: {friday_failure_rate:.2%}")
```

**Potential insights:**
- Friday deployments have higher failure rate (rushing before weekend)
- Monday tasks have lower failure rate (fresh start)

---

## Graph Visualizations

### Cytoscape.js Integration

**Generate interactive graph:**

```python
import json

def export_cytoscape_json(G):
    elements = []

    # Add nodes
    for node, data in G.nodes(data=True):
        elements.append({
            'data': {
                'id': node,
                'label': node.split(':')[1] if ':' in node else node,
                'type': data.get('type', 'unknown')
            }
        })

    # Add edges
    for source, target, data in G.edges(data=True):
        elements.append({
            'data': {
                'source': source,
                'target': target,
                'weight': data.get('weight', 0.5),
                'type': data.get('type', 'unknown')
            }
        })

    with open('.orchestration/knowledge-graph/graph.json', 'w') as f:
        json.dump({'elements': elements}, f, indent=2)

export_cytoscape_json(G)
```

**View in browser:** `.orchestration/knowledge-graph/visualize.html`

---

## Use Cases

### Use Case 1: Specialist Selection Optimization

**Scenario:** User requests "Build login screen"

**Traditional /orca:**
- Matches "login" keyword → ios-pattern-001
- Dispatches swiftui-developer (default iOS specialist)

**With Knowledge Graph:**
1. Query graph for "login_screen" pattern
2. Find agents with highest correlation weight
3. Results:
   - swiftui-developer: weight=0.88 (good)
   - ui-engineer: weight=0.92 (better!)
4. Dispatch ui-engineer instead

**Outcome:** 4pp higher success rate by choosing better-correlated specialist

---

### Use Case 2: Early Warning System

**Scenario:** Pattern + strategy combination predicts failure

**Detection:**
```python
# Real-time detection during Phase 0
current_pattern = "architecture_question"
current_strategy = "fast_path"

# Query graph for this combination
path_weight = calculate_path_weight(
    f"pattern:{current_pattern}",
    f"strategy:{current_strategy}",
    "outcome:FAILED"
)

if path_weight > 0.80:  # High failure correlation
    print("⚠️  WARNING: This combination has 80% failure rate")
    print("Recommendation: Switch to deep_path strategy")
```

**Prevention:** Switch strategy BEFORE failure occurs

---

### Use Case 3: Root Cause Analysis

**Scenario:** Why did this task fail?

**Graph traversal:**
```python
task_id = "failed-task-123"
task = get_task_from_telemetry(task_id)

# Traverse graph backwards from outcome:FAILED
failure_node = "outcome:FAILED"

# Find all paths from pattern to failure
for pattern in task['patterns']:
    paths = nx.all_simple_paths(G, f"pattern:{pattern}", failure_node, cutoff=4)

    for path in paths:
        # Calculate correlation strength
        correlation = calculate_path_correlation(path)

        if correlation > 0.75:  # Strong causal chain
            print(f"Root cause path (correlation: {correlation:.2%}):")
            print(" → ".join(path))
```

**Output:**
```
Root cause path (correlation: 92%):
pattern:architecture_question → strategy:fast_path → agent:system-architect → outcome:INCOMPLETE → outcome:FAILED

Explanation: Architecture questions + fast-path → incomplete context → failure
Recommendation: Use deep-path for architecture questions
```

---

## Integration with Meta-Orchestrator

**meta-orchestrator queries knowledge graph for strategy selection:**

```python
# In meta-orchestrator decision logic
def select_strategy(user_request):
    # Extract pattern
    pattern = extract_pattern(user_request)

    # Query knowledge graph
    strategy_correlations = query_graph(
        f"pattern:{pattern}",
        target_type='strategy',
        metric='success_rate'
    )

    # Select strategy with highest correlation to success
    best_strategy = max(strategy_correlations, key=lambda x: x['weight'])

    return best_strategy
```

**Knowledge graph provides data-driven strategy selection**

---

## Graph Maintenance

### Weekly Updates

**Script:** `.orchestration/knowledge-graph/update-graph.sh`

```bash
#!/bin/bash
# Rebuild graph from latest telemetry

# Backup current graph
cp .orchestration/knowledge-graph/graph.gpickle \
   .orchestration/knowledge-graph/graph.gpickle.backup

# Rebuild from telemetry
python3 .orchestration/knowledge-graph/build-graph.py

# Prune low-confidence edges
python3 .orchestration/knowledge-graph/prune-graph.py \
  --min-confidence 0.3 \
  --min-sample-size 3

# Generate visualizations
python3 .orchestration/knowledge-graph/export-cytoscape.py

echo "✅ Knowledge graph updated"
```

### Edge Pruning

**Remove low-confidence edges:**

```python
# Remove edges with confidence < 0.3 or sample size < 3
edges_to_remove = []

for source, target, data in G.edges(data=True):
    confidence = data.get('confidence', 0)
    sample_size = data.get('success_count', 0) + data.get('failure_count', 0)

    if confidence < 0.3 or sample_size < 3:
        edges_to_remove.append((source, target))

for edge in edges_to_remove:
    G.remove_edge(*edge)

print(f"Pruned {len(edges_to_remove)} low-confidence edges")
```

---

## Metrics

### Graph Statistics

```python
import networkx as nx

G = nx.read_gpickle('.orchestration/knowledge-graph/graph.gpickle')

print(f"Nodes: {G.number_of_nodes()}")
print(f"Edges: {G.number_of_edges()}")
print(f"Avg degree: {sum(dict(G.degree()).values()) / G.number_of_nodes():.2f}")
print(f"Connected components: {nx.number_weakly_connected_components(G)}")
print(f"Avg path length: {nx.average_shortest_path_length(G.to_undirected()):.2f}")
```

**Example output:**
```
Nodes: 247
Edges: 1,853
Avg degree: 15.01
Connected components: 3
Avg path length: 3.2
```

---

## Directory Structure

```
.orchestration/knowledge-graph/
├── README.md (this file)
├── build-graph.py (construct graph from telemetry)
├── query-graph.py (query utilities)
├── update-graph.sh (weekly rebuild)
├── prune-graph.py (remove low-confidence edges)
├── export-cytoscape.py (generate visualization)
├── graph.gpickle (serialized NetworkX graph)
├── graph.json (Cytoscape.js format)
└── visualize.html (interactive graph viewer)
```

---

## Related Documentation

- **Meta-Orchestrator** (agents/specialized/meta-orchestrator.md) - Primary consumer of graph insights
- **Telemetry System** (.orchestration/meta-learning/telemetry.jsonl) - Data source for graph
- **ACE Playbooks** (.orchestration/playbooks/README.md) - Pattern definitions

---

**Last Updated:** 2025-10-25 (Stage 6 Implementation)
**Next Update:** Stage 7 (Causal inference, counterfactual analysis, graph neural networks)
