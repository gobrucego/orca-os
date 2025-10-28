# Multi-Objective Optimizer - Speed/Cost/Quality Trade-offs

**Purpose:** Balance competing objectives (speed, cost, quality) using reward model optimization

**Version:** 1.0.0 (Stage 6)

---

## Overview

The Multi-Objective Optimizer solves the **impossible trinity** of software development:
1. **Fast** (low latency)
2. **Cheap** (low token cost)
3. **High Quality** (low false completion rate)

**Traditional assumption:** "Pick any two"

**Multi-Objective Optimizer:** Find optimal Pareto frontier where trade-offs are mathematically justified

---

## The Impossible Trinity

### Objective 1: Speed (Minimize Latency)

**Measurement:** Total seconds from request to completion

**Factors:**
- Context loading time (reading files)
- Specialist execution time
- Verification time

**Fast-path:** ~2-3 minutes (minimal context)
**Medium-path:** ~5-8 minutes (targeted context)
**Deep-path:** ~10-15 minutes (comprehensive context)

---

### Objective 2: Cost (Minimize Tokens)

**Measurement:** Total input + output tokens

**Factors:**
- Context size (files read)
- Specialist prompt size
- Verification script generation

**Fast-path:** ~5K-10K tokens ($0.01-$0.02)
**Medium-path:** ~15K-30K tokens ($0.03-$0.05)
**Deep-path:** ~50K-100K tokens ($0.10-$0.20)

---

### Objective 3: Quality (Maximize Success Rate)

**Measurement:** 1 - false_completion_rate

**Factors:**
- Context completeness
- Specialist selection accuracy
- Verification thoroughness

**Fast-path:** ~50-60% success rate (high false completions)
**Medium-path:** ~75-85% success rate
**Deep-path:** ~95-99% success rate (minimal false completions)

---

## The Trade-Off Space

### Traditional Approach (No Optimization)

```
Strategy    | Latency | Cost   | Quality | Total Value
------------|---------|--------|---------|------------
fast-path   | 3 min   | $0.01  | 55%     | Poor (low quality)
medium-path | 6 min   | $0.04  | 80%     | Okay
deep-path   | 12 min  | $0.15  | 98%     | Good (slow, expensive)
```

**Problem:** No consideration of user preferences or task importance

---

## Reward Model

### Utility Function

**Weighted combination of objectives:**

```
U(strategy) = w_speed * speed_score(strategy)
            + w_cost * cost_score(strategy)
            + w_quality * quality_score(strategy)

Where:
  - speed_score = 1 - (latency / max_latency)
  - cost_score = 1 - (cost / max_cost)
  - quality_score = success_rate
  - w_speed + w_cost + w_quality = 1.0
```

### Weight Configurations

**Profile 1: Quality-First (Default)**
```python
weights = {
    'speed': 0.1,
    'cost': 0.1,
    'quality': 0.8
}
```

**Rationale:** False completions waste more time than deep-path costs

**Example calculation:**
```
deep-path:
  speed_score = 1 - (12 / 15) = 0.20
  cost_score = 1 - (0.15 / 0.20) = 0.25
  quality_score = 0.98

  U = 0.1 * 0.20 + 0.1 * 0.25 + 0.8 * 0.98
    = 0.02 + 0.025 + 0.784
    = 0.829

fast-path:
  speed_score = 1 - (3 / 15) = 0.80
  cost_score = 1 - (0.01 / 0.20) = 0.95
  quality_score = 0.55

  U = 0.1 * 0.80 + 0.1 * 0.95 + 0.8 * 0.55
    = 0.08 + 0.095 + 0.44
    = 0.615

Winner: deep-path (0.829 > 0.615)
```

---

**Profile 2: Speed-First**
```python
weights = {
    'speed': 0.7,
    'cost': 0.1,
    'quality': 0.2
}
```

**Use case:** Prototyping, exploration, non-critical tasks

---

**Profile 3: Cost-First**
```python
weights = {
    'speed': 0.1,
    'cost': 0.8,
    'quality': 0.1
}
```

