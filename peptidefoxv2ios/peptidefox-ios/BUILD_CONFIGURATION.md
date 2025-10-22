# Build Configuration Guide

## Xcode Project Settings

### Bundle Information
- **Product Name**: PeptideFox
- **Bundle Identifier**: `com.peptidefox.ios` (change to your registered ID)
- **Display Name**: PeptideFox
- **Marketing Version**: 1.0.0
- **Build Number**: 1 (increment for each TestFlight upload)

### Deployment
- **iOS Deployment Target**: 17.0
- **Supported Devices**: iPhone, iPad
- **Supported Orientations**:
  - iPhone: Portrait, Landscape Left, Landscape Right
  - iPad: All orientations

### Swift Configuration
- **Swift Language Version**: 6.0
- **Swift Compiler - Code Generation**:
  - Optimization Level (Release): -O
  - Compilation Mode: Whole Module
- **Swift Compiler - Custom Flags**:
  - Enable Strict Concurrency: Yes

### Build Settings (Release Configuration)

#### Code Signing
```
Code Signing Style: Automatic (recommended)
Development Team: [Your Team ID]
Provisioning Profile: Automatic
Code Sign Identity: Apple Development (Debug) / Apple Distribution (Release)
```

#### Optimization
```
Optimization Level: -O (Fastest, Smallest)
Swift Compilation Mode: Whole Module Optimization
Enable Testability: NO (Release only)
Strip Debug Symbols: YES (Release only)
Strip Swift Symbols: YES (Release only)
Dead Code Stripping: YES
```

#### Linking
```
Enable Bitcode: NO (deprecated in Xcode 14+)
Link-Time Optimization: YES (Release only)
```

#### Search Paths
```
Framework Search Paths: $(inherited)
Header Search Paths: $(inherited)
Library Search Paths: $(inherited)
```

#### Architectures
```
Build Active Architecture Only: NO (Release)
Supported Platforms: iOS
Architectures: arm64 (iOS devices)
Excluded Architectures (Simulator): i386, x86_64
```

### Capabilities

Enable in Signing & Capabilities tab:

#### Currently Enabled
- [x] SwiftUI App Lifecycle

#### Optional (Enable if needed)
- [ ] iCloud (for cross-device sync)
  - [ ] CloudKit
  - [ ] Key-value storage
- [ ] Push Notifications (for dose reminders)
- [ ] Background Modes
  - [ ] Background fetch (for protocol reminders)
- [ ] HealthKit (for health data integration)
- [ ] App Groups (for widget data sharing)

### Info.plist Configuration

Key settings already configured:
```xml
CFBundleDisplayName: PeptideFox
LSApplicationCategoryType: public.app-category.healthcare-fitness
NSPhotoLibraryUsageDescription: [Photo library access for screenshots]
NSCameraUsageDescription: [Camera access for barcode scanning]
UIApplicationSceneManifest: [Multi-scene support]
UISupportedInterfaceOrientations: [Portrait, Landscape]
```

## Build Schemes

### Debug Scheme
- **Build Configuration**: Debug
- **Optimization**: -Onone
- **Enable Testability**: YES
- **Run Destination**: Any iOS Simulator
- **Purpose**: Development and testing

### Release Scheme
- **Build Configuration**: Release
- **Optimization**: -O
- **Enable Testability**: NO
- **Run Destination**: Any iOS Device (arm64)
- **Purpose**: TestFlight and App Store submission

## Build Commands

### Clean Build
```bash
# In Xcode
Product → Clean Build Folder
# Or keyboard shortcut: Cmd+Shift+K
```

### Build for Testing (Simulator)
```bash
# In Xcode
Product → Build
# Or keyboard shortcut: Cmd+B

# Command line
xcodebuild -project PeptideFox.xcodeproj -scheme PeptideFox -configuration Debug -sdk iphonesimulator
```

