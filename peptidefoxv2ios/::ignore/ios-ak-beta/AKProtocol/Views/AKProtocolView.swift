import SwiftUI

struct AKProtocolView: View {
    @StateObject private var state = AKProtocolState()
    @State private var showingMasterConfig = false
    @State private var showingAdjustSheet = false
    @State private var selectedCompound: ProtocolCompound? = nil

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Week Selector
                    WeekSelector(selectedWeek: $state.selectedWeek)

                    // Day Selector
                    DaySelector(selectedDay: $state.selectedDay)

                    // Time-based sections
                    VStack(spacing: 16) {
                        ForEach(TimeOfDay.allCases, id: \.id) { timeOfDay in
                            let compounds = ProtocolData.getCompounds(
                                for: timeOfDay,
                                week: state.selectedWeek,
                                day: state.selectedDay
                            )

                            if !compounds.isEmpty {
                                TimeSectionCard(
                                    timeOfDay: timeOfDay,
                                    compounds: compounds,
                                    week: state.selectedWeek,
                                    day: state.selectedDay,
                                    state: state,
                                    showingAdjustSheet: $showingAdjustSheet,
                                    selectedCompound: $selectedCompound
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
                .padding(.top, 8)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 2) {
                        Text("AK: 4 Week Intensive Protocol")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Foundation + Pre-Taper Loading")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingMasterConfig = true
                    }) {
                        Text("Configure")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingMasterConfig) {
                MasterConfigSheet(state: state, isPresented: $showingMasterConfig)
            }
            .sheet(isPresented: $showingAdjustSheet) {
                if let compound = selectedCompound {
                    CompoundAdjustSheet(
                        compound: compound,
                        week: state.selectedWeek,
                        day: state.selectedDay,
                        state: state,
                        isPresented: $showingAdjustSheet
                    )
                }
            }
        }
    }
}

#Preview {
    AKProtocolView()
}
