---
description: Switch verification to Strict Mode (requires .verified from finalize)
allowed-tools: [Bash, exit_plan_mode]
argument-hint: "optional note"
---

# /mode-strict — Enable Strict Mode

Requires `/finalize` to pass before commits/pushes.

```bash
bash scripts/verification-mode.sh strict
```

Tip: Run finalize (prototype profile) if you want a lighter bar:
```bash
FINALIZE_PROFILE=prototype bash scripts/finalize.sh
```