### Archive for Distribution
```bash
# In Xcode (REQUIRED for TestFlight/App Store)
1. Select "Any iOS Device (arm64)" as destination
2. Product → Archive
3. Wait for archive to complete
4. Archives window opens automatically

# Command line (advanced)
xcodebuild archive \
  -project PeptideFox.xcodeproj \
  -scheme PeptideFox \
  -configuration Release \
  -archivePath ./build/PeptideFox.xcarchive
```

### Validate Archive
```bash
# In Xcode Organizer
1. Window → Organizer
2. Select Archives tab
3. Select your archive
4. Click "Validate App"
5. Choose distribution method: App Store Connect
6. Select distribution certificate and provisioning profile
7. Click "Validate"
8. Wait for validation (may take several minutes)
```

### Upload to App Store Connect
```bash
# In Xcode Organizer
1. After successful validation
2. Click "Distribute App"
3. Choose "App Store Connect"
4. Choose "Upload"
5. Select distribution options:
   - Upload symbols: YES (for crash reports)
   - Manage Version and Build Number: YES (automatic)
6. Review archive content
7. Click "Upload"
8. Wait for upload (may take 10-30 minutes)

# You'll receive email when processing completes
```

## Version and Build Number Management

### Marketing Version (User-Facing)
```
Format: MAJOR.MINOR.PATCH
Example: 1.0.0

1.0.0 - Initial release
1.0.1 - Hotfix
1.1.0 - New features
2.0.0 - Major update
```

### Build Number (Internal)
```
Format: Integer, increment for each upload
Example: 1, 2, 3, 4...

Rules:
- Must be greater than previous build for same version
- Can use date-based: 20251020 (YYYYMMDD)
- Can use sequential: 1, 2, 3, 4...
- TestFlight requires unique build numbers
```

### Updating Version Numbers

#### Method 1: Xcode UI
```
1. Select PeptideFox target
2. General tab
3. Update "Version" (Marketing Version)
4. Update "Build" (Current Project Version)
```

#### Method 2: Info.plist
```xml
<key>CFBundleShortVersionString</key>
<string>1.0.0</string>
<key>CFBundleVersion</key>
<string>1</string>
```

#### Method 3: Build Settings
```
Project Settings → Build Settings → Versioning

MARKETING_VERSION = 1.0.0
CURRENT_PROJECT_VERSION = 1
```

## Code Signing Setup

### Automatic Signing (Recommended)
```
1. Select PeptideFox target
2. Signing & Capabilities tab
3. Enable "Automatically manage signing"
4. Select your Team from dropdown
5. Xcode handles certificates and provisioning profiles
```

### Manual Signing (Advanced)
```
1. Create App ID on developer.apple.com
   - Identifier: com.peptidefox.ios
   - Description: PeptideFox
   - Capabilities: (none required initially)

2. Create Distribution Certificate
   - Apple Developer → Certificates
   - Create Distribution Certificate
   - Download and install in Keychain

3. Create Provisioning Profile
   - Apple Developer → Profiles
   - App Store Distribution Profile
   - Select App ID and Certificate
   - Download and install

4. In Xcode:
   - Disable "Automatically manage signing"
   - Select certificate and provisioning profile manually
```

## Troubleshooting Build Issues

### Issue: "No signing certificate found"
**Solution**:
```
1. Xcode → Preferences → Accounts
2. Select your Apple ID
3. Click "Download Manual Profiles"
4. Or enable "Automatically manage signing"
```

### Issue: "Code signing entitlements error"
**Solution**:
```
1. Check entitlements file matches capabilities
2. Verify App ID has required capabilities enabled
3. Regenerate provisioning profile
```

### Issue: "Architecture arm64 error"
**Solution**:
```
1. Build Settings → Architectures
2. Set to: arm64
3. Excluded Architectures (Simulator): i386, x86_64
4. Clean build folder (Cmd+Shift+K)
```

### Issue: "Swift compiler error"
**Solution**:
```
1. Build Settings → Swift Compiler - Language
2. Swift Language Version: 6.0
3. Clean build folder
4. Restart Xcode
```

