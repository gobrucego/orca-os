# Authentication Flow Diagram

## View State Machine

```
┌─────────────────────────────────────────────────────────────┐
│                        ProfileView                          │
│                  (Main Container)                           │
│                                                             │
│  Observes: AuthManager.shared                               │
│  Storage: @AppStorage("isDarkMode")                         │
│           @AppStorage("fontSize")                           │
└─────────────────┬───────────────────────────────────────────┘
                  │
                  │ if authManager.isAuthenticated
                  │
        ┌─────────▼─────────┐
        │                   │
        │                   │
    NOT AUTHENTICATED   AUTHENTICATED
        │                   │
        │                   │
        ▼                   ▼
┌───────────────────┐  ┌──────────────────────┐
│ Unauthenticated   │  │ Authenticated        │
│ ProfileView       │  │ ProfileView          │
│                   │  │                      │
│ - App Icon        │  │ - User Email         │
│ - Welcome Message │  │ - Member Status      │
│ - Create Account  │  │ - Dark Mode Toggle   │
│ - Sign In         │  │ - Font Size Picker   │
└───────┬───────────┘  │ - About Link         │
        │              │ - Sign Out Button    │
        │              └──────────┬───────────┘
        │                         │
        │                         │ onSignOut
        └─────────────────────────┘
                  │
                  └─ authManager.signOut()
                     → isAuthenticated = false
                     → Cycle back to Unauthenticated
```

## Registration Flow

```
┌─────────────────────────────────────────────────┐
│ User taps "Create Account"                      │
└────────────┬────────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────────┐
│ authManager.showRegister()                      │
│ → showingRegister = true                        │
└────────────┬────────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────────┐
│ Sheet presents RegisterView                     │
│                                                 │
│  ┌─────────────────────────────────────────┐   │
│  │ Email Field                              │   │
│  │ Password Field                           │   │
│  │ Confirm Password Field                   │   │
│  │                                          │   │
│  │ [Validation]                             │   │
│  │ - Email contains @ and .                 │   │
│  │ - Password length >= 6                   │   │
│  │ - Passwords match                        │   │
│  │                                          │   │
│  │ [Create Account] (disabled if invalid)   │   │
│  └─────────────────────────────────────────┘   │
└────────────┬────────────────────────────────────┘
             │
             │ User taps Create Account
             ▼
┌─────────────────────────────────────────────────┐
│ authManager.register(email, password)           │
│                                                 │
│ Validation:                                     │
│  ✓ Email format valid?                          │
│  ✓ Password length >= 6?                        │
│  ✓ User already exists?                         │
│                                                 │
│ If valid:                                       │
│  - Save to UserDefaults                         │
│  - isAuthenticated = true                       │
│  - userEmail = email                            │
│  - showingRegister = false                      │
│  - Sheet dismisses                              │
│                                                 │
│ If invalid:                                     │
│  - Show error message                           │
│  - Stay on RegisterView                         │
└────────────┬────────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────────┐
│ ProfileView re-renders                          │
│ → Shows AuthenticatedProfileView                │
└─────────────────────────────────────────────────┘
```

## Sign-In Flow

```
┌─────────────────────────────────────────────────┐
│ User taps "Sign In"                             │
└────────────┬────────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────────┐
│ authManager.showSignIn()                        │
│ → showingSignIn = true                          │
└────────────┬────────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────────┐
│ Sheet presents SignInView                       │
│                                                 │
│  ┌─────────────────────────────────────────┐   │
│  │ Email Field                              │   │
│  │ Password Field                           │   │
│  │                                          │   │
│  │ [Sign In] (disabled if empty)            │   │
│  └─────────────────────────────────────────┘   │
└────────────┬────────────────────────────────────┘
             │
             │ User taps Sign In
             ▼
┌─────────────────────────────────────────────────┐
│ authManager.signIn(email, password)             │
│                                                 │
│ Validation:                                     │
│  ✓ Credentials match stored values?             │
│                                                 │
│ If valid:                                       │
│  - isAuthenticated = true                       │
│  - userEmail = email                            │
│  - showingSignIn = false                        │
│  - Sheet dismisses                              │
│                                                 │
│ If invalid:                                     │
│  - Show "Invalid email or password"             │
│  - Stay on SignInView                           │
└────────────┬────────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────────┐
│ ProfileView re-renders                          │
│ → Shows AuthenticatedProfileView                │
└─────────────────────────────────────────────────┘
```

