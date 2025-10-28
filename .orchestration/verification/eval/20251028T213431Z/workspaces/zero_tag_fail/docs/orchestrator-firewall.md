# Orchestrator Firewall (Phase 5)

Purpose: Prevent the pure orchestrator from writing/editing/deleting files. Specialists implement; orchestrator coordinates.

How it works:
- Script: `scripts/orchestrator_firewall.sh` reads `.orchestration/mode.json` and env `ORCHESTRATION_ACTOR`.
- Blocks actions when `firewall` is `on` and `ORCHESTRATION_ACTOR=workflow-orchestrator` for actions: write, edit, delete, move.
- Allows read-only actions unconditionally.
- Bypass (not recommended): set `CONFIRM_TOKEN` in env for the call.

Usage (manual):
```bash
ORCHESTRATION_ACTOR=workflow-orchestrator scripts/orchestrator_firewall.sh write src/foo.ts || echo blocked
ORCHESTRATION_ACTOR=nextjs-14-specialist scripts/orchestrator_firewall.sh write src/foo.ts && echo allowed
```

Integration (tool hooks):
- Wrapper: `hooks/orchestrator-firewall.sh` (call before write/edit ops)
- Mode: `.orchestration/mode.json` — set `{"firewall": "off"}` to disable temporarily

Profiles:
- `.orchestration/mode.json` also carries `profile` (e.g., `Design-Strict`) for downstream behavior.

Auto skill activation (design helpers):
- `hooks/auto-activate-skills.sh "Task description..."` logs placeholder activation of Fluxwing/uxscii to `.orchestration/logs/skills.log`.

