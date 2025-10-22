import SwiftUI

struct ProtocolOutputView: View {
    @ObservedObject var state: GLPJourneyState
    @State private var showingAddPhase = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Text("Your GLP Protocol")
                        .font(.system(size: 32, weight: .medium))
                        .multilineTextAlignment(.center)

                    Text("Interactive protocol - adjust phases and doses")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)

                // Protocol Summary Card
                if let agent = state.agent, let frequency = state.frequency {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Protocol Summary")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.primary)
                                Text("Based on your selections")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }

                        Divider()

                        HStack(spacing: 24) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Agent")
                                    .font(.system(size: 11))
                                    .foregroundColor(.secondary)
                                Text(agent.displayName)
                                    .font(.system(size: 15, weight: .medium))
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Frequency")
                                    .font(.system(size: 11))
                                    .foregroundColor(.secondary)
                                Text(frequency.displayName)
                                    .font(.system(size: 15, weight: .medium))
                            }
                        }

                        Divider()

                        HStack(spacing: 24) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Duration")
                                    .font(.system(size: 11))
                                    .foregroundColor(.secondary)
                                Text("\(state.protocolDuration) weeks")
                                    .font(.system(size: 15, weight: .medium))
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Total Phases")
                                    .font(.system(size: 11))
                                    .foregroundColor(.secondary)
                                Text("\(state.phases.count)")
                                    .font(.system(size: 15, weight: .medium))
                            }
                        }
                    }
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    .padding(.horizontal, 20)
                }

                // Protocol Phases
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Protocol Phases")
                            .font(.system(size: 20, weight: .semibold))
                        Spacer()
                        Button(action: {
                            addDefaultPhases()
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "plus.circle.fill")
                                Text("Add Phase")
                            }
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal, 20)

                    if state.phases.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "calendar.badge.plus")
                                .font(.system(size: 48))
                                .foregroundColor(.gray.opacity(0.3))

                            Text("No phases yet")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.secondary)

                            Text("Add a phase to start building your protocol")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)

                            Button(action: {
                                addDefaultPhases()
                            }) {
                                Text("Generate Default Protocol")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }
                            .padding(.top, 8)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 48)
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                    } else {
                        VStack(spacing: 12) {
                            ForEach(state.phases) { phase in
                                PhaseCard(phase: phase, onDelete: {
                                    deletePhase(phase)
                                })
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }

                Spacer(minLength: 20)
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
    }

    private func addDefaultPhases() {
        guard let agent = state.agent, let frequency = state.frequency else { return }

        // Generate default titration protocol based on agent
        let defaultPhases: [ProtocolPhase]

        switch agent {
        case .semaglutide:
            defaultPhases = [
                ProtocolPhase(name: "Initiation", startWeek: 1, endWeek: 4, dose: 0.25, frequency: frequency),
                ProtocolPhase(name: "Titration 1", startWeek: 5, endWeek: 8, dose: 0.5, frequency: frequency),
                ProtocolPhase(name: "Titration 2", startWeek: 9, endWeek: 12, dose: 1.0, frequency: frequency),
                ProtocolPhase(name: "Maintenance", startWeek: 13, endWeek: 16, dose: 2.0, frequency: frequency)
            ]
        case .tirzepatide:
            defaultPhases = [
                ProtocolPhase(name: "Initiation", startWeek: 1, endWeek: 4, dose: 2.5, frequency: frequency),
                ProtocolPhase(name: "Titration 1", startWeek: 5, endWeek: 8, dose: 5.0, frequency: frequency),
                ProtocolPhase(name: "Titration 2", startWeek: 9, endWeek: 12, dose: 7.5, frequency: frequency),
                ProtocolPhase(name: "Maintenance", startWeek: 13, endWeek: 16, dose: 10.0, frequency: frequency)
            ]
        case .retatrutide:
            defaultPhases = [
                ProtocolPhase(name: "Initiation", startWeek: 1, endWeek: 4, dose: 2.0, frequency: frequency),
                ProtocolPhase(name: "Titration 1", startWeek: 5, endWeek: 8, dose: 4.0, frequency: frequency),
                ProtocolPhase(name: "Titration 2", startWeek: 9, endWeek: 12, dose: 8.0, frequency: frequency),
                ProtocolPhase(name: "Maintenance", startWeek: 13, endWeek: 16, dose: 12.0, frequency: frequency)
            ]
        }

        withAnimation(.easeInOut(duration: 0.3)) {
            state.phases = defaultPhases
        }
    }

    private func deletePhase(_ phase: ProtocolPhase) {
        withAnimation(.easeInOut(duration: 0.2)) {
            state.phases.removeAll { $0.id == phase.id }
        }
    }
}

struct PhaseCard: View {
    let phase: ProtocolPhase
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            // Phase Info
            VStack(alignment: .leading, spacing: 8) {
                Text(phase.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)

                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                        Text("Weeks \(phase.startWeek)-\(phase.endWeek)")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }

                    HStack(spacing: 4) {
                        Image(systemName: "syringe")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                        Text("\(String(format: "%.1f", phase.dose))mg")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                }

                Text(phase.frequency.displayName)
                    .font(.system(size: 12))
                    .foregroundColor(.blue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(6)
            }

            Spacer()

            // Delete Button
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .font(.system(size: 16))
                    .foregroundColor(.red)
            }
            .padding(8)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    let state = GLPJourneyState()
    state.agent = .semaglutide
    state.frequency = .twiceWeekly
    return ProtocolOutputView(state: state)
}
