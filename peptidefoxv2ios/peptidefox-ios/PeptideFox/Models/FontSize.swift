//
//  FontSize.swift
//  PeptideFox
//
//  Created on 2025-10-21.
//

import SwiftUI

/// Font size preference options
enum FontSize: String, CaseIterable {
    case small = "Small"
    case medium = "Medium"
    case large = "Large"
    
    /// Scale factor to apply to fonts
    var scale: CGFloat {
        switch self {
        case .small: return 0.9
        case .medium: return 1.0
        case .large: return 1.1
        }
    }
    
    /// Display name for UI
    var displayName: String {
        rawValue
    }
}
