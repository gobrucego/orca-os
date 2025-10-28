# Pattern Embeddings A/B Testing - Semantic vs Keyword Matching

**Purpose:** Measure which pattern matching approach yields lower false completion rates

**Version:** 1.0.0 (Stage 5 Week 10)

---

## Overview

Pattern Embeddings A/B Testing compares **two pattern matching strategies** to determine which approach better predicts task success:

1. **Keyword Matching** (Current baseline)
2. **Semantic Embedding Matching** (ML-based alternative)

**Philosophical Position:** Data-driven decision making. Don't assume one approach is better - measure and optimize based on evidence.

---

## The Question

**Current ACE Playbook System (keyword matching):**

```bash
User request: "Build login screen with email and password"

Keywords extracted: ["build", "login", "screen", "email", "password"]

Playbook search:
  - ios-pattern-001: keywords ["swiftui", "login", "authentication"]
    Overlap: 1/5 (20%) → LOW match

  - frontend-pattern-005: keywords ["react", "login", "form", "email", "password"]
    Overlap: 3/5 (60%) → HIGH match

Selected: frontend-pattern-005
```

**Problem:** Keywords miss semantic similarity
- "Build login screen" != "Create authentication UI" (0% keyword overlap)
- But they MEAN the same thing (high semantic similarity)

**Alternative: Semantic Embeddings**

```bash
User request: "Build login screen with email and password"
Request embedding: [0.823, -0.412, 0.156, ...] (1536-dim vector)

Playbook search:
  - ios-pattern-001: embedding [0.801, -0.398, 0.142, ...]
    Cosine similarity: 0.95 → VERY HIGH match

  - frontend-pattern-005: embedding [0.655, -0.201, 0.089, ...]
    Cosine similarity: 0.78 → HIGH match

Selected: ios-pattern-001 (semantic match despite keyword mismatch)
```

**The Question:** Which approach yields lower false completion rate?

---

## A/B Testing Framework

### Experimental Design

**Hypothesis:** Semantic embeddings will outperform keyword matching for pattern selection

**Null Hypothesis:** No difference in false completion rate between approaches

**Metrics:**
- **Primary:** False completion rate (tasks claimed complete but fail verification)
- **Secondary:** Pattern match accuracy, token cost, latency

**Sample Size:** Minimum 100 tasks per approach (200 total)

**Randomization:** Stratified by task type (iOS, frontend, backend)

### Test Groups

**Group A: Keyword Matching (Control)**
- 50% of tasks
- Use existing keyword overlap algorithm
- Baseline false completion rate: ~6-10% (Stage 3)

**Group B: Semantic Embedding Matching (Treatment)**
- 50% of tasks
- Use cosine similarity on pattern embeddings
- Hypothesis: False completion rate <6%

**Stratification:**
```
iOS tasks: 50% Group A, 50% Group B
Frontend tasks: 50% Group A, 50% Group B
Backend tasks: 50% Group A, 50% Group B
```

---

## Embedding Generation

### Model: text-embedding-3-small

**Why this model:**
- 1536 dimensions (rich semantic representation)
- Fast inference (< 100ms)
- Cost-effective ($0.02 per 1M tokens)
- Strong semantic understanding

**Usage:**
```bash
# Generate embedding for user request
curl https://api.openai.com/v1/embeddings \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "text-embedding-3-small",
    "input": "Build login screen with email and password"
  }'

# Response
{
  "data": [{
    "embedding": [0.823, -0.412, 0.156, ..., 0.092],  # 1536 dimensions
    "index": 0
  }],
  "model": "text-embedding-3-small"
}
```

### Pre-computed Pattern Embeddings

**Storage:** `.orchestration/playbooks/*.json` (pattern_embedding field)

**Example:**
```json
{
  "pattern_id": "ios-pattern-001",
  "pattern_embedding": [0.801, -0.398, 0.142, ..., 0.087],
  "embedding_model": "text-embedding-3-small",
  "embedding_version": "1.0.0",
  "generated_at": "2025-10-25T14:00:00Z"
}
```

**Regeneration:** When pattern description changes, regenerate embedding

---

