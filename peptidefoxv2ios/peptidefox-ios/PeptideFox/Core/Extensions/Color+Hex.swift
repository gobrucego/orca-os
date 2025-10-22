//
//  Color+Hex.swift
//  PeptideFox
//
//  Created on 2025-10-21.
//

import SwiftUI

extension Color {
    /// Initialize Color from hex string
    /// - Parameter hex: Hex color string (e.g., "#0b1220", "0b1220", "#FFF")
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

/// Protocol theme colors matching web implementation
extension Color {
    static let protocolBackground = Color(hex: "#0b1220")
    static let protocolSurface = Color(hex: "#10172a")
    static let protocolCard = Color(hex: "#1e293b")
    static let protocolAccent = Color(hex: "#60a5fa")
    static let protocolText = Color(hex: "#e2e8f0")
    static let protocolTextSecondary = Color(hex: "#94a3b8")
    static let protocolBorder = Color(hex: "#1f2937")
}
