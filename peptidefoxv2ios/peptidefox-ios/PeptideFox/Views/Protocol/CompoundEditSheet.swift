//
//  CompoundEditSheet.swift
//  PeptideFox
//
//  Created on 2025-10-21.
//

import SwiftUI

struct CompoundEditSheet: View {
    @Environment(\.dismiss) private var dismiss
    let compound: ProtocolCompound
    
    @State private var dose: String
    @State private var concentration: String
    @State private var notes: String
    
    init(compound: ProtocolCompound) {
        self.compound = compound
        _dose = State(initialValue: compound.dose)
        _concentration = State(initialValue: compound.concentration)
        _notes = State(initialValue: compound.notes)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text(compound.category)
                            .font(.system(size: 24))
                        Text(compound.name)
                            .font(.headline)
                        Spacer()
                    }
                    .listRowBackground(Color.protocolCard)
                }
                
                Section("Dosing") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Dose")
                            .font(.caption)
                            .foregroundColor(.protocolTextSecondary)
                        TextField("Dose", text: $dose)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Concentration")
                            .font(.caption)
                            .foregroundColor(.protocolTextSecondary)
                        TextField("Concentration", text: $concentration)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Unit")
                            .font(.caption)
                            .foregroundColor(.protocolTextSecondary)
                        Text(compound.unit)
                            .font(.body)
                            .foregroundColor(.protocolText)
                    }
                }
                .listRowBackground(Color.protocolCard)
                
                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 80)
                }
                .listRowBackground(Color.protocolCard)
                
                Section {
                    Button(action: resetToDefault) {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Reset to Default")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .foregroundColor(.protocolAccent)
                }
                .listRowBackground(Color.protocolCard)
            }
            .scrollContentBackground(.hidden)
            .background(Color.protocolBackground)
            .navigationTitle("Adjust Compound")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.protocolTextSecondary)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveChanges()
                        dismiss()
                    }
                    .foregroundColor(.protocolAccent)
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private func resetToDefault() {
        if let config = COMPOUND_CONFIGS[compound.name] {
            dose = config.baseDose
            concentration = config.concentration
            notes = config.notes
        }
    }
    
    private func saveChanges() {
        // TODO: Implement save to storage
        // For now, this is just UI demonstration
        print("Saving changes for \(compound.name)")
        print("Dose: \(dose)")
        print("Concentration: \(concentration)")
        print("Notes: \(notes)")
    }
}

#Preview {
    CompoundEditSheet(compound: createCompound(name: "BPC-157 (L Knee)", schedule: "Mon/Wed/Fri")!)
}
