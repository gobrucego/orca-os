#!/bin/bash

echo "🦊 Starting Peptide Fox iOS App..."
echo ""

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    if command -v bun &> /dev/null; then
        bun install
    else
        npm install
    fi
    echo ""
fi

echo "🚀 Starting Expo development server..."
echo ""
echo "Press 'i' to open in iOS Simulator"
echo "Or scan the QR code with Expo Go on your iPhone"
echo ""

if command -v bun &> /dev/null; then
    bun start
else
    npm start
fi
