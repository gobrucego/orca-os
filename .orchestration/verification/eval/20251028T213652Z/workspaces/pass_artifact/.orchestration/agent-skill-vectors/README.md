# Agent Skill Vectors

**Purpose:** Track specialist performance for intelligent team composition

**Version:** 1.0.0 (Stage 2 Week 3)

---

## Overview

Agent Skill Vectors transform agent selection from **intuitive guessing** to **data-driven decisions** by tracking real performance metrics for every specialist.

**Core Concept:** Each agent has a "skill vector" - a multi-dimensional representation of their performance across domains, success rate, cost, and time.

---

## The Problem

**Current agent selection (intuitive):**

```
User: "Build iOS app with weather data"

/orca thinks:
  "iOS app → probably need swiftui-developer"
  "Weather data → probably need urlsession-expert"
  "Maybe state-architect too?"

Dispatches: swiftui-developer, urlsession-expert, state-architect
Result: ???
```

**Problems:**
- No data on which agents actually succeed
- No knowledge of agent costs
- Can't learn from failures
- Chronic low performers still get dispatched

---

## The Solution: Skill Vectors

**New agent selection (data-driven):**

```
User: "Build iOS app with weather data"

/orca loads costs.json:
  swiftui-developer:
    success_rate: 0.94 ✅
    domains: [ios, swiftui, ui]
    avg_cost: $0.75

  urlsession-expert:
    success_rate: 0.88 ✅
    domains: [ios, networking, api]
    avg_cost: $0.65

  state-architect:
    success_rate: 0.96 ✅
    domains: [architecture, state-management]
    avg_cost: $0.55

/orca computes cosine similarity:
  User request embedding → [0.15, -0.42, 0.69, ...]

  swiftui-developer domains → similarity: 0.92
  urlsession-expert domains → similarity: 0.89
  state-architect domains → similarity: 0.78

/orca selects best team:
  1. swiftui-developer (0.94 success, 0.92 similarity)
  2. urlsession-expert (0.88 success, 0.89 similarity)
  3. state-architect (0.96 success, 0.78 similarity)

All CERTIFIED (success_rate > 0.70)
Total estimated cost: $1.95
```

**Result:** Higher probability of success, data-backed decisions

---

## Skill Vector Components

### 1. Performance Metrics

```json
"metrics": {
  "success_rate": 0.94,
  "total_dispatches": 50,
  "successful_completions": 47,
  "failed_completions": 3,
  "avg_cost_usd": 0.75,
  "total_cost_usd": 37.50,
  "avg_time_minutes": 12.5,
  "last_active": "2025-10-24T22:00:00Z"
}
```

**success_rate:** `successful_completions / total_dispatches`
- **Certified:** >= 0.70
- **Probation:** < 0.70
- **Blocked:** < 0.50 (automatic blacklist)

**cost metrics:** Track token usage per dispatch
**time metrics:** Track average completion time

### 2. Domain Tags

```json
"domains": ["ios", "swiftui", "ui", "state-management"]
```

**Purpose:** Match agent expertise to user request

**Examples:**
- **swiftui-developer:** `["ios", "swiftui", "ui", "state-management"]`
- **react-18-specialist:** `["frontend", "react", "ui", "typescript"]`
- **backend-engineer:** `["backend", "api", "database", "nodejs"]`

### 3. Domain Vector (Optional Embeddings)

```json
"domain_vector": [0.95, 0.92, 0.88, 0.85]
```

**Purpose:** Numeric representation of domain expertise

**Calculation:** Expertise level per domain (0.0 - 1.0)
- 0.95 = Expert in iOS
- 0.92 = Expert in SwiftUI
- 0.88 = Strong in UI
- 0.85 = Strong in state management

**Usage:** Cosine similarity for semantic matching

### 4. Certification Status

```json
"status": "CERTIFIED",
"certification": {
  "threshold": 0.70,
  "current_rate": 0.94,
  "status_since": "2025-10-20T00:00:00Z"
}
```

**Statuses:**
- **CERTIFIED:** success_rate >= 0.70 (can be dispatched)
- **PROBATION:** success_rate < 0.70 (warning, dispatch with caution)
- **BLOCKED:** success_rate < 0.50 (cannot dispatch)

**Automatic certification:**
- New agents start CERTIFIED (benefit of doubt)
- After 10 dispatches, recalculate
- If drops below threshold → PROBATION
- If drops below 0.50 → BLOCKED

### 5. Failure Analysis

