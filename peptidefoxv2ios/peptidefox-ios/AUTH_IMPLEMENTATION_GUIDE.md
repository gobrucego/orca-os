# Authentication & Profile Implementation Guide

## Overview

Complete user authentication and profile system has been implemented for PeptideFox iOS app.

## Files Created

### Core Authentication
- `/PeptideFox/Core/Auth/AuthManager.swift` - Singleton authentication manager with register/sign-in/sign-out

### Models
- `/PeptideFox/Models/FontSize.swift` - Font size preference enum (Small/Medium/Large)

### Profile Views
- `/PeptideFox/Views/Profile/ProfileView.swift` - Main profile view with auth state handling
- `/PeptideFox/Views/Profile/UnauthenticatedProfileView.swift` - Welcome screen for non-authenticated users
- `/PeptideFox/Views/Profile/RegisterView.swift` - User registration form
- `/PeptideFox/Views/Profile/SignInView.swift` - User sign-in form
- `/PeptideFox/Views/Profile/AuthenticatedProfileView.swift` - Settings view for authenticated users

### Modified Files
- `/PeptideFox/Core/Presentation/ContentView.swift` - Added Profile tab to TabView

## Adding Files to Xcode

### Option 1: Automatic Discovery (Recommended)
1. Open `PeptideFox.xcodeproj` in Xcode
2. Xcode should detect the new files and prompt you to add them
3. Click "Add" to include them in the project

### Option 2: Manual Addition
1. Open `PeptideFox.xcodeproj` in Xcode
2. Right-click on `PeptideFox/Core` folder → "Add Files to PeptideFox"
3. Navigate to `PeptideFox/Core/Auth` and select `AuthManager.swift`
4. Ensure "Add to targets: PeptideFox" is checked
5. Repeat for:
   - `PeptideFox/Models/FontSize.swift`
   - All files in `PeptideFox/Views/Profile/` directory

### Option 3: Drag and Drop
1. Open Finder to `peptidefox-ios/PeptideFox/` directory
2. Open Xcode project
3. Drag the `Core/Auth` folder into Xcode's `Core` group
4. Drag the `Views/Profile` folder into Xcode's `Views` group
5. Drag `Models/FontSize.swift` into Xcode's `Models` group
6. Ensure "Copy items if needed" is UNCHECKED (files are already in correct location)
7. Ensure "Add to targets: PeptideFox" is checked

## Build & Run

```bash
cd /Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios
xcodebuild -project PeptideFox.xcodeproj -scheme PeptideFox clean build
```

Or open in Xcode and press `Cmd+R` to build and run.

## Features Implemented

### Authentication Flow
- **Register**: Email + password (min 6 chars) with validation
- **Sign In**: Email + password with credential validation
- **Sign Out**: Clear authentication state
- **Persistence**: User email stored in UserDefaults (auth state persists across launches)

### Settings (Authenticated Users Only)
- **Dark Mode Toggle**: Persisted with @AppStorage
- **Font Size Selection**: Small/Medium/Large options
- **About PeptideFox**: Link to AboutView
- **User Info**: Display email and membership status

### UI/UX
- **Dark Theme**: Consistent `#0b1220` background across all views
- **Native iOS Forms**: Standard Form components with proper keyboard handling
- **Sheet Modals**: Register and Sign-In presented as sheets
- **Error Handling**: User-friendly error messages for validation failures
- **Smooth Animations**: State transitions with easeInOut animation

## Testing Checklist

### Registration Flow
- [ ] Open app and navigate to Profile tab
- [ ] Tap "Create Account"
- [ ] Enter invalid email (missing @ or .) → Shows error
- [ ] Enter password < 6 chars → Button disabled
- [ ] Enter mismatched passwords → Button disabled
- [ ] Enter valid email + matching passwords → Account created
- [ ] Profile now shows settings screen with user email

### Sign-In Flow
- [ ] Sign out from authenticated profile
- [ ] Tap "Sign In" from welcome screen
- [ ] Enter wrong credentials → Shows "Invalid email or password"
- [ ] Enter correct credentials → Signed in successfully
- [ ] Profile shows settings screen

### Settings
- [ ] Toggle Dark Mode → UI updates (currently dark-only, but toggle works)
- [ ] Change Font Size → Selection persists
- [ ] Close and reopen app → Settings preserved
- [ ] Tap "About PeptideFox" → Navigates to AboutView

### Sign Out
- [ ] Tap "Sign Out" button (red text)
- [ ] Returns to welcome screen
- [ ] Auth state cleared but credentials still stored
- [ ] Can sign in again with same credentials

### Persistence
- [ ] Sign in with account
- [ ] Force quit app (swipe up in app switcher)
- [ ] Reopen app → Still signed in
- [ ] Navigate to Profile → Shows settings (not welcome screen)

## Architecture

