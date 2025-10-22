//
//  CompoundCard.swift
//  PeptideFox
//
//  Created on 2025-10-21.
//

import SwiftUI

struct CompoundCard: View {
    let compound: ProtocolCompound
    @State private var showingEdit = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with emoji, name, and action button
            HStack(alignment: .top, spacing: 8) {
                Text(compound.category)
                    .font(.system(size: 20))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(compound.name)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.protocolText)
                    
                    if !compound.notes.isEmpty {
                        Text(compound.notes)
                            .font(.caption)
                            .foregroundColor(.protocolTextSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                
                Spacer()
                
                Button(action: { showingEdit = true }) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "#fbbf24"))
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
            }
            
            // Dose and concentration
            HStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("DOSE")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.protocolTextSecondary)
                    Text(compound.dose)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.protocolText)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("CONCENTRATION")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.protocolTextSecondary)
                    Text(compound.concentration)
                        .font(.system(size: 15))
                        .foregroundColor(.protocolTextSecondary)
                }
                
                Spacer()
            }
        }
        .padding(16)
        .background(Color.protocolCard)
        .cornerRadius(12)
        .sheet(isPresented: $showingEdit) {
            CompoundEditSheet(compound: compound)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    CompoundCard(compound: createCompound(name: "BPC-157 (L Knee)", schedule: "Mon/Wed/Fri")!)
        .padding()
        .background(Color.protocolBackground)
}
