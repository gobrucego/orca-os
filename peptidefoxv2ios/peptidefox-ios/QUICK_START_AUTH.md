# Quick Start: Authentication & Profile

## 1. Add Files to Xcode (2 minutes)

**Drag & Drop Method** (Easiest):
1. Open Xcode: `PeptideFox.xcodeproj`
2. Open Finder: Navigate to `peptidefox-ios/PeptideFox/`
3. Drag these folders into Xcode:
   - `Core/Auth/` → into Xcode's `Core` group
   - `Views/Profile/` → into Xcode's `Views` group
   - `Models/FontSize.swift` → into Xcode's `Models` group
4. Uncheck "Copy items if needed"
5. Check "Add to targets: PeptideFox"
6. Click "Finish"

## 2. Build & Run (1 minute)

In Xcode:
- Press `Cmd+B` to build
- Press `Cmd+R` to run

Or Terminal:
```bash
cd /Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios
xcodebuild -project PeptideFox.xcodeproj -scheme PeptideFox clean build
```

## 3. Test Authentication (2 minutes)

**Register New Account:**
1. Tap Profile tab (5th tab, person icon)
2. Tap "Create Account"
3. Enter email: `test@example.com`
4. Enter password: `password123`
5. Confirm password: `password123`
6. Tap "Create Account"
7. ✅ Settings screen appears

**Test Settings:**
1. Toggle Dark Mode (currently dark-only)
2. Change Font Size (Small/Medium/Large)
3. Tap "About PeptideFox" (navigates to AboutView)

**Sign Out & Sign In:**
1. Tap "Sign Out" (red button)
2. Returns to welcome screen
3. Tap "Sign In"
4. Enter same credentials
5. ✅ Signed in successfully

**Test Persistence:**
1. Force quit app (swipe up in app switcher)
2. Reopen app
3. Navigate to Profile tab
4. ✅ Still signed in, settings preserved

## Files Created

```
PeptideFox/
├── Core/Auth/AuthManager.swift (126 lines)
├── Models/FontSize.swift (29 lines)
└── Views/Profile/
    ├── ProfileView.swift (59 lines)
    ├── UnauthenticatedProfileView.swift (81 lines)
    ├── RegisterView.swift (116 lines)
    ├── SignInView.swift (105 lines)
    └── AuthenticatedProfileView.swift (122 lines)

Modified:
└── Core/Presentation/ContentView.swift (added Profile tab)
```

## Documentation

- `AUTH_IMPLEMENTATION_GUIDE.md` - Full testing checklist & troubleshooting
- `WAVE2_AUTH_SUMMARY.md` - Implementation details
- `AUTH_FLOW_DIAGRAM.md` - Visual flow diagrams
- `verify_auth_files.sh` - File verification script

## Common Issues

**Build Error: "Cannot find 'AuthManager'"**
- Solution: Add `AuthManager.swift` to Xcode target
- Check file is in Project Navigator (left sidebar)

**Sheet Not Presenting**
- Solution: Ensure files are added to target
- Clean build: `Shift+Cmd+K` in Xcode

**Missing Profile Tab**
- Solution: ContentView.swift needs ProfileView import
- Verify ContentView was saved with changes

## Design

All views use protocol theme:
- Background: `#0b1220`
- Accent: `#60a5fa`
- Text: `#e2e8f0`
- Forms: Native iOS with dark theme

## Security Note

Current implementation uses UserDefaults (NOT secure).
For production, migrate to Keychain + backend API.

## Success Criteria

All features implemented:
- ✅ Register/Sign-in/Sign-out
- ✅ Email & password validation
- ✅ Settings (dark mode, font size)
- ✅ Persistence across launches
- ✅ Error handling
- ✅ Dark theme consistent

## Next Steps

Production enhancements:
- Keychain integration
- Backend API connection
- Email verification
- Password reset
- Social sign-in (Sign in with Apple)