**Use case:** Budget constraints, high-volume low-stakes tasks

---

**Profile 4: Balanced**
```python
weights = {
    'speed': 0.33,
    'cost': 0.33,
    'quality': 0.34
}
```

**Use case:** General purpose

---

## Dynamic Weight Adjustment

### Context-Sensitive Weighting

**Adjust weights based on task context:**

```python
def adjust_weights(task_context):
    # Default: Quality-first
    weights = {'speed': 0.1, 'cost': 0.1, 'quality': 0.8}

    # Production deployment → Quality even higher
    if task_context['deployment_target'] == 'production':
        weights = {'speed': 0.05, 'cost': 0.05, 'quality': 0.9}

    # Exploration/prototyping → Speed higher
    elif 'prototype' in task_context['keywords']:
        weights = {'speed': 0.6, 'cost': 0.2, 'quality': 0.2}

    # User frustrated → Quality MAX (prevent repeated failures)
    elif task_context['user_frustration']:
        weights = {'speed': 0.0, 'cost': 0.0, 'quality': 1.0}

    # Budget constrained → Cost higher
    elif task_context['monthly_tokens'] > budget_limit:
        weights = {'speed': 0.1, 'cost': 0.7, 'quality': 0.2}

    return weights
```

---

### User Preference Learning

**Learn user's implicit preferences from feedback:**

```python
# Track user satisfaction by strategy
strategy_feedback = {
    'fast-path': {'positive': 5, 'negative': 15},  # 25% satisfaction
    'medium-path': {'positive': 20, 'negative': 10},  # 67% satisfaction
    'deep-path': {'positive': 45, 'negative': 5}  # 90% satisfaction
}

# Infer user prefers quality over speed
# Adjust weights accordingly
inferred_weights = {
    'speed': 0.05,
    'cost': 0.05,
    'quality': 0.9
}
```

---

## Pareto Frontier Analysis

### Finding Non-Dominated Solutions

**Pareto optimal:** No other strategy improves one objective without worsening another

**Example data:**

```python
strategies = [
    {'name': 'fast', 'latency': 3, 'cost': 0.01, 'quality': 0.55},
    {'name': 'medium', 'latency': 6, 'cost': 0.04, 'quality': 0.80},
    {'name': 'deep', 'latency': 12, 'cost': 0.15, 'quality': 0.98},
    {'name': 'hybrid', 'latency': 8, 'cost': 0.08, 'quality': 0.92}
]
```

**Pareto frontier:**
```
medium (6 min, $0.04, 80%) → Pareto optimal (balanced)
hybrid (8 min, $0.08, 92%) → Pareto optimal (quality bias)
deep (12 min, $0.15, 98%) → Pareto optimal (max quality)

fast (3 min, $0.01, 55%) → NOT Pareto optimal (dominated by medium)
  - medium has same speed cost but 25pp better quality
```

**Visualization:**

```
Quality
  100% │                    ● deep
       │              ● hybrid
       │        ● medium
       │  ● fast (dominated)
    50% │
        └─────────────────────────→ Cost
         $0    $0.05   $0.10  $0.15
```

---

## Adaptive Strategy Selection

### Algorithm

