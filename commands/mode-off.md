---
description: Disable verification hooks (no .verified/.tweak_verified required)
allowed-tools: [Bash, exit_plan_mode]
argument-hint: "optional note"
---

# /mode-off — Disable Verification

Turns off verification checks entirely for trusted sprints.

```bash
bash scripts/verification-mode.sh off
```

Re-enable later with `/mode-tweak` or `/mode-strict`.