### Issue: "Missing App Icon"
**Solution**:
```
1. Add icon-1024.png to Assets.xcassets/AppIcon.appiconset/
2. Verify Contents.json references icon-1024.png
3. Clean build folder
```

### Issue: "Archive fails"
**Solution**:
```
1. Select "Any iOS Device (arm64)" (not Simulator)
2. Ensure Release configuration selected
3. Check for compilation errors in Release mode
4. Clean build folder and retry
```

## Pre-Archive Checklist

Before creating archive for TestFlight:
- [ ] Version number updated (e.g., 1.0.0)
- [ ] Build number incremented (e.g., 1 → 2)
- [ ] Scheme set to Release configuration
- [ ] "Any iOS Device (arm64)" selected as destination
- [ ] Code signing configured correctly
- [ ] All compilation errors resolved
- [ ] All compilation warnings reviewed
- [ ] App icon present (icon-1024.png)
- [ ] Info.plist privacy descriptions complete
- [ ] PrivacyInfo.xcprivacy included in target
- [ ] LaunchScreen.storyboard configured
- [ ] Clean build folder executed

## Build Size Optimization

### Current App Size (Estimated)
```
Download size: ~5-15 MB
Installed size: ~20-40 MB
```

### Optimization Techniques
```
1. Enable Link-Time Optimization (LTO)
   Build Settings → Optimization Level → -O
   
2. Strip Debug Symbols (Release only)
   Build Settings → Strip Debug Symbols → YES
   
3. Strip Swift Symbols (Release only)
   Build Settings → Strip Swift Symbols → YES
   
4. Optimize Images
   - Use asset catalogs
   - Enable compression
   - Use appropriate resolutions
   
5. Remove Unused Code
   - Enable Dead Code Stripping
   - Remove unused assets
   - Remove debug print statements
```

## Continuous Integration (Future)

### Xcode Cloud Setup (Recommended)
```
1. Product → Xcode Cloud → Create Workflow
2. Configure build triggers (on commit, on tag, manual)
3. Set environment variables
4. Configure test plans
5. Set up automatic TestFlight distribution
```

### Fastlane Setup (Alternative)
```ruby
# Fastfile
lane :beta do
  increment_build_number
  build_app(scheme: "PeptideFox")
  upload_to_testflight
end

lane :release do
  increment_build_number
  build_app(scheme: "PeptideFox")
  upload_to_app_store
end
```

## Environment Variables

No environment variables required for current build.

Future considerations:
- API keys for backend (if added)
- Analytics tokens (if added)
- Feature flags (if added)

## Build Performance

### Typical Build Times
```
Clean Build (Debug): 30-60 seconds
Incremental Build: 5-15 seconds
Archive (Release): 60-120 seconds
```

### Speeding Up Builds
```
1. Use Whole Module Optimization (Release only)
2. Increase Build Active Architecture Only (Debug)
3. Disable unnecessary build phases
4. Use precompiled headers (if applicable)
5. Close other apps during build
```

## Xcode Version Requirements

### Minimum Xcode Version
```
Xcode 15.0 or later
macOS 13.5 (Ventura) or later
```

### Recommended Xcode Version
```
Xcode 16.0 (for Swift 6.0 support)
macOS 15.0 (Sequoia) or later
```

### Command Line Tools
```bash
# Verify Xcode command line tools
xcode-select --print-path

# Install if missing
xcode-select --install
```

## Next Steps

1. **Configure Team**: Set your Apple Developer Team in Xcode
2. **Update Bundle ID**: Change to your registered bundle identifier
3. **Create Icon**: Add 1024x1024 app icon
4. **Test Build**: Build and run on simulator
5. **Archive**: Create archive for TestFlight
6. **Validate**: Validate archive in Organizer
7. **Upload**: Upload to App Store Connect
8. **TestFlight**: Configure TestFlight and invite testers

---

**Last Updated**: 2025-10-20
**Xcode Version**: 16.0
**iOS Deployment Target**: 17.0
**Swift Version**: 6.0