```python
def select_optimal_strategy(request, telemetry, weights):
    # Step 1: Extract request features
    features = extract_features(request)

    # Step 2: Query knowledge graph for historical performance
    historical_perf = query_knowledge_graph(features)

    # Step 3: Estimate performance for each strategy
    strategies = []
    for strategy in ['fast', 'medium', 'deep', 'hybrid']:
        predicted_latency = predict_latency(strategy, features, historical_perf)
        predicted_cost = predict_cost(strategy, features)
        predicted_quality = predict_quality(strategy, features, historical_perf)

        strategies.append({
            'name': strategy,
            'latency': predicted_latency,
            'cost': predicted_cost,
            'quality': predicted_quality
        })

    # Step 4: Filter to Pareto frontier
    pareto_optimal = get_pareto_frontier(strategies)

    # Step 5: Calculate utility for each Pareto-optimal strategy
    utilities = []
    for strategy in pareto_optimal:
        speed_score = 1 - (strategy['latency'] / max(s['latency'] for s in strategies))
        cost_score = 1 - (strategy['cost'] / max(s['cost'] for s in strategies))
        quality_score = strategy['quality']

        utility = (
            weights['speed'] * speed_score +
            weights['cost'] * cost_score +
            weights['quality'] * quality_score
        )

        utilities.append({
            'strategy': strategy['name'],
            'utility': utility
        })

    # Step 6: Select strategy with highest utility
    best = max(utilities, key=lambda x: x['utility'])

    return best['strategy'], best['utility']
```

---

## Performance Prediction Models

### Latency Prediction

**Features:**
- Request complexity (word count, ambiguity)
- Context size required
- Number of specialists needed
- Historical latency for similar requests

**Model:** Random Forest Regressor

```python
from sklearn.ensemble import RandomForestRegressor

# Train on historical data
X_train = [
    [50, 5000, 2, 180],  # word_count, context_tokens, specialist_count, historical_latency
    [120, 75000, 5, 720],
    # ...
]
y_train = [180, 720, ...]  # actual latency in seconds

model = RandomForestRegressor(n_estimators=100)
model.fit(X_train, y_train)

# Predict for new request
predicted_latency = model.predict([[80, 30000, 3, 420]])  # ~450 seconds
```

---

### Cost Prediction

**Formula:**

```
cost = (context_tokens * input_price) + (output_tokens * output_price)

Where:
  - input_price = $0.003 / 1K tokens
  - output_price = $0.015 / 1K tokens
```

**Context size estimation:**

```python
def estimate_context_size(strategy, request_features):
    if strategy == 'fast':
        return request_features['file_count'] * 500  # 500 tokens per file avg

    elif strategy == 'medium':
        return request_features['component_size'] * 1000  # 1K per component

    elif strategy == 'deep':
        # All .orchestration/ READMEs + docs
        return 100000  # 100K tokens for full context

    elif strategy == 'hybrid':
        return 50000  # 50K tokens
```

---

### Quality Prediction

**Method:** Historical success rate + knowledge graph correlations

```python
def predict_quality(strategy, request_features, historical_perf):
    # Base success rate for strategy
    base_rate = {
        'fast': 0.55,
        'medium': 0.80,
        'deep': 0.98,
        'hybrid': 0.92
    }[strategy]

    # Adjust based on request features
    if request_features['ambiguity'] > 0.7:
        # High ambiguity → deep-path benefits more
        if strategy == 'deep':
            base_rate *= 1.05  # 5% boost
        elif strategy == 'fast':
            base_rate *= 0.80  # 20% penalty

    # Adjust based on historical performance
    similar_requests = historical_perf['similar_requests']
    if similar_requests:
        historical_rate = sum(r['success'] for r in similar_requests) / len(similar_requests)
        # Weighted average (70% base, 30% historical)
        predicted_rate = 0.7 * base_rate + 0.3 * historical_rate
    else:
        predicted_rate = base_rate

    return min(predicted_rate, 1.0)  # Cap at 100%
```

---

## Hybrid Strategies

### Custom Trade-off Points

**Hybrid-1: Fast Context + Deep Verification**
```
Context loading: Fast-path (5K tokens)
Specialist execution: Standard
Verification: Deep (behavioral oracles + screenshot diff)

Cost: $0.03 (medium)
Latency: 5 min (fast-medium)
Quality: 85% (medium-high)
```

**Hybrid-2: Deep Context + Fast Execution**
```
Context loading: Deep-path (100K tokens)
Specialist execution: Fast (minimal verification)
Verification: Minimal

Cost: $0.12 (high)
Latency: 8 min (medium)
Quality: 92% (high)
```