```json
"failure_analysis": {
  "common_failures": [
    "accessibility labels missing",
    "test coverage incomplete"
  ],
  "last_failure": "2025-10-22T15:30:00Z",
  "failure_pattern": "UI accessibility gaps"
}
```

**Purpose:** Learn from failures to improve

**Tracked:**
- Which deliverables fail most often
- When failures occur
- Patterns in failure types

**Usage:**
- workflow-orchestrator can warn specialist about common failures
- playbook-curator can create patterns to avoid failures

### 6. Performance Trends

```json
"performance_trend": {
  "last_7_days": {
    "success_rate": 0.95,
    "avg_cost": 0.72
  },
  "last_30_days": {
    "success_rate": 0.94,
    "avg_cost": 0.75
  }
}
```

**Purpose:** Track improvement or degradation

**Usage:**
- Is agent getting better or worse?
- Cost trending up or down?
- Seasonal variations?

---

## Team Composition Algorithm

### Step 1: Load User Request

```
User: "Build iOS weather app with offline mode"
```

### Step 2: Generate Request Embedding (Optional)

```javascript
requestEmbedding = generateEmbedding("Build iOS weather app with offline mode")
  → [0.15, -0.42, 0.69, ...]
```

### Step 3: Extract Keywords

```javascript
keywords = ["ios", "weather", "app", "offline", "mode"]
```

### Step 4: Load All Agents from costs.json

```javascript
agents = loadAgents(".orchestration/costs.json")
```

### Step 5: Filter by Certification

```javascript
certifiedAgents = agents.filter(a => a.status === "CERTIFIED")
```

**Result:** Only agents with success_rate >= 0.70 are considered

### Step 6: Compute Domain Similarity

**Option A: Keyword Matching**

```javascript
for (agent of certifiedAgents) {
  matchCount = intersection(keywords, agent.domains).length
  agent.domain_match_score = matchCount / keywords.length
}
```

**Option B: Embedding Similarity (if domain_vector exists)**

```javascript
for (agent of certifiedAgents) {
  if (agent.domain_vector) {
    similarity = cosineSimilarity(requestEmbedding, agent.domain_vector)
    agent.similarity_score = similarity
  }
}
```

### Step 7: Rank Agents

```javascript
rankedAgents = certifiedAgents
  .sort((a, b) => {
    // Primary: Domain match/similarity
    if (b.similarity_score !== a.similarity_score) {
      return b.similarity_score - a.similarity_score
    }
    // Secondary: Success rate
    return b.metrics.success_rate - a.metrics.success_rate
  })
```

### Step 8: Select Top N

```javascript
selectedTeam = rankedAgents.slice(0, 5)  // Top 5 agents
```

### Step 9: Estimate Cost & Time

```javascript
estimatedCost = selectedTeam.reduce((sum, a) => sum + a.metrics.avg_cost_usd, 0)
estimatedTime = Math.max(...selectedTeam.map(a => a.metrics.avg_time_minutes))
```

### Step 10: Dispatch Team

```javascript
dispatch(selectedTeam, {
  estimated_cost: estimatedCost,
  estimated_time: estimatedTime,
  selection_method: "skill_vectors"
})
```

---

## Updating Skill Vectors

### After Task Completion

**When:** verification-agent marks task as VERIFIED or BLOCKED

**Update Process:**

```javascript
// Load costs.json
costs = loadCosts()

// Find agent who implemented this task
agentName = task.claimed_by

// Update metrics
if (!costs.specialists[agentName]) {
  // Initialize new agent
  costs.specialists[agentName] = initializeAgent(agentName)
}

agent = costs.specialists[agentName]

// Update dispatch counts
agent.metrics.total_dispatches += 1

// Update success/failure
if (task.status === "verified") {
  agent.metrics.successful_completions += 1
} else if (task.status === "blocked") {
  agent.metrics.failed_completions += 1

  // Track failure reasons
  agent.failure_analysis.common_failures.push(...task.failures)
  agent.failure_analysis.last_failure = new Date().toISOString()
}

// Recalculate success rate
agent.metrics.success_rate =
  agent.metrics.successful_completions / agent.metrics.total_dispatches

// Update certification status
if (agent.metrics.total_dispatches >= 10) {
  if (agent.metrics.success_rate >= 0.70) {
    agent.status = "CERTIFIED"
  } else if (agent.metrics.success_rate >= 0.50) {
    agent.status = "PROBATION"
  } else {
    agent.status = "BLOCKED"
  }
}

// Update cost metrics
agent.metrics.avg_cost_usd =
  (agent.metrics.avg_cost_usd * (agent.metrics.total_dispatches - 1) + task.cost) /
  agent.metrics.total_dispatches

agent.metrics.total_cost_usd += task.cost

// Update timestamp
agent.metrics.last_active = new Date().toISOString()

// Save updated costs.json
saveCosts(costs)
```