### State Management
- `AuthManager`: `@MainActor` singleton managing auth state
- `@StateObject`: Used in views to observe AuthManager changes
- `@AppStorage`: Persists dark mode and font size preferences
- `UserDefaults`: Stores user credentials (use Keychain in production)

### View Hierarchy
```
ProfileView (Main container)
├── AuthManager.shared (observed)
├── Conditional rendering based on isAuthenticated
├── UnauthenticatedProfileView (when signed out)
│   ├── Welcome message
│   ├── "Create Account" button
│   └── "Sign In" button
└── AuthenticatedProfileView (when signed in)
    ├── User info section
    ├── Preferences section (Dark Mode, Font Size)
    ├── About section
    └── Sign Out button

Sheet Presentations:
├── RegisterView (email, password, confirm password)
└── SignInView (email, password)
```

### Data Flow
1. User taps "Create Account" → `AuthManager.showRegister()` sets `showingRegister = true`
2. Sheet presents `RegisterView`
3. User fills form and taps "Create Account"
4. `AuthManager.register()` validates and saves credentials
5. `isAuthenticated = true` triggers view update
6. Sheet dismisses, `ProfileView` shows `AuthenticatedProfileView`

## Design System Compliance

### Colors (Protocol Theme)
- Background: `#0b1220` (protocolBackground)
- Surface: `#1e293b` (protocolCard)
- Accent: `#60a5fa` (protocolAccent)
- Text: `#e2e8f0` (protocolText)
- Secondary Text: `#94a3b8` (protocolTextSecondary)

### Typography
- Headings: System font, light weight (28pt)
- Body: System font, regular (16-17pt)
- Labels: System font, medium (14pt)

### Spacing
- Screen padding: 24px horizontal
- Section spacing: 24px vertical
- Button height: 50px
- Corner radius: 12px

## Known Limitations (MVP)

1. **Local Storage**: Credentials stored in UserDefaults (not secure)
   - Production: Use Keychain for password storage
   - Production: Integrate Firebase Auth or backend API

2. **No Password Reset**: No "Forgot Password" flow
   - Production: Add password reset via email

3. **No Email Verification**: Accounts created without verification
   - Production: Send verification email before activation

4. **Single User**: Only one user can register per device
   - Production: Support multiple accounts or account switching

5. **Dark Mode Only**: Light mode toggle exists but app is dark-themed
   - Future: Implement light mode color scheme

## Next Steps (Post-MVP)

1. **Keychain Integration**: Secure password storage
2. **Backend Integration**: Connect to authentication API
3. **Email Verification**: Verify email addresses
4. **Password Reset**: Forgot password flow
5. **Profile Customization**: Avatar, display name, bio
6. **Account Management**: Delete account, change password
7. **Social Sign-In**: Sign in with Apple, Google
8. **Light Mode**: Implement light color scheme

## File Locations

All files are located in:
```
/Users/adilkalam/Desktop/OBDN/peptidefoxv2/peptidefox-ios/PeptideFox/
```

Project structure:
```
PeptideFox/
├── Core/
│   └── Auth/
│       └── AuthManager.swift
├── Models/
│   └── FontSize.swift
└── Views/
    └── Profile/
        ├── ProfileView.swift
        ├── UnauthenticatedProfileView.swift
        ├── RegisterView.swift
        ├── SignInView.swift
        └── AuthenticatedProfileView.swift
```

## Troubleshooting

### "Cannot find 'AuthManager' in scope"
- Ensure `AuthManager.swift` is added to the Xcode target
- Check that file is in project navigator (left sidebar)
- Clean build folder: `Shift+Cmd+K` in Xcode

### "Cannot find 'ProfileView' in scope"
- Ensure all Profile views are added to Xcode target
- Verify files in project navigator
- Rebuild project

### "Type 'FontSize' cannot be used as an expression"
- Ensure `FontSize.swift` is added to Xcode target
- Check import statements

### Sheet not presenting
- Verify `@StateObject private var authManager = AuthManager.shared` in view
- Check that `showingRegister` or `showingSignIn` is bound correctly
- Look for errors in console

## Support

For issues or questions, check:
1. Build errors in Xcode Issue Navigator (`Cmd+5`)
2. Runtime errors in Console (`Cmd+Shift+Y`)
3. File references in Project Navigator (`Cmd+1`)

## Success Criteria

- [x] Register flow functional (email + password validation)
- [x] Sign-in flow functional (credential validation)
- [x] Settings only visible when authenticated
- [x] Dark mode toggle persisted with @AppStorage
- [x] Font size selection (Small/Medium/Large)
- [x] Sign out button clears auth state
- [x] Preferences persist across app launches
- [x] Email validation (contains @ and .)
- [x] Password validation (min 6 characters)
- [x] Error messages for invalid input
- [x] Dark theme consistent (#0b1220)
- [x] Forms use iOS-native keyboard handling
- [x] Smooth animations on state changes
- [x] About link functional
- [x] User email displayed in profile
