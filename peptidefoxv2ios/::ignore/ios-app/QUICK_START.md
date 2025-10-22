# Quick Start Guide

## 🚀 Get Running in 3 Steps

### 1. Install Dependencies
```bash
cd ios-app
bun install
```

### 2. Start Development Server
```bash
bun start
```

### 3. Open on Device
- **iOS Simulator**: Press `i`
- **Physical iPhone**: Scan QR with Expo Go app

---

## 📱 Testing on Your iPhone

1. Install [Expo Go](https://apps.apple.com/app/expo-go/id982107779) from App Store
2. Run `bun start` in terminal
3. Scan the QR code with your iPhone camera
4. App opens in Expo Go automatically

---

## 🔧 Troubleshooting

### "Command not found: bun"
Use npm instead:
```bash
npm install
npm start
```

### "No devices found"
Make sure:
- Xcode is installed (for Simulator)
- iPhone and Mac are on same WiFi (for physical device)

### "Module not found"
Clear cache and reinstall:
```bash
rm -rf node_modules
bun install
bun start --clear
```

---

## 📂 Project Structure

```
ios-app/
├── app/index.tsx       ← Main screen (edit this)
├── utils/data.ts       ← Drug data (add drugs here)
├── utils/calculations.ts ← Math logic
└── types/index.ts      ← TypeScript types
```

---

## 🎨 Customization

### Change a drug's color
Edit `ios-app/utils/data.ts`:
```typescript
color: "blue" // or "emerald" or "purple"
```

### Add a new dose option
Edit `weeklyDoseOptions` in `ios-app/utils/data.ts`:
```typescript
{ value: 3.0, label: "3.0 mg", category: "Custom", protocol: "Week X" }
```

### Modify the UI
Edit `ios-app/app/index.tsx` - all styles are inline at bottom

---

## 🏗️ Building for Production

### Option 1: EAS Build (Recommended)
```bash
npm install -g eas-cli
eas login
eas build --platform ios
```

### Option 2: Expo Build (Classic)
```bash
expo build:ios
```

### Option 3: Local Build (Advanced)
```bash
npx expo prebuild
npx expo run:ios
```

---

## 📊 What Works

✅ All 3 GLP-1 drugs (Sema, Tirz, Reta)
✅ 4 dosing frequencies
✅ Real-time calculations
✅ Stability metrics
✅ Drug warnings

---

## 🔮 Future Features (Not Yet Implemented)

- Graphs/charts
- Dose scheduling
- Push notifications
- Dark mode
- Data export

---

## 💡 Tips

1. **Hot Reload**: Edit code → Save → App updates instantly
2. **Debug Menu**: Shake device or Cmd+D (Simulator)
3. **Logs**: Check terminal for console.log output
4. **Offline**: App works without internet after first load

---

## 🆘 Need Help?

- [Expo Docs](https://docs.expo.dev)
- [React Native Docs](https://reactnative.dev)
- Check `ios-app/README.md` for detailed setup
- Check `ios-app/OVERVIEW.md` for architecture details
