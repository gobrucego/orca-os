import SwiftUI

struct GLPJourneyView: View {
    @StateObject private var state = GLPJourneyState()
    @State private var currentStep = 1

    let steps = [
        (id: 1, name: "Select GLP Agent"),
        (id: 2, name: "Frequency"),
        (id: 3, name: "Your GLP Protocol")
    ]

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Progress Indicator
                StepProgressView(
                    currentStep: $currentStep,
                    totalSteps: steps.count,
                    steps: steps
                )
                .padding(.vertical, 16)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)

                // Step Content
                TabView(selection: $currentStep) {
                    AgentSelectionView(state: state, currentStep: $currentStep)
                        .tag(1)

                    FrequencySelectionView(state: state, currentStep: $currentStep)
                        .tag(2)

                    GLPProtocolOutputView(state: state)
                        .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                // Navigation Buttons
                if currentStep < 3 {
                    HStack(spacing: 16) {
                        Button(action: {
                            withAnimation {
                                currentStep = max(1, currentStep - 1)
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 14, weight: .medium))
                                Text("Back")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(currentStep == 1 ? .gray : .primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .cornerRadius(10)
                        }
                        .disabled(currentStep == 1)

                        Button(action: {
                            withAnimation {
                                currentStep = min(3, currentStep + 1)
                            }
                        }) {
                            HStack(spacing: 8) {
                                Text(currentStep == 2 ? "View Protocol" : "Continue")
                                    .font(.system(size: 16, weight: .medium))
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .medium))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(canProceed() ? Color.blue : Color.gray)
                            .cornerRadius(10)
                        }
                        .disabled(!canProceed())
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: -1)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("GLP-1 Journey")
                        .font(.system(size: 17, weight: .semibold))
                }
            }
        }
    }

    private func canProceed() -> Bool {
        switch currentStep {
        case 1: return state.agent != nil
        case 2: return state.frequency != nil
        case 3: return true
        default: return false
        }
    }
}

struct StepProgressView: View {
    @Binding var currentStep: Int
    let totalSteps: Int
    let steps: [(id: Int, name: String)]

    var body: some View {
        VStack(spacing: 12) {
            // Progress Circles
            HStack(spacing: 0) {
                ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                    HStack(spacing: 0) {
                        Button(action: {
                            if step.id < currentStep {
                                withAnimation {
                                    currentStep = step.id
                                }
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .stroke(
                                        stepColor(for: step.id),
                                        lineWidth: 2
                                    )
                                    .frame(width: 40, height: 40)

                                Circle()
                                    .fill(stepBackground(for: step.id))
                                    .frame(width: 40, height: 40)

                                if step.id < currentStep {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.green)
                                } else {
                                    Text("\(step.id)")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(step.id == currentStep ? .blue : .gray)
                                }
                            }
                        }
                        .disabled(step.id > currentStep)

                        if index < steps.count - 1 {
                            Rectangle()
                                .fill(step.id < currentStep ? Color.green.opacity(0.3) : Color.gray.opacity(0.2))
                                .frame(height: 2)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)

            // Step Counter
            Text("Step \(currentStep) of \(totalSteps)")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)
        }
    }

    private func stepColor(for step: Int) -> Color {
        if step < currentStep {
            return Color.green.opacity(0.3)
        } else if step == currentStep {
            return Color.blue.opacity(0.3)
        } else {
            return Color.gray.opacity(0.3)
        }
    }

    private func stepBackground(for step: Int) -> Color {
        if step < currentStep {
            return Color.green.opacity(0.1)
        } else if step == currentStep {
            return Color.blue.opacity(0.1)
        } else {
            return Color.white
        }
    }
}

#Preview {
    GLPJourneyView()
}