## Cosine Similarity Calculation

### Algorithm

**Cosine similarity:**
```
similarity = (A · B) / (||A|| × ||B||)

Where:
- A = request embedding (1536-dim vector)
- B = pattern embedding (1536-dim vector)
- A · B = dot product
- ||A|| = magnitude of A
- ||B|| = magnitude of B
```

**Range:** -1.0 to 1.0
- 1.0 = identical vectors
- 0.0 = orthogonal (no similarity)
- -1.0 = opposite vectors

**Threshold:** similarity > 0.80 = strong match

### Implementation

**Script:** `.orchestration/pattern-embeddings/cosine-similarity.py`

```python
import numpy as np

def cosine_similarity(vec_a, vec_b):
    """Calculate cosine similarity between two vectors."""
    dot_product = np.dot(vec_a, vec_b)
    magnitude_a = np.linalg.norm(vec_a)
    magnitude_b = np.linalg.norm(vec_b)

    if magnitude_a == 0 or magnitude_b == 0:
        return 0.0

    return dot_product / (magnitude_a * magnitude_b)

# Example
request_embedding = [0.823, -0.412, 0.156, ...]  # 1536 dims
pattern_embedding = [0.801, -0.398, 0.142, ...]  # 1536 dims

similarity = cosine_similarity(request_embedding, pattern_embedding)
# Result: 0.95 (very high similarity)
```

---

## A/B Test Execution

### Assignment Logic

**Script:** `.orchestration/pattern-embeddings/ab-assign.sh`

```bash
#!/bin/bash
# Assign task to Group A (keyword) or Group B (embedding)

TASK_ID=$1
TASK_TYPE=$2  # ios | frontend | backend

# Deterministic assignment based on task_id hash
HASH=$(echo "$TASK_ID" | shasum -a 256 | awk '{print $1}')
HASH_INT=$(printf "%d" "0x${HASH:0:8}")

# Modulo 2 for 50/50 split
GROUP=$((HASH_INT % 2))

if [ $GROUP -eq 0 ]; then
  echo "keyword"
else
  echo "embedding"
fi
```

**Usage in /orca:**
```bash
# In Phase 0: Intent Extraction
TASK_ID=$(uuidgen)
AB_GROUP=$(./orchestration/pattern-embeddings/ab-assign.sh "$TASK_ID" "$TASK_TYPE")

if [ "$AB_GROUP" == "keyword" ]; then
  # Use keyword matching
  PATTERN=$(./orchestration/playbooks/search-playbook.sh --method keyword --request "$USER_REQUEST")
else
  # Use embedding matching
  PATTERN=$(./orchestration/playbooks/search-playbook.sh --method embedding --request "$USER_REQUEST")
fi
```

### Outcome Tracking

**After each task completion:**

```bash
# Log A/B test outcome
cat >> .orchestration/pattern-embeddings/ab-results.jsonl <<EOF
{
  "task_id": "${TASK_ID}",
  "task_type": "${TASK_TYPE}",
  "ab_group": "${AB_GROUP}",
  "pattern_matched": "${PATTERN_ID}",
  "match_score": ${MATCH_SCORE},
  "verification_verdict": "${VERDICT}",
  "false_completion": $([ "$VERDICT" == "BLOCKED" ] && echo "true" || echo "false"),
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
```

**Schema:**
```json
{
  "task_id": "uuid-1234",
  "task_type": "ios",
  "ab_group": "embedding",
  "pattern_matched": "ios-pattern-001",
  "match_score": 0.95,
  "verification_verdict": "PASSED",
  "false_completion": false,
  "timestamp": "2025-10-25T14:30:00Z"
}
```

---

## Results Analysis

### Statistical Significance

**Script:** `.orchestration/pattern-embeddings/analyze-results.py`

