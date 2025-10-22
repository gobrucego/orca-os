import SwiftUI

struct AgentSelectionView: View {
    @ObservedObject var state: GLPJourneyState
    @Binding var currentStep: Int

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    // Badge
                    HStack(spacing: 8) {
                        Image(systemName: "waveform.path.ecg")
                            .font(.system(size: 14))
                            .foregroundColor(.blue)
                        Text("GLP-1 Journey")
                            .font(.system(size: 10, weight: .medium))
                            .tracking(0.5)
                            .foregroundColor(.secondary)
                            .textCase(.uppercase)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .cornerRadius(20)

                    // Title
                    Text("Select GLP Agent")
                        .font(.system(size: 36, weight: .light))
                        .tracking(-0.5)
                        .multilineTextAlignment(.center)

                    // Comparison Link
                    Button(action: {
                        // Navigate to comparison
                    }) {
                        Text("View Detailed Comparison")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 4)
                }
                .padding(.top, 20)

                // Agent Cards
                VStack(spacing: 16) {
                    ForEach(GLPAgent.allCases) { agent in
                        AgentCard(agent: agent, isSelected: state.agent == agent) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                state.agent = agent
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)

                // Selection Confirmation
                if let selectedAgent = state.agent {
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.blue)
                        Text("**\(selectedAgent.displayName)** selected. Click Continue to proceed.")
                            .font(.system(size: 14))
                            .foregroundColor(.primary)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.blue.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue.opacity(0.3), lineWidth: 2)
                    )
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                }

                Spacer(minLength: 20)
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
}

struct AgentCard: View {
    let agent: GLPAgent
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(agent.displayName)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.primary)
                        Text(agent.subtitle)
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                    }
                }

                // Description
                Text(agent.description)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .lineSpacing(4)

                // Best For Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("BEST FOR:")
                        .font(.system(size: 10, weight: .semibold))
                        .tracking(0.5)
                        .foregroundColor(.secondary)

                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(agent.bestFor, id: \.self) { item in
                            HStack(alignment: .top, spacing: 8) {
                                Circle()
                                    .fill(Color.gray.opacity(0.4))
                                    .frame(width: 6, height: 6)
                                    .padding(.top, 6)
                                Text(item)
                                    .font(.system(size: 13))
                                    .foregroundColor(.primary)
                                    .lineSpacing(2)
                            }
                        }
                    }
                }

                // Metrics
                VStack(spacing: 12) {
                    MetricBar(title: "Intensity", value: agent.intensity, color: .green)
                    MetricBar(title: "Tolerability", value: agent.tolerability, color: .blue)
                    MetricBar(title: "Metabolic Scope", value: agent.metabolicScope, color: .purple)
                }
            }
            .padding(24)
            .background(isSelected ? Color.blue.opacity(0.1) : Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue.opacity(0.3) : Color.gray.opacity(0.3), lineWidth: isSelected ? 2 : 1)
            )
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct MetricBar: View {
    let title: String
    let value: Double
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.secondary)

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geometry.size.width * value, height: 8)
                }
            }
            .frame(height: 8)
        }
    }
}

#Preview {
    AgentSelectionView(state: GLPJourneyState(), currentStep: .constant(1))
}
