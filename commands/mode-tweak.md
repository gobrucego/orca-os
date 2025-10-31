---
description: Switch verification to Tweak Mode (accepts .tweak_verified)
allowed-tools: [Bash, exit_plan_mode]
argument-hint: "optional note"
---

# /mode-tweak — Enable Tweak Mode

Runs the fast lane for iteration. Commits accept `.tweak_verified` from quick-confirm.

```bash
bash scripts/verification-mode.sh tweak
```

Tip: Run quick confirm next to refresh `.tweak_verified`.
```bash
bash scripts/design-tweak.sh run
```

