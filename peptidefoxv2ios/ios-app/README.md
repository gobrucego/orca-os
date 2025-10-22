# Peptide Fox - GLP Dosing iOS App

A mobile prototype featuring GLP Dosing Frequency calculator and Reconstitution calculator, built with React Native and Expo.

## Features

### 📊 Dosing Frequency Calculator
- **Multi-drug support**: Semaglutide, Tirzepatide, and Retatrutide
- **Flexible dosing frequencies**: Weekly, twice weekly, every 3 days, or every other day
- **Real-time calculations**:
  - Peak-to-trough variation
  - Dose per injection
  - Weekly plasma levels
  - Stability metrics
- **Drug-specific information**: Half-life, warnings, and protocol guidance

### 🧪 Reconstitution Calculator
- **Concentration calculator**: Calculate mg/mL based on vial size and BAC water
- **Injection volume calculator**: Determine exact volume for desired dose
- **Unit conversion**: Automatic conversion to insulin syringe units
- **Quick reference**: Common volume-to-unit conversions

## Setup Instructions

### Prerequisites

- Node.js 18+ or Bun
- iOS Simulator (Xcode) or physical iOS device
- Expo Go app (for physical device testing)

### Installation

1. Navigate to the ios-app directory:
   ```bash
   cd ios-app
   ```

2. Install dependencies:
   ```bash
   npm install
   # or
   bun install
   ```

3. Start the development server:
   ```bash
   npm start
   # or
   bun start
   ```

4. Run on iOS:
   - Press `i` to open in iOS Simulator
   - Or scan the QR code with your iPhone using the Expo Go app

### Building for Production

To create a standalone iOS app:

```bash
# Install EAS CLI
npm install -g eas-cli

# Login to Expo
eas login

# Configure the build
eas build:configure

# Create iOS build
eas build --platform ios
```

## Project Structure

```
ios-app/
├── app/                 # Expo Router app directory
│   ├── _layout.tsx     # Root layout with tab navigation
│   ├── index.tsx       # Dosing frequency screen
│   └── calculator.tsx  # Reconstitution calculator screen
├── components/         # Reusable components (future)
├── types/             # TypeScript type definitions
├── utils/             # Utility functions
│   ├── calculations.ts # Dosing calculations
│   └── data.ts        # Drug data and constants
├── assets/            # Images and icons
├── app.json           # Expo configuration
├── package.json       # Dependencies
└── tsconfig.json      # TypeScript config
```

## How It Works

### Dosing Frequency Calculator

Calculates optimal dosing schedules based on:

1. **Drug pharmacokinetics**: Each GLP-1 drug has a specific half-life and elimination rate
2. **Dosing frequency**: Users can choose how often to inject
3. **Weekly dose target**: Standard protocol doses for each drug

Shows:
- **Peak-Trough %**: How much drug levels fluctuate between injections
- **Stability rating**: Excellent (<30%), Moderate (30-75%), or High (>75%) variation
- **Dose per injection**: Exact amount to inject each time
- **Plasma levels**: Predicted peak and trough concentrations

### Reconstitution Calculator

Helps prepare your peptide vials:

1. **Enter vial size** (mg) and **BAC water** (mL) → Get concentration (mg/mL)
2. **Select desired dose** → Get exact injection volume (mL and units)
3. **Quick reference table** for common conversions

## Customization

- Add more drugs in `utils/data.ts`
- Modify calculations in `utils/calculations.ts`
- Customize UI colors and styles in `app/index.tsx` and `app/calculator.tsx`

## Notes

- This app is isolated from the main PeptideFox web build
- It uses the same core logic as the web app
- All calculations happen client-side
- No backend or API required
