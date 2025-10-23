# Examples

Real-world examples of Claude Vibe Code auto-orchestration in action.

## Structure

Each example includes:
- **Problem description** - What the user wanted
- **Detection output** - How the system classified the project
- **Orchestration flow** - Which agents were dispatched
- **Evidence** - Screenshots, test logs, build outputs
- **Time metrics** - How long it took

## Available Examples

### iOS Calculator Fix
**Path:** `ios-calculator-fix/`

Fix broken tap targets on iOS calculator buttons.

**Flow:**
```
User: "Calculator buttons broken on mobile"
→ Detected: iOS project
→ Dispatched: ios-engineer
→ Evidence: before.png, after.png, build.log
→ Time: 8 minutes
```

### Next.js Dark Mode
**Path:** `nextjs-dark-mode/`

Add dark mode toggle to a Next.js application.

**Flow:**
```
User: "Add dark mode toggle"
→ Detected: Next.js project
→ Dispatched: system-architect, frontend-engineer, test-engineer (parallel)
→ Evidence: light-mode.png, dark-mode.png, test-output.log, build.log
→ Time: 18 minutes (parallelized)
```

### Python API Authentication
**Path:** `python-api-auth/`

Add OAuth2 authentication to a Python FastAPI backend.

**Flow:**
```
User: "Add authentication to the API"
→ Detected: Python project
→ Dispatched: backend-engineer, test-engineer
→ Evidence: test-output.log, curl-examples.sh, build.log
→ Time: 25 minutes
```

## Contributing Examples

To add your own example:

1. Create a directory with a descriptive name
2. Include:
   - `README.md` - Problem, solution, flow
   - `evidence/` - Screenshots, logs, outputs
   - `code/` - Relevant code snippets (optional)
3. Follow the template structure
4. Submit a PR

## Template Structure

```
example-name/
├── README.md              # Full walkthrough
├── evidence/              # Proof of work
│   ├── screenshots/
│   ├── test-outputs/
│   └── build-logs/
└── code/                  # Code snippets (optional)
    └── relevant-files/
```
