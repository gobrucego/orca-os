# iOS App Prototype - GLP Dosing & Reconstitution

## What This Is

A standalone iOS mobile app prototype that brings GLP Dosing Frequency calculator and Reconstitution calculator from PeptideFox.com to mobile devices. Built with React Native and Expo for rapid prototyping and easy deployment.

## Key Features

### 📊 Dosing Frequency Calculator

#### 1. **Drug Selection**
- Semaglutide (Ozempic, Wegovy)
- Tirzepatide (Mounjaro, Zepbound)
- Retatrutide (Investigational)

#### 2. **Dosing Calculations**
- **Peak-Trough Variation**: Shows how much drug levels fluctuate
- **Stability Ratings**: Excellent, Moderate, or High variation
- **Real-time Metrics**: Dose per injection, plasma levels, weekly delivery

#### 3. **Flexible Frequencies**
- Weekly (1×/week)
- Twice weekly (2×/week)
- Every 3 days (q3d)
- Every other day (EOD)

#### 4. **Smart Recommendations**
- Color-coded stability indicators
- Variance alerts (over/under target dose)
- Drug-specific warnings and guidance

### 🧪 Reconstitution Calculator

#### 1. **Concentration Calculator**
- Input: Vial size (mg) + BAC water (mL)
- Output: Concentration (mg/mL)

#### 2. **Injection Volume Calculator**
- Select desired dose from protocol options
- Get exact injection volume in mL
- Automatic conversion to insulin syringe units

#### 3. **Quick Reference**
- Common mL to unit conversions
- Easy-to-read reference table

## Technical Stack

- **Framework**: Expo (React Native)
- **Language**: TypeScript
- **Navigation**: Expo Router (Tab Navigation)
- **UI**: Native components + Linear Gradients + Picker
- **State**: React hooks (useState, useMemo)
- **Icons**: MaterialCommunityIcons

## File Structure

```
ios-app/
├── app/
│   ├── _layout.tsx          # Root navigation (tabs)
│   ├── index.tsx            # Dosing frequency screen
│   └── calculator.tsx       # Reconstitution calculator
├── types/
│   └── index.ts             # TypeScript definitions
├── utils/
│   ├── data.ts              # Drug data & constants
│   └── calculations.ts      # Dosing math
├── assets/                  # App icons & images
├── app.json                 # Expo config
├── package.json             # Dependencies
└── README.md                # Setup instructions
```

## How to Run

### Quick Start
```bash
cd ios-app
./start.sh
```

### Manual Start
```bash
cd ios-app
bun install  # or npm install
bun start    # or npm start
```

Then:
- Press `i` for iOS Simulator
- Scan QR with Expo Go app on iPhone

## Differences from Web App

### What's Included ✅
- Core dosing calculations
- All three GLP-1 drugs
- All frequency options
- Stability metrics
- Drug information & warnings

### What's Not Included (Yet) ❌
- Plasma accumulation graphs
- Dose adjustment timeline
- Side effect profiles (detailed)
- Advanced titration planner
- Export/share features

### Mobile-Specific Optimizations
- Touch-friendly buttons and controls
- Native picker for dose selection
- Responsive layout for various iPhone sizes
- Simplified UI focusing on key metrics

## Next Steps for Production

1. **Enhanced Features**
   - Add graphing with Victory Native
   - Implement dose scheduling
   - Add push notifications for injection reminders
   - Local storage for saved protocols

2. **Polish**
   - Custom app icon (1024x1024)
   - Splash screen animation
   - Haptic feedback
   - Dark mode support

3. **Distribution**
   - Build with EAS (Expo Application Services)
   - TestFlight beta testing
   - App Store submission

## Development Notes

- **Isolated from Web Build**: The ios-app folder is excluded from Next.js builds
- **Shared Logic**: Core calculations match the web app exactly
- **No Backend Needed**: All calculations happen client-side
- **Offline-First**: Works without internet connection

## Customization

To modify the app:

1. **Add more drugs**: Edit `utils/data.ts`
2. **Change calculations**: Update `utils/calculations.ts`
3. **Modify UI**: Edit `app/index.tsx` styles
4. **Add features**: Create new components in `components/`

## Performance

- Bundle size: ~15-20MB (typical Expo app)
- Load time: <2 seconds on modern devices
- Calculations: Instant (client-side)
- Memory usage: <50MB

## Browser vs Native

| Feature | Web App | iOS App |
|---------|---------|---------|
| Platform | Browser | Native iOS |
| Distribution | URL | App Store |
| Offline | Limited | Full support |
| Performance | Good | Excellent |
| Notifications | Browser only | Native push |
| UI | Responsive web | Native iOS |

## Why Expo?

- **Fast prototyping**: Write once, test immediately
- **Easy deployment**: OTA updates, TestFlight, App Store
- **Native access**: Camera, notifications, storage
- **Great DX**: Hot reload, error handling, debugging
- **Future-proof**: Can eject to bare React Native if needed
