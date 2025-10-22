//
//  QuickReferenceCard.swift
//  PeptideFox
//
//  Created on 2025-10-21.
//

import SwiftUI

struct QuickReferenceCard: View {
    @State private var isExpanded = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text("Quick Reference")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.protocolText)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.protocolTextSecondary)
                }
                .padding(16)
            }
            
            if isExpanded {
                Divider()
                    .background(Color.protocolBorder)
                
                // Three columns
                VStack(spacing: 0) {
                    HStack(alignment: .top, spacing: 16) {
                        // Timing Notes
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Timing Notes")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Color(hex: "#60a5fa"))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                ReferenceItem(text: "VIP → 60-90 min → Vyvanse")
                                ReferenceItem(text: "hGH/hCG/Kisspeptin AM only")
                                ReferenceItem(text: "DSIP before bed")
                            }
                        }
                        
                        // Injection Sites
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Injection Sites")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Color(hex: "#34d399"))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                ReferenceItem(text: "Systemic: Abdomen/Thighs")
                                ReferenceItem(text: "Local: Peri-lesional")
                                ReferenceItem(text: "NAD+: Glutes/VL")
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    
                    // Mechanical Work (full width)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Mechanical Work")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(Color(hex: "#fbbf24"))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            ReferenceItem(text: "24-48h post TB-500")
                            ReferenceItem(text: "ROM, scar mobilization")
                            ReferenceItem(text: "Lighter on non-TB-500 days")
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 16)
                }
            }
        }
        .background(Color.protocolSurface)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.protocolBorder, lineWidth: 1)
        )
    }
}

struct ReferenceItem: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 6) {
            Text("•")
                .font(.system(size: 12))
                .foregroundColor(.protocolTextSecondary)
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(.protocolTextSecondary)
        }
    }
}

#Preview {
    QuickReferenceCard()
        .padding()
        .background(Color.protocolBackground)
}
