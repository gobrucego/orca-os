#!/usr/bin/env swift
import Foundation
import AppKit

// Load the fox logo
let logoPath = "PeptideFox/Resources/Assets.xcassets/peptidefoxicon.imageset/peptidefoxicon.png"
guard let logoImage = NSImage(contentsOfFile: logoPath) else {
    print("❌ Failed to load logo image")
    exit(1)
}

// Canvas settings
let canvasSize: CGFloat = 1024
let logoScale: CGFloat = 0.75 // Logo takes 75% of canvas

// Calculate logo size maintaining aspect ratio
let logoMaxSize = canvasSize * logoScale
let logoSize = logoImage.size
let aspectRatio = logoSize.width / logoSize.height
var newLogoWidth: CGFloat
var newLogoHeight: CGFloat

if aspectRatio > 1 {
    // Wider than tall
    newLogoWidth = logoMaxSize
    newLogoHeight = logoMaxSize / aspectRatio
} else {
    // Taller than wide
    newLogoHeight = logoMaxSize
    newLogoWidth = logoMaxSize * aspectRatio
}

// Calculate center position
let x = (canvasSize - newLogoWidth) / 2
let y = (canvasSize - newLogoHeight) / 2

// Create white canvas
let canvas = NSImage(size: NSSize(width: canvasSize, height: canvasSize))
canvas.lockFocus()

// Fill white background
NSColor.white.setFill()
NSRect(x: 0, y: 0, width: canvasSize, height: canvasSize).fill()

// Draw logo centered
let logoRect = NSRect(x: x, y: y, width: newLogoWidth, height: newLogoHeight)
logoImage.draw(in: logoRect)

canvas.unlockFocus()

// Save as PNG
if let tiffData = canvas.tiffRepresentation,
   let bitmapImage = NSBitmapImageRep(data: tiffData),
   let pngData = bitmapImage.representation(using: .png, properties: [:]) {
    let outputPath = "PeptideFox/Resources/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png"
    try? pngData.write(to: URL(fileURLWithPath: outputPath))
    print("✅ Created padded app icon with white background")
    print("   Canvas: \(Int(canvasSize))x\(Int(canvasSize))")
    print("   Logo size: \(Int(newLogoWidth))x\(Int(newLogoHeight))")
    print("   Padding: \(Int(x))px on each side")
} else {
    print("❌ Failed to save PNG")
    exit(1)
}
