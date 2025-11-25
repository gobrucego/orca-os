# Changelog

## v2.3 (2025-11-25)

### New Features

**Complexity Routing**
- Automatic simple/medium/complex classification
- Heuristics based on file count, keywords, and scope

**Light Orchestrators**
- Fast path for simple tasks
- `-tweak` flag forces light path
- Skip team confirmation, gates, verification
- Per-domain: `ios-light-orchestrator`, `nextjs-light-orchestrator`, `expo-light-orchestrator`, `shopify-light-orchestrator`

**Deep Audit Mode**
- `--audit` flag for review without implementation
- Per-domain audit squads
- Clarify focus areas with user
- Produce audit report with findings and follow-up tasks

**Spec Gating**
- Complex tasks blocked without requirements spec
- Spec created by `/plan`, stored at `requirements/<id>/06-requirements-spec.md`
- Medium tasks: spec recommended
- Simple tasks: spec not needed

**Memory-First Context**
- Check Workshop + vibe.db before ProjectContext
- Surfaces past decisions and gotchas early
- Reduces token usage and latency

**Response Awareness (RA) Integration**
- `ra_events` field in `phase_state.json`
- RA tags: `#COMPLETION_DRIVE`, `#CARGO_CULT`, `#PATH_DECISION`, `#POISON_PATH`, `#TOKEN_VIOLATION`
- Gates report `ra_status` in output
- `/audit` mines RA events across tasks

**New Commands**
- `/root-cause` - Multi-lane diagnostic investigation
- Domain audit: `/orca-ios --audit`, `/orca-nextjs --audit`, etc.

### Lane Updates

**All Lanes (iOS, Next.js, Expo, Shopify)**
- Upgraded to v2.3 with complexity routing
- Added light orchestrators
- Added `--audit` mode
- Added RA integration to specialists and gates
- Memory-first context pattern

**OS-Dev Lane**
- New lane for OS configuration work
- LOCAL to claude-vibe-config repo only
- NOT wired into main `/orca` routing
- Components: grand-architect, architect, builder, standards-enforcer, verification

**Specialist Pipelines (Data, SEO, Design)**
- Updated to v2.3 patterns
- Route directly to specialists (no grand-architect)

### Agent Changes

- Light orchestrators added (4 new agents)
- RA tagging added to all specialists
- RA status checking added to all gates
- Agent tools format standardized to YAML arrays

### Technical Changes

- `phase_state.json` schema updated with `ra_events`, `complexity_tier`
- Phase configs updated with `memory_first: true`, complexity routing
- Gate output includes `ra_status` field

### Documentation

- Complete docs overhaul
- New `docs/concepts/` with core mental models
- Clean `docs/pipelines/` per lane
- Archived pre-v2.3 docs to `.archive/`

### Breaking Changes

None. v2.3 is backward compatible with v2.2.

---

## v2.2 (2025-11-24)

Initial multi-lane orchestration release.

- Domain-specific pipelines (iOS, Next.js, Expo, Shopify, Data, SEO, Design)
- Grand architect pattern (Opus coordination)
- Specialist agents per domain
- Gate and verification patterns
- ProjectContext MCP integration
- Phase state management
- Team confirmation before execution
- State preservation across interruptions

---

## v2.1 and Earlier

Pre-orchestration versions. See `.archive/` for historical context.