```python
import json
import scipy.stats as stats

# Load results
with open('.orchestration/pattern-embeddings/ab-results.jsonl') as f:
    results = [json.loads(line) for line in f]

# Separate by group
keyword_results = [r for r in results if r['ab_group'] == 'keyword']
embedding_results = [r for r in results if r['ab_group'] == 'embedding']

# Calculate false completion rates
keyword_false_rate = sum(r['false_completion'] for r in keyword_results) / len(keyword_results)
embedding_false_rate = sum(r['false_completion'] for r in embedding_results) / len(embedding_results)

# Statistical test (two-proportion z-test)
n1 = len(keyword_results)
n2 = len(embedding_results)
p1 = keyword_false_rate
p2 = embedding_false_rate

# Calculate z-score
p_pool = (p1 * n1 + p2 * n2) / (n1 + n2)
se = ((p_pool * (1 - p_pool)) * (1/n1 + 1/n2)) ** 0.5
z_score = (p1 - p2) / se

# Two-tailed p-value
p_value = 2 * (1 - stats.norm.cdf(abs(z_score)))

print(f"Keyword False Completion Rate: {keyword_false_rate:.2%}")
print(f"Embedding False Completion Rate: {embedding_false_rate:.2%}")
print(f"Difference: {(p1 - p2):.2%}")
print(f"Z-score: {z_score:.2f}")
print(f"P-value: {p_value:.4f}")

if p_value < 0.05:
    if p2 < p1:
        print("✅ Embedding matching is SIGNIFICANTLY better (p < 0.05)")
    else:
        print("❌ Keyword matching is SIGNIFICANTLY better (p < 0.05)")
else:
    print("⚠️  No significant difference (p >= 0.05)")
```

### Confidence Intervals

**95% Confidence Intervals:**

```python
from statsmodels.stats.proportion import proportion_confint

# Keyword group
keyword_ci = proportion_confint(
    count=sum(r['false_completion'] for r in keyword_results),
    nobs=len(keyword_results),
    alpha=0.05,
    method='wilson'
)

# Embedding group
embedding_ci = proportion_confint(
    count=sum(r['false_completion'] for r in embedding_results),
    nobs=len(embedding_results),
    alpha=0.05,
    method='wilson'
)

print(f"Keyword 95% CI: {keyword_ci[0]:.2%} - {keyword_ci[1]:.2%}")
print(f"Embedding 95% CI: {embedding_ci[0]:.2%} - {embedding_ci[1]:.2%}")
```

---

## Decision Criteria

### When to Adopt Embedding Matching

**Criteria for switching from keyword to embedding:**

1. **Statistical significance:** p-value < 0.05
2. **Practical significance:** Embedding false completion rate < keyword by ≥2 percentage points
3. **Sample size:** Minimum 100 tasks per group
4. **Consistency:** Result holds across task types (iOS, frontend, backend)

**Example decision:**

```
Results after 200 tasks (100 per group):

Keyword False Completion Rate: 8.2% (CI: 5.1% - 12.3%)
Embedding False Completion Rate: 4.5% (CI: 2.1% - 7.9%)
Difference: -3.7 percentage points
Z-score: 2.34
P-value: 0.019

✅ ADOPT EMBEDDING MATCHING
- Statistically significant (p = 0.019 < 0.05)
- Practically significant (-3.7pp > -2pp threshold)
- Sample size adequate (100+ per group)
- Result consistent across iOS (p=0.032), frontend (p=0.041), backend (p=0.027)
```

### When to Keep Keyword Matching

**Criteria for retaining keyword:**

1. **No significant difference:** p-value ≥ 0.05
2. **Keyword performs better:** Keyword false completion rate < embedding
3. **Cost concerns:** Embedding API costs outweigh benefits

**Example decision:**

```
Results after 200 tasks:

Keyword False Completion Rate: 6.1% (CI: 3.8% - 9.4%)
Embedding False Completion Rate: 5.8% (CI: 3.2% - 9.2%)
Difference: -0.3 percentage points
Z-score: 0.18
P-value: 0.857

⚠️  RETAIN KEYWORD MATCHING
- Not statistically significant (p = 0.857 > 0.05)
- Difference too small to justify switching (-0.3pp)
- Keyword matching is simpler and cost-free
```

---

## Hybrid Approach

### Best of Both Worlds

**If both approaches have strengths:**

