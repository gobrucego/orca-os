//
//  ProtocolOutputView.swift
//  PeptideFox
//
//  Created on 2025-10-21.
//

import SwiftUI

struct ProtocolOutputView: View {
    @State private var selectedDay = 0
    @State private var expandedSections: Set<String> = ["waking", "am", "midday", "evening", "sleep"]
    
    // Protocol data matching web implementation
    private let protocol_data = ProtocolData()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Header Card
                    VStack(alignment: .leading, spacing: 12) {
                        Text("AK 4-Week Intensive Recovery Protocol")
                            .font(.system(size: 24, weight: .light))
                            .foregroundColor(.protocolText)
                        
                        Text("Week 1: Foundation + Pre-Taper Loading")
                            .font(.system(size: 16))
                            .foregroundColor(.protocolTextSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(Color.protocolSurface)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.protocolBorder, lineWidth: 1)
                    )
                    
                    // Day Selector
                    DaySelector(selectedDay: $selectedDay)
                    
                    // Quick Reference
                    QuickReferenceCard()
                    
                    // Time Sections
                    TimeSection(
                        title: "🌅 Waking",
                        sectionKey: "waking",
                        compounds: protocol_data.wakingCompounds,
                        selectedDay: selectedDay,
                        expandedSections: $expandedSections
                    )
                    
                    TimeSection(
                        title: "🌞 AM",
                        sectionKey: "am",
                        compounds: protocol_data.amCompounds,
                        selectedDay: selectedDay,
                        expandedSections: $expandedSections
                    )
                    
                    TimeSection(
                        title: "🌅 Mid-Day",
                        sectionKey: "midday",
                        compounds: protocol_data.middayCompounds,
                        selectedDay: selectedDay,
                        expandedSections: $expandedSections
                    )
                    
                    TimeSection(
                        title: "🌙 Evening - Repair & Recovery",
                        sectionKey: "evening",
                        compounds: protocol_data.eveningCompounds,
                        selectedDay: selectedDay,
                        expandedSections: $expandedSections
                    )
                    
                    TimeSection(
                        title: "😴 Sleep & Recovery",
                        sectionKey: "sleep",
                        compounds: protocol_data.sleepCompounds,
                        selectedDay: selectedDay,
                        expandedSections: $expandedSections
                    )
                    
                    // Combination Guidance
                    CombinationGuidanceCard()
                }
                .padding(16)
            }
            .background(Color.protocolBackground)
            .navigationTitle("Protocol")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

/// Time section with collapsible header and filtered compounds
struct TimeSection: View {
    let title: String
    let sectionKey: String
    let compounds: [ProtocolCompound]
    let selectedDay: Int
    @Binding var expandedSections: Set<String>
    
    private var isExpanded: Bool {
        expandedSections.contains(sectionKey)
    }
    
    private var filteredCompounds: [ProtocolCompound] {
        compounds.filter { $0.isScheduledFor(dayIndex: selectedDay) }
    }
    
    var body: some View {
        if !filteredCompounds.isEmpty {
            VStack(alignment: .leading, spacing: 0) {
                // Section Header
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        if isExpanded {
                            expandedSections.remove(sectionKey)
                        } else {
                            expandedSections.insert(sectionKey)
                        }
                    }
                }) {
                    HStack {
                        Text(title)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.protocolText)
                        
                        Spacer()
                        
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.protocolTextSecondary)
                    }
                    .padding(16)
                    .background(Color.protocolSurface)
                }
                
                if isExpanded {
                    VStack(spacing: 12) {
                        ForEach(filteredCompounds) { compound in
                            CompoundCard(compound: compound)
                        }
                    }
                    .padding(16)
                    .background(Color.protocolSurface)
                }
            }
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.protocolBorder, lineWidth: 1)
            )
        }
    }
}

/// Protocol data structure matching web implementation
struct ProtocolData {
    let wakingCompounds: [ProtocolCompound] = [
        createCompound(name: "Vyvanse", schedule: "Mon/Wed/Fri")
    ].compactMap { $0 }

    let amCompounds: [ProtocolCompound] = [
        createCompound(name: "Enclomiphene", schedule: "Daily"),
        createCompound(name: "hCG", schedule: "Mon/Wed/Fri"),
        createCompound(name: "Kisspeptin-10", schedule: "Sun/Tue/Thu/Sat"),
        createCompound(name: "Retatrutide", schedule: "Mon"),
        createCompound(name: "AOD-9604", schedule: "Daily"),
        createCompound(name: "MOTS-C", schedule: "Mon/Wed/Fri"),
        createCompound(name: "VIP", schedule: "Daily"),
        createCompound(name: "SS-31", schedule: "Daily"),
        createCompound(name: "NAD+", schedule: "Daily")
    ].compactMap { $0 }

    let middayCompounds: [ProtocolCompound] = [
        createCompound(name: "Semax", schedule: "Mon-Sat"),
        createCompound(name: "Selank", schedule: "Tue-Sat"),
        createCompound(name: "P21", schedule: "Mon-Sat")
    ].compactMap { $0 }

    let eveningCompounds: [ProtocolCompound] = [
        createCompound(name: "BPC-157 (L Knee)", schedule: "Mon/Wed/Fri"),
        createCompound(name: "BPC-157 (R Leg)", schedule: "Sun/Tue/Thu/Sat"),
        createCompound(name: "TB-500 (L Knee)", schedule: "Mon/Wed/Fri"),
        createCompound(name: "TB-500 (R Leg)", schedule: "Sun/Tue/Thu/Sat"),
        createCompound(name: "GHK-Cu (L Knee)", schedule: "Mon/Wed/Fri"),
        createCompound(name: "GHK-Cu (R Leg)", schedule: "Sun/Tue/Thu/Sat"),
        createCompound(name: "KPV", schedule: "Daily"),
        createCompound(name: "hGH", schedule: "Daily")
    ].compactMap { $0 }

    let sleepCompounds: [ProtocolCompound] = [
        createCompound(name: "DSIP", schedule: "Daily"),
        createCompound(name: "Pinealon", schedule: "Daily")
    ].compactMap { $0 }
}

#Preview {
    ProtocolOutputView()
}