**Hybrid-3: Adaptive Context Loading**
```
Start: Fast-path (5K tokens)
If ambiguity detected: Expand to medium (30K tokens)
If still unclear: Expand to deep (100K tokens)

Cost: Variable ($0.01-$0.15)
Latency: Variable (3-12 min)
Quality: Variable (70-98%)
```

---

## Example Optimizations

### Scenario 1: Production Deployment

**Request:** "Deploy authentication system to production"

**Context:**
```python
{
    'deployment_target': 'production',
    'user_frustration': False,
    'monthly_tokens': 250000,  # Under budget
    'task_importance': 'critical'
}
```

**Weights (adjusted):**
```python
weights = {'speed': 0.0, 'cost': 0.1, 'quality': 0.9}
# Quality is paramount for production
```

**Utilities:**
```
fast-path:   U = 0.0 * 0.80 + 0.1 * 0.95 + 0.9 * 0.55 = 0.590
medium-path: U = 0.0 * 0.60 + 0.1 * 0.80 + 0.9 * 0.80 = 0.800
deep-path:   U = 0.0 * 0.20 + 0.1 * 0.25 + 0.9 * 0.98 = 0.907
```

**Selected:** deep-path (U=0.907)

**Outcome:** $0.15 cost, 12 min latency, 98% quality → Worth it for production

---

### Scenario 2: Prototyping

**Request:** "Quick prototype of dashboard layout"

**Context:**
```python
{
    'deployment_target': 'development',
    'keywords': ['prototype', 'quick'],
    'task_importance': 'low'
}
```

**Weights (adjusted):**
```python
weights = {'speed': 0.7, 'cost': 0.2, 'quality': 0.1}
# Speed prioritized for prototyping
```

**Utilities:**
```
fast-path:   U = 0.7 * 0.80 + 0.2 * 0.95 + 0.1 * 0.55 = 0.805
medium-path: U = 0.7 * 0.60 + 0.2 * 0.80 + 0.1 * 0.80 = 0.660
deep-path:   U = 0.7 * 0.20 + 0.2 * 0.25 + 0.1 * 0.98 = 0.288
```

**Selected:** fast-path (U=0.805)

**Outcome:** $0.01 cost, 3 min latency, 55% quality → Acceptable for prototype

---

### Scenario 3: User Frustrated

**Request:** "can you instead just read the entire session"

**Context:**
```python
{
    'user_frustration': True,  # Detected from language
    'previous_attempts': 2,
    'previous_outcomes': ['FAILED', 'FAILED']
}
```

**Weights (hard override):**
```python
weights = {'speed': 0.0, 'cost': 0.0, 'quality': 1.0}
# Only quality matters - prevent third failure
```

**Selected:** deep-path (FORCED)

**Outcome:** Whatever it costs, prevent another failure

---

## Telemetry Integration

### Logging Decisions

**After each optimization decision:**

```bash
cat >> .orchestration/multi-objective-optimizer/decisions.jsonl <<EOF
{
  "request_id": "${REQUEST_ID}",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "request": "${USER_REQUEST}",
  "weights": {"speed": 0.1, "cost": 0.1, "quality": 0.8},
  "strategies_evaluated": [
    {"name": "fast", "utility": 0.615},
    {"name": "medium", "utility": 0.705},
    {"name": "deep", "utility": 0.829}
  ],
  "selected_strategy": "deep",
  "selected_utility": 0.829,
  "predicted_latency": 720,
  "predicted_cost": 0.15,
  "predicted_quality": 0.98,
  "actual_latency": 680,
  "actual_cost": 0.14,
  "actual_quality": 1.0,
  "outcome": "PASSED"
}
EOF
```

### Model Retraining

**Weekly retraining with actual outcomes:**

