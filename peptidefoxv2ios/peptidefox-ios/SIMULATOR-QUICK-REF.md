# iOS Simulator Quick Reference

## The Golden Rule

**If your changes don't appear in the simulator after building: CLEAN DERIVEDDATA FIRST**

```bash
rm -rf ~/Library/Developer/Xcode/DerivedData/PeptideFox-*
```

## Quick Commands

### Fast Rebuild (Automated)
```bash
./scripts/rebuild-sim.sh          # Incremental build
./scripts/rebuild-sim.sh clean    # Full clean rebuild
```

### Manual Rebuild Process

**Step 1: Clean**
```bash
rm -rf ~/Library/Developer/Xcode/DerivedData/PeptideFox-*
xcodebuild clean -project PeptideFox.xcodeproj -scheme PeptideFox
```

**Step 2: Build**
```bash
xcodebuild build \
  -project PeptideFox.xcodeproj \
  -scheme PeptideFox \
  -configuration Debug \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

**Step 3: Install**
```bash
xcrun simctl install booted \
  ~/Library/Developer/Xcode/DerivedData/PeptideFox-*/Build/Products/Debug-iphonesimulator/PeptideFox.app
```

**Step 4: Launch**
```bash
xcrun simctl launch booted com.peptidefox.app
```

## Common Issues

| Symptom | Solution |
|---------|----------|
| Changes don't appear | Clean DerivedData |
| Build succeeds but UI looks old | Clean rebuild (see above) |
| App crashes on launch | Check console logs |
| Simulator frozen | Restart simulator |
| Build fails with weird errors | Clean DerivedData + restart Xcode |

## Simulator Management

### List Simulators
```bash
xcrun simctl list devices
```

### Boot Simulator
```bash
xcrun simctl boot "iPhone 17 Pro"
```

### Uninstall App
```bash
xcrun simctl uninstall booted com.peptidefox.app
```

### Erase Simulator (Nuclear Option)
```bash
xcrun simctl erase "iPhone 17 Pro"
```

## Debugging

### View Console Logs
```bash
xcrun simctl launch --console booted com.peptidefox.app
```

### Stream Logs
```bash
xcrun simctl spawn booted log stream --predicate 'processImagePath contains "PeptideFox"'
```

### Take Screenshot
```bash
xcrun simctl io booted screenshot ~/Desktop/screenshot.png
```

### Check Timestamps (Verify Fresh Build)
```bash
# Source file time
stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" PeptideFox/Core/Presentation/Calculator/CompoundPickerView.swift

# Binary time (should be NEWER than source)
stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" \
  ~/Library/Developer/Xcode/DerivedData/PeptideFox-*/Build/Products/Debug-iphonesimulator/PeptideFox.app/PeptideFox
```

## Current Configuration

- **Project**: PeptideFox.xcodeproj
- **Scheme**: PeptideFox
- **Bundle ID**: com.peptidefox.app
- **Test Device**: iPhone 17 Pro (F223B876-5B50-4ABE-B792-32F179019217)

## When in Doubt

1. Clean DerivedData
2. Full rebuild
3. Check console logs
4. Ask in team chat

## Documentation

- **Full Guide**: `.claude/simulator-verification-guide.md`
- **Root Cause Analysis**: `.claude/root-cause-analysis.md`
- **Rebuild Script**: `scripts/rebuild-sim.sh`
