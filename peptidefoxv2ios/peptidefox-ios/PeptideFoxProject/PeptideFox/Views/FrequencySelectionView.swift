import SwiftUI

struct FrequencySelectionView: View {
    @ObservedObject var state: GLPJourneyState
    @Binding var currentStep: Int

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Text("How often do you want to inject?")
                        .font(.system(size: 28, weight: .medium))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    Text("Choose the frequency that best matches your goals and lifestyle")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top, 20)

                // Important Info Banner
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.blue)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("This is the MOST important decision")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.primary)

                        Text("Frequency affects side effects, appetite control, and results more than dose.")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .lineSpacing(2)
                    }

                    Spacer()

                    Button(action: {
                        // Navigate to dosing info
                    }) {
                        HStack(spacing: 4) {
                            Text("Learn More")
                                .font(.system(size: 14, weight: .medium))
                            Image(systemName: "arrow.up.right")
                                .font(.system(size: 12))
                        }
                        .foregroundColor(.blue)
                    }
                }
                .padding(16)
                .background(Color.blue.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue.opacity(0.4), lineWidth: 2)
                )
                .cornerRadius(12)
                .padding(.horizontal, 20)

                // Frequency Options - 2x2 Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(DosingFrequency.allCases) { frequency in
                        FrequencyCard(
                            frequency: frequency,
                            isSelected: state.frequency == frequency
                        ) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                state.frequency = frequency
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)

                // Selection Confirmation
                if let selectedFreq = state.frequency {
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.blue)
                        Text("**\(selectedFreq.displayName)** selected. This will determine your injection schedule.")
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

struct FrequencyCard: View {
    let frequency: DosingFrequency
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(frequency.displayName)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.primary)
                            .lineLimit(2)
                            .minimumScaleFactor(0.8)
                        Text(frequency.injectionCount)
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.blue)
                    }
                }

                // Metrics - Compact 3 column
                HStack(spacing: 8) {
                    VStack(spacing: 4) {
                        Text("Stability")
                            .font(.system(size: 9))
                            .foregroundColor(.secondary)
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 6)
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.blue)
                                    .frame(width: geo.size.width * frequency.stability, height: 6)
                            }
                        }
                        .frame(height: 6)
                    }

                    VStack(spacing: 4) {
                        Text("Side FX")
                            .font(.system(size: 9))
                            .foregroundColor(.secondary)
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 6)
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.green)
                                    .frame(width: geo.size.width * (1 - frequency.sideEffects), height: 6)
                            }
                        }
                        .frame(height: 6)
                    }

                    VStack(spacing: 4) {
                        Text("Ease")
                            .font(.system(size: 9))
                            .foregroundColor(.secondary)
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 6)
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.purple)
                                    .frame(width: geo.size.width * frequency.convenience, height: 6)
                            }
                        }
                        .frame(height: 6)
                    }
                }
                .frame(height: 30)

                // Pros
                VStack(alignment: .leading, spacing: 4) {
                    Text("PROS")
                        .font(.system(size: 9, weight: .semibold))
                        .tracking(0.3)
                        .foregroundColor(.green)

                    VStack(alignment: .leading, spacing: 3) {
                        ForEach(frequency.pros.prefix(2), id: \.self) { pro in
                            HStack(alignment: .top, spacing: 4) {
                                Text("✓")
                                    .font(.system(size: 10))
                                    .foregroundColor(.green)
                                Text(pro)
                                    .font(.system(size: 11))
                                    .foregroundColor(.primary)
                                    .lineLimit(2)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }

                // Best For
                VStack(alignment: .leading, spacing: 4) {
                    Text("BEST FOR")
                        .font(.system(size: 9, weight: .semibold))
                        .tracking(0.3)
                        .foregroundColor(.secondary)
                    Text(frequency.bestFor)
                        .font(.system(size: 11))
                        .foregroundColor(.primary)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.top, 4)
                .padding(.top, 4)
                .overlay(
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 1),
                    alignment: .top
                )
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
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

#Preview {
    FrequencySelectionView(state: GLPJourneyState(), currentStep: .constant(2))
}