```python
# Load decisions
with open('.orchestration/multi-objective-optimizer/decisions.jsonl') as f:
    decisions = [json.loads(line) for line in f]

# Separate predictions from actuals
X = []  # Features: request_features + strategy
y_latency = []  # Actual latency
y_cost = []  # Actual cost
y_quality = []  # Actual quality (PASSED=1.0, BLOCKED=0.0)

for decision in decisions:
    features = extract_features(decision['request'])
    strategy_encoding = encode_strategy(decision['selected_strategy'])

    X.append(features + strategy_encoding)
    y_latency.append(decision['actual_latency'])
    y_cost.append(decision['actual_cost'])
    y_quality.append(1.0 if decision['outcome'] == 'PASSED' else 0.0)

# Retrain prediction models
latency_model.fit(X, y_latency)
cost_model.fit(X, y_cost)
quality_model.fit(X, y_quality)

# Save updated models
joblib.dump(latency_model, '.orchestration/multi-objective-optimizer/latency_model.pkl')
joblib.dump(cost_model, '.orchestration/multi-objective-optimizer/cost_model.pkl')
joblib.dump(quality_model, '.orchestration/multi-objective-optimizer/quality_model.pkl')
```

---

## Integration with /orca

### Phase -1: Multi-Objective Optimization (before Phase 0)

```markdown
## Phase -1: Multi-Objective Strategy Optimization

1. **Load user request:**
   ```bash
   USER_REQUEST="$ARGUMENTS"
   REQUEST_ID=$(uuidgen)
   ```

2. **Determine optimization weights:**
   ```bash
   WEIGHTS=$(python3 .orchestration/multi-objective-optimizer/get-weights.py \
     --request "$USER_REQUEST" \
     --context "$TASK_CONTEXT")
   ```

3. **Run optimizer:**
   ```bash
   OPTIMAL_STRATEGY=$(python3 .orchestration/multi-objective-optimizer/optimize.py \
     --request "$USER_REQUEST" \
     --weights "$WEIGHTS")

   echo "Multi-Objective Optimizer Decision:"
   echo "Selected Strategy: $OPTIMAL_STRATEGY"
   echo "Expected Utility: $EXPECTED_UTILITY"
   ```

4. **Execute optimized strategy:**
   ```bash
   meta-orchestrator execute --strategy "$OPTIMAL_STRATEGY"
   ```
```

---

## Metrics Dashboard

**View optimization decisions:**

```bash
python3 .orchestration/multi-objective-optimizer/dashboard.py
```

**Output:**
```
=== Multi-Objective Optimizer Dashboard ===

Strategy Distribution (Last 100 Tasks):
  fast-path:   15% (15 tasks)
  medium-path: 35% (35 tasks)
  deep-path:   50% (50 tasks)

Average Utilities by Strategy:
  fast-path:   0.612
  medium-path: 0.748
  deep-path:   0.891

Prediction Accuracy (Last 100 Tasks):
  Latency MAE:  45 seconds (actual vs predicted)
  Cost MAE:     $0.02
  Quality Error: 3.2pp

Weight Profiles Used:
  Quality-first: 78%
  Speed-first:   12%
  Balanced:      10%

Pareto Frontier:
  ● medium-path (6 min, $0.04, 82%)
  ● deep-path (12 min, $0.15, 98%)
```

---

## Directory Structure

```
.orchestration/multi-objective-optimizer/
├── README.md (this file)
├── optimize.py (main optimizer)
├── get-weights.py (weight determination)
├── latency_model.pkl (latency prediction model)
├── cost_model.pkl (cost prediction model)
├── quality_model.pkl (quality prediction model)
├── retrain-models.py (weekly retraining)
├── decisions.jsonl (decision log)
└── dashboard.py (metrics viewer)
```

---

## Related Documentation

- **Meta-Orchestrator** (agents/specialized/meta-orchestrator.md) - Uses optimizer for strategy selection
- **Knowledge Graph** (.orchestration/knowledge-graph/README.md) - Provides historical performance data
- **Telemetry** (.orchestration/meta-learning/telemetry.jsonl) - Data source for retraining

---

**Last Updated:** 2025-10-25 (Stage 6 Implementation)
**Next Update:** Stage 7 (Reinforcement learning, multi-armed bandits, Bayesian optimization)
