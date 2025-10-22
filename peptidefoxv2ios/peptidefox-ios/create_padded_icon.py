#!/usr/bin/env python3
from PIL import Image

# Open the fox logo
logo = Image.open('PeptideFox/Resources/Assets.xcassets/peptidefoxicon.imageset/peptidefoxicon.png')

# Create white background (1024x1024)
canvas_size = 1024
canvas = Image.new('RGBA', (canvas_size, canvas_size), (255, 255, 255, 255))

# Calculate logo size with padding (75% of canvas)
logo_max_size = int(canvas_size * 0.75)

# Resize logo maintaining aspect ratio
logo.thumbnail((logo_max_size, logo_max_size), Image.Resampling.LANCZOS)

# Calculate position to center logo
x = (canvas_size - logo.width) // 2
y = (canvas_size - logo.height) // 2

# Paste logo onto white canvas
canvas.paste(logo, (x, y), logo if logo.mode == 'RGBA' else None)

# Convert to RGB (remove alpha for final icon)
final = Image.new('RGB', (canvas_size, canvas_size), (255, 255, 255))
final.paste(canvas, (0, 0), canvas)

# Save
final.save('PeptideFox/Resources/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png')
print("✅ Created padded app icon with white background")
print(f"   Canvas: {canvas_size}x{canvas_size}")
print(f"   Logo size: {logo.width}x{logo.height}")
print(f"   Padding: {x}px on each side")
