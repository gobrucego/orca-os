import SwiftUI

struct AboutView: View {
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("PeptideFox")
                        .font(.system(size: 28, weight: .light))
                        .foregroundColor(Color(hex: "#e2e8f0"))

                    Text("Version 1.0")
                        .font(.system(size: 17))
                        .foregroundColor(Color(hex: "#94a3b8"))
                }
                .padding(.vertical, 8)
            }
            .listRowBackground(Color(hex: "#1e293b"))

            Section("About") {
                Text("Precision tools for GLP-1 and regenerative peptide therapy.")
                    .foregroundColor(Color(hex: "#e2e8f0"))
                    .font(.system(size: 15))

                Text("Track your protocols, calculate doses, and optimize your peptide therapy with evidence-based tools.")
                    .foregroundColor(Color(hex: "#94a3b8"))
                    .font(.system(size: 15))
            }
            .listRowBackground(Color(hex: "#1e293b"))

            Section("Features") {
                FeatureRow(icon: "pills.circle.fill", title: "Protocol Tracker", description: "Monitor complex multi-compound protocols")
                FeatureRow(icon: "function", title: "Dose Calculator", description: "Precise reconstitution calculations")
                FeatureRow(icon: "waveform.path.ecg", title: "GLP-1 Journey", description: "Optimize GLP-1 therapy protocols")
                FeatureRow(icon: "books.vertical", title: "Peptide Library", description: "Evidence-based peptide information")
            }
            .listRowBackground(Color(hex: "#1e293b"))

            Section("Legal") {
                DisclaimerRow()
            }
            .listRowBackground(Color(hex: "#1e293b"))
        }
        .scrollContentBackground(.hidden)
        .background(Color(hex: "#0b1220"))
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(Color(hex: "#60a5fa"))
                .frame(width: 24, height: 24)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color(hex: "#e2e8f0"))

                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "#94a3b8"))
            }
        }
        .padding(.vertical, 4)
    }
}

struct DisclaimerRow: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                Text("Medical Disclaimer")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color(hex: "#e2e8f0"))
            }

            Text("PeptideFox is for informational and educational purposes only. This app does not provide medical advice. Always consult with a qualified healthcare professional before starting any peptide therapy or making changes to your treatment plan.")
                .font(.system(size: 13))
                .foregroundColor(Color(hex: "#94a3b8"))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        AboutView()
    }
}