## Settings Persistence

```
┌─────────────────────────────────────────────────┐
│ AuthenticatedProfileView                        │
│                                                 │
│  @AppStorage("isDarkMode")                      │
│  @AppStorage("fontSize")                        │
└────────────┬────────────────────────────────────┘
             │
             │ User toggles Dark Mode
             ▼
┌─────────────────────────────────────────────────┐
│ isDarkMode = !isDarkMode                        │
│ → Automatically saved to UserDefaults           │
│ → Persists across app launches                  │
└─────────────────────────────────────────────────┘
             │
             │ User changes Font Size
             ▼
┌─────────────────────────────────────────────────┐
│ fontSize = "Large"                              │
│ → Automatically saved to UserDefaults           │
│ → Persists across app launches                  │
└─────────────────────────────────────────────────┘
```

## Data Storage

```
UserDefaults Keys:
┌─────────────────────────────────────────────────┐
│ "peptidefox.auth.user"     → User email         │
│ "peptidefox.auth.password" → Password (INSECURE)│
│ "isDarkMode"               → Bool               │
│ "fontSize"                 → String (enum raw)  │
└─────────────────────────────────────────────────┘

AuthManager @Published Properties:
┌─────────────────────────────────────────────────┐
│ isAuthenticated  → Bool (drives UI state)       │
│ userEmail        → String? (displayed in UI)    │
│ showingRegister  → Bool (sheet presentation)    │
│ showingSignIn    → Bool (sheet presentation)    │
└─────────────────────────────────────────────────┘
```

## Tab Navigation

```
ContentView TabView
┌─────────────────────────────────────────────────┐
│                                                 │
│  Tab 0: CalculatorView        (function)        │
│  Tab 1: PeptideLibraryView    (books.vertical)  │
│  Tab 2: GLPJourneyView        (waveform.path)   │
│  Tab 3: ProtocolOutputView    (list.clipboard)  │
│  Tab 4: ProfileView ← NEW!    (person.circle)   │
│                                                 │
└─────────────────────────────────────────────────┘
```

## App Launch Behavior

```
┌─────────────────────────────────────────────────┐
│ App Launches                                    │
└────────────┬────────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────────┐
│ AuthManager.init() called                       │
│                                                 │
│ Check UserDefaults:                             │
│  if savedEmail exists:                          │
│    isAuthenticated = true                       │
│    userEmail = savedEmail                       │
│  else:                                          │
│    isAuthenticated = false                      │
└────────────┬────────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────────┐
│ ContentView renders with auth state             │
└────────────┬────────────────────────────────────┘
             │
             ▼
     ┌───────┴────────┐
     │                │
SIGNED IN        SIGNED OUT
     │                │
     ▼                ▼
Shows Settings   Shows Welcome
  Screen           Screen
```

## Error Handling

```
Registration Errors:
┌─────────────────────────────────────────────────┐
│ AuthError.invalidEmail                          │
│  → "Please enter a valid email address"         │
│                                                 │
│ AuthError.weakPassword                          │
│  → "Password must be at least 6 characters"     │
│                                                 │
│ AuthError.userAlreadyExists                     │
│  → "An account with this email already exists"  │
└─────────────────────────────────────────────────┘

Sign-In Errors:
┌─────────────────────────────────────────────────┐
│ AuthError.invalidCredentials                    │
│  → "Invalid email or password"                  │
└─────────────────────────────────────────────────┘

Display:
- Error message shown in red text below form
- Form remains visible
- User can correct and retry
```

## State Transitions

```
┌────────────┐
│   Start    │
│ (Unsigned) │
└─────┬──────┘
      │
      │ Register/Sign In
      ▼
┌────────────┐
│  Signed In │
│ (Settings) │
└─────┬──────┘
      │
      │ Sign Out
      ▼
┌────────────┐
│   Start    │
│ (Welcome)  │
└────────────┘

Notes:
- Credentials persist after sign out
- Can sign in again without re-registering
- Force quit preserves auth state
- Auth state checked on app launch
```