```bash
# Use both methods and take highest confidence match

# Method 1: Keyword matching
KEYWORD_MATCH=$(search_by_keywords "$USER_REQUEST")
KEYWORD_SCORE=$(calculate_keyword_overlap "$USER_REQUEST" "$KEYWORD_MATCH")

# Method 2: Embedding matching
EMBEDDING_MATCH=$(search_by_embedding "$USER_REQUEST")
EMBEDDING_SCORE=$(calculate_cosine_similarity "$USER_REQUEST" "$EMBEDDING_MATCH")

# Normalize scores (0.0 - 1.0)
KEYWORD_NORM=$(normalize_score "$KEYWORD_SCORE")
EMBEDDING_NORM=$(normalize_score "$EMBEDDING_SCORE")

# Weighted combination (adjust weights based on A/B results)
WEIGHT_KEYWORD=0.4
WEIGHT_EMBEDDING=0.6

HYBRID_SCORE=$(echo "$KEYWORD_NORM * $WEIGHT_KEYWORD + $EMBEDDING_NORM * $WEIGHT_EMBEDDING" | bc -l)

# Select pattern with highest hybrid score
if [ "$KEYWORD_MATCH" == "$EMBEDDING_MATCH" ]; then
  # Both methods agree
  SELECTED_PATTERN="$KEYWORD_MATCH"
  CONFIDENCE="HIGH"
else
  # Methods disagree - use hybrid score
  if (( $(echo "$KEYWORD_NORM > $EMBEDDING_NORM" | bc -l) )); then
    SELECTED_PATTERN="$KEYWORD_MATCH"
    CONFIDENCE="MEDIUM"
  else
    SELECTED_PATTERN="$EMBEDDING_MATCH"
    CONFIDENCE="MEDIUM"
  fi
fi
```

---

## Cost Analysis

### Keyword Matching (Free)

```
Request: "Build login screen"
Processing: Local string matching
Cost: $0.00
Latency: < 1ms
```

### Embedding Matching

```
Request: "Build login screen"
Processing: OpenAI Embedding API call
Cost: $0.00002 per request (text-embedding-3-small)
Latency: ~100ms

Annual cost (10,000 requests): $0.20
```

**Conclusion:** Embedding cost is negligible ($0.20/year for 10K requests)

---

## Rollout Plan

### Phase 1: A/B Testing (Weeks 1-4)

- Enable A/B test for all tasks
- Collect 200+ task outcomes
- Analyze results

### Phase 2: Decision (Week 5)

- Run statistical analysis
- Apply decision criteria
- Choose: keyword, embedding, or hybrid

### Phase 3: Rollout (Week 6-8)

- If embedding wins: Switch all traffic to embedding
- If keyword wins: Disable embedding, retain keyword
- If hybrid wins: Implement weighted combination

### Phase 4: Monitoring (Ongoing)

- Continue tracking false completion rates
- Re-run A/B test quarterly
- Adjust weights if using hybrid approach

---

## Integration with ACE Playbook System

### Modified playbook-curator.md

**Pattern embedding generation:**

```markdown
## Pattern Curation (Updated with Embeddings)

AFTER creating new pattern:

1. Generate pattern description
2. **Generate pattern embedding:**
   ```bash
   EMBEDDING=$(curl https://api.openai.com/v1/embeddings \
     -H "Authorization: Bearer $OPENAI_API_KEY" \
     -H "Content-Type: application/json" \
     -d "{\"model\": \"text-embedding-3-small\", \"input\": \"$PATTERN_DESCRIPTION\"}" \
     | jq '.data[0].embedding')

   jq --argjson emb "$EMBEDDING" '.pattern_embedding = $emb' pattern.json > pattern.tmp
   mv pattern.tmp pattern.json
   ```

3. Save pattern to playbook
```

### Modified search-playbook.sh

**Add embedding search:**