---

## Example: Full Agent Profile

```json
{
  "swiftui-developer": {
    "metrics": {
      "success_rate": 0.94,
      "total_dispatches": 50,
      "successful_completions": 47,
      "failed_completions": 3,
      "avg_cost_usd": 0.75,
      "total_cost_usd": 37.50,
      "avg_time_minutes": 12.5,
      "last_active": "2025-10-24T22:00:00Z"
    },
    "domains": ["ios", "swiftui", "ui", "state-management"],
    "domain_vector": [0.95, 0.92, 0.88, 0.85],
    "status": "CERTIFIED",
    "certification": {
      "threshold": 0.70,
      "current_rate": 0.94,
      "status_since": "2025-10-20T00:00:00Z"
    },
    "failure_analysis": {
      "common_failures": [
        "accessibility labels missing (2 occurrences)",
        "test coverage incomplete (1 occurrence)"
      ],
      "last_failure": "2025-10-22T15:30:00Z",
      "failure_pattern": "UI accessibility gaps"
    },
    "performance_trend": {
      "last_7_days": {
        "success_rate": 0.95,
        "avg_cost": 0.72,
        "dispatches": 10
      },
      "last_30_days": {
        "success_rate": 0.94,
        "avg_cost": 0.75,
        "dispatches": 40
      }
    }
  }
}
```

---

## Integration with /orca

### Phase 0: Load Skill Vectors

```markdown
Before agent selection:

1. Load costs.json
2. Load playbook patterns (semantic embeddings)
3. Combine: Pattern matching + Skill vectors
```

### Pattern Matching + Skill Vectors

```markdown
User request: "Build iOS weather app"

Step 1: Match Playbook Patterns
  Pattern: "iOS app with API integration"
  Suggested agents: urlsession-expert, state-architect, swiftui-developer

Step 2: Filter by Skill Vectors
  urlsession-expert: success_rate=0.88, CERTIFIED ✅
  state-architect: success_rate=0.96, CERTIFIED ✅
  swiftui-developer: success_rate=0.94, CERTIFIED ✅

Step 3: Rank by Performance
  1. state-architect (0.96 success)
  2. swiftui-developer (0.94 success)
  3. urlsession-expert (0.88 success)

Step 4: Dispatch Top Performers
  All CERTIFIED → Dispatch all three
  Estimated success: 0.93 average
```

---

## Benefits

### 1. Data-Driven Selection

**Before:** "I think swiftui-developer is good for iOS"
**After:** "swiftui-developer has 0.94 success rate on iOS tasks"

### 2. Automatic Quality Control

Agents with <70% success rate go to PROBATION
Agents with <50% success rate get BLOCKED
No manual intervention needed

### 3. Cost Optimization

Track which agents are expensive
Choose cheaper agents when quality is similar

### 4. Failure Learning

Track common failure patterns
Warn specialists about their weak points
Improve over time

### 5. Performance Trends

See if agents improving or degrading
Adjust team composition based on recent performance

---

## Impact on False Completion Rate

**Current:** ~25-35% after Stage 2 Two-Phase Commit

**After Skill Vectors:** Expected **20-30%**

**Why:**
- Blacklist chronic low performers
- Prefer high-success agents
- Learn from failures
- Data-backed decisions

**Not a major reduction because:**
- Skill vectors improve WHICH agents to use
- But doesn't prevent verification skipping (already solved in Stage 1-2)
- Main benefit: Efficiency and reliability, not just false completion reduction

---

## Backward Compatibility

**Old costs.json (simple):**
```json
{
  "specialists": {
    "swiftui-developer": {
      "total_cost": 37.50
    }
  }
}
```

**New costs.json (skill vectors):**
```json
{
  "specialists": {
    "swiftui-developer": {
      "metrics": {
        "success_rate": 0.94,
        "total_cost_usd": 37.50,
        ...
      },
      "domains": [...],
      ...
    }
  }
}
```

**Migration:** Old format still works, new fields are optional

---

## Related Documentation

- **.orchestration/costs.json** - Actual skill vector data
- **Pattern Embeddings** (.orchestration/playbooks/README.md) - Semantic matching
- **Specialist Certification** (Stage 3 Week 6) - Automatic blacklisting
- **/orca command** - Team composition logic

---

**Last Updated:** 2025-10-24 (Stage 2 Week 3)
**Next Update:** Stage 3 Week 6 (Specialist Certification enforcement)
