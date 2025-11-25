# Complexity Routing

OS 2.3 routes tasks based on complexity to optimize for speed (simple tasks) or thoroughness (complex tasks).

## Complexity Tiers

### Simple
Single-file changes, minor tweaks, quick fixes.

**Indicators:**
- Single file affected
- Minor UI tweak (padding, color, text)
- Small bugfix with obvious location
- Copy/label changes
- Keywords: "tweak", "fix", "adjust", "change" + single element

**Route:** Light orchestrator → single specialist → done (skip gates)

### Medium
Modest changes across a few files, needs some verification.

**Indicators:**
- 2-5 files affected
- Single screen/section changes
- New simple component
- Some logic changes
- Needs basic verification

**Route:** Full pipeline, spec recommended but not required

### Complex
Multi-file, architectural, or high-risk changes.

**Indicators:**
- Multiple screens/flows
- Architecture/data layer changes
- New feature with state management
- Security/auth/payments
- Major refactoring
- Keywords: "implement", "build", "create", "refactor" + feature/system

**Route:** Full pipeline, spec REQUIRED

## Flags and Modes

### `-tweak` Flag

Force the light path regardless of classification:

```bash
/orca-ios -tweak "fix button padding"
/orca-nextjs -tweak "update header text"
/orca-shopify -tweak "adjust card spacing"
```

Use when you know a task is simple and want to skip overhead.

### `--audit` Flag

Enter deep audit mode - review without implementation:

```bash
/orca-ios --audit              # Deep iOS codebase audit
/orca-nextjs --audit           # Deep Next.js audit
/orca-shopify --audit          # Deep Shopify theme audit
```

Audit mode:
- Clarifies focus areas with user
- Assembles domain-specific audit squad
- Agents analyze code via Read/Grep/Glob
- Produces audit report with findings
- Suggests follow-up tasks
- **Never modifies code**

### Spec Gating

Complex tasks are blocked without a requirements spec:

```
⛔ BLOCKED: Complex task requires a spec.

Run first:
  /plan "description of the feature"

Then return with:
  /orca-ios "implement requirement <id>"
```

Specs live at: `requirements/<id>/06-requirements-spec.md`

Created by `/plan`, consumed by domain orchestrators.

## Routing Flow

```
Parse Arguments
    │
    ├─ Contains "-tweak"? → Light Orchestrator
    │
    ├─ Contains "--audit"? → Audit Mode
    │
    └─ Otherwise:
        │
        Classify Complexity
            │
            ├─ SIMPLE → Light Orchestrator
            │
            ├─ MEDIUM → Full Pipeline (spec recommended)
            │
            └─ COMPLEX:
                │
                ├─ Has spec? → Full Pipeline
                │
                └─ No spec? → BLOCKED (run /plan first)
```

## Light Orchestrators

Fast-path agents for simple tasks:

| Lane | Light Orchestrator |
|------|-------------------|
| iOS | `ios-light-orchestrator` |
| Next.js | `nextjs-light-orchestrator` |
| Expo | `expo-light-orchestrator` |
| Shopify | `shopify-light-orchestrator` |

Light orchestrators:
- Skip team confirmation
- Quick context (direct file read, minimal ProjectContext)
- Single specialist delegation
- Skip gates and verification
- Return summary directly

## See Also

- [Pipeline Model](pipeline-model.md) - Full pipeline architecture
- [Memory Systems](memory-systems.md) - How context is gathered