```bash
# Check A/B group assignment
AB_GROUP=$(./orchestration/pattern-embeddings/ab-assign.sh "$TASK_ID" "$TASK_TYPE")

if [ "$AB_GROUP" == "keyword" ]; then
  # Existing keyword search
  PATTERN=$(search_by_keywords "$USER_REQUEST")
else
  # New embedding search
  REQUEST_EMBEDDING=$(generate_embedding "$USER_REQUEST")

  BEST_MATCH=""
  BEST_SCORE=0

  for pattern in $(ls .orchestration/playbooks/*.json); do
    PATTERN_EMBEDDING=$(jq -r '.pattern_embedding' "$pattern")
    SIMILARITY=$(python3 -c "import numpy as np; print(cosine_similarity($REQUEST_EMBEDDING, $PATTERN_EMBEDDING))")

    if (( $(echo "$SIMILARITY > $BEST_SCORE" | bc -l) )); then
      BEST_SCORE="$SIMILARITY"
      BEST_MATCH="$pattern"
    fi
  done

  PATTERN="$BEST_MATCH"
fi
```

---

## Metrics Dashboard

### Real-Time Monitoring

**Dashboard:** `.orchestration/pattern-embeddings/dashboard.html`

```html
<!DOCTYPE html>
<html>
<head>
  <title>Pattern Matching A/B Test Results</title>
</head>
<body>
  <h1>Pattern Matching A/B Test Results</h1>

  <table>
    <tr>
      <th>Metric</th>
      <th>Keyword (Control)</th>
      <th>Embedding (Treatment)</th>
      <th>Difference</th>
    </tr>
    <tr>
      <td>Tasks Completed</td>
      <td id="keyword-count">-</td>
      <td id="embedding-count">-</td>
      <td>-</td>
    </tr>
    <tr>
      <td>False Completion Rate</td>
      <td id="keyword-rate">-</td>
      <td id="embedding-rate">-</td>
      <td id="rate-diff">-</td>
    </tr>
    <tr>
      <td>95% Confidence Interval</td>
      <td id="keyword-ci">-</td>
      <td id="embedding-ci">-</td>
      <td>-</td>
    </tr>
    <tr>
      <td>P-value</td>
      <td colspan="2" id="p-value">-</td>
      <td id="significance">-</td>
    </tr>
  </table>

  <script src="dashboard.js"></script>
</body>
</html>
```

---

## Expected Results

### Hypothesis 1: Embedding Wins

**Scenario:** Embeddings reduce false completions by 3-5 percentage points

```
Keyword: 8% false completion rate
Embedding: 4% false completion rate
Difference: -4pp (50% reduction)
P-value: < 0.001 (highly significant)

Decision: ADOPT EMBEDDING MATCHING
Expected annual benefit: 50% fewer false completions
Cost: $0.20/year for embeddings (negligible)
```

### Hypothesis 2: No Difference

**Scenario:** Both methods perform similarly

```
Keyword: 6.5% false completion rate
Embedding: 6.2% false completion rate
Difference: -0.3pp (not significant)
P-value: 0.72 (not significant)

Decision: RETAIN KEYWORD MATCHING
Reason: Simpler, no API dependency, no cost
```

### Hypothesis 3: Hybrid Optimal

**Scenario:** Each method has different strengths

```
Keyword: Better for exact matches (e.g., "SwiftUI login")
Embedding: Better for semantic matches (e.g., "authentication screen")

Decision: HYBRID APPROACH
Weights: 40% keyword + 60% embedding
Expected: 5% false completion rate (best of both)
```

---

## Directory Structure

```
.orchestration/pattern-embeddings/
├── README.md (this file)
├── ab-assign.sh (assign tasks to groups)
├── ab-results.jsonl (outcome log)
├── analyze-results.py (statistical analysis)
├── cosine-similarity.py (similarity calculation)
├── generate-embedding.sh (API wrapper)
├── dashboard.html (real-time results)
└── dashboard.js (dashboard logic)
```

---

## Related Documentation

- **ACE Playbook System** (.orchestration/playbooks/README.md) - Pattern matching foundation
- **playbook-curator** (agents/specialized/playbook-curator.md) - Generates pattern embeddings
- **orchestration-reflector** (agents/specialized/orchestration-reflector.md) - Uses patterns for learning

---

**Last Updated:** 2025-10-25 (Stage 5 Week 10)
**Next Update:** Stage 6 (Adaptive weighting based on task type, multi-modal embeddings)
