//
//  CombinationGuidanceCard.swift
//  PeptideFox
//
//  Created on 2025-10-21.
//

import SwiftUI

struct CombinationGuidanceCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 6) {
                Text("💡")
                    .font(.system(size: 18))
                Text("Combination Guidance")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.protocolText)
            }
            
            VStack(spacing: 12) {
                // Can mix
                VStack(alignment: .leading, spacing: 8) {
                    Text("Can mix (Evening):")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.protocolAccent)
                    
                    Text("BPC-157 + KPV + GHK-Cu (+ TB-500 fragment if desired)")
                        .font(.system(size: 13))
                        .foregroundColor(.protocolTextSecondary)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.protocolCard)
                .cornerRadius(8)
                
                // Inject alone
                VStack(alignment: .leading, spacing: 8) {
                    Text("Inject alone:")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.protocolAccent)
                    
                    Text("hGH, AOD-9604, NAD+")
                        .font(.system(size: 13))
                        .foregroundColor(.protocolTextSecondary)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.protocolCard)
                .cornerRadius(8)
            }
        }
        .padding(16)
        .background(Color.protocolSurface)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.protocolBorder, lineWidth: 1)
        )
    }
}

#Preview {
    CombinationGuidanceCard()
        .padding()
        .background(Color.protocolBackground)
}
