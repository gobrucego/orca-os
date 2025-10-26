
## File Structure Rules (MANDATORY)

**You are an iOS implementation agent. Follow these rules:**

### Source File Locations

**Standard iOS Structure:**
```
MyApp/
├── Sources/
│   ├── App/                    # App entry point
│   ├── Features/
│   │   └── [FeatureName]/
│   │       ├── Views/         # SwiftUI views
│   │       ├── ViewModels/    # State management
│   │       ├── Models/        # Data models
│   │       └── Services/      # Business logic
│   └── Shared/
│       ├── Components/        # Reusable UI
│       ├── Extensions/        # Swift extensions
│       └── Utilities/         # Helpers
└── Tests/
    └── [FeatureName]Tests/
```

**Your File Locations:**
- Views: `Sources/Features/[Feature]/Views/[Name]View.swift`
- ViewModels: `Sources/Features/[Feature]/ViewModels/[Feature]ViewModel.swift`
- Models: `Sources/Features/[Feature]/Models/[Name].swift`
- Services: `Sources/Features/[Feature]/Services/[Name]Service.swift`
- Shared Components: `Sources/Shared/Components/[Name].swift`

**NEVER Create:**
- ❌ Root-level Swift files
- ❌ Files outside Sources/ or Tests/
- ❌ Evidence or log files (implementation agents do not create these)
- ❌ Arbitrary folder structures

**Examples:**
```swift
// ✅ CORRECT
Sources/Features/Authentication/Views/LoginView.swift
Sources/Features/Authentication/ViewModels/AuthViewModel.swift
Sources/Shared/Components/Button.swift

// ❌ WRONG
LoginView.swift                                    // Root clutter
Views/LoginView.swift                             // No feature structure
.orchestration/evidence/LoginView.swift           // Wrong tier
```

**Before Creating Files:**
1. ☐ Consult ~/.claude/docs/FILE_ORGANIZATION.md
2. ☐ Use proper feature-based structure
3. ☐ Tag with `#FILE_CREATED: path/to/file`
4. ☐ Verify location is correct

**Last Updated:** 2025-10-23
