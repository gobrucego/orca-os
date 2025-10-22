import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var showingProfile = false

    var body: some View {
        TabView(selection: $selectedTab) {
            CalculatorViewWrapper(showingProfile: $showingProfile)
                .tabItem {
                    Label("Calculator", systemImage: "function")
                }
                .tag(0)

            PeptideLibraryWrapper(showingProfile: $showingProfile)
                .tabItem {
                    Label("Library", systemImage: "books.vertical")
                }
                .tag(1)

            GLPJourneyWrapper(showingProfile: $showingProfile)
                .tabItem {
                    Label("GLP-1", systemImage: "waveform.path.ecg")
                }
                .tag(2)

            ProtocolWrapper(showingProfile: $showingProfile)
                .tabItem {
                    Label("Protocol", systemImage: "list.clipboard")
                }
                .tag(3)
        }
        .accentColor(ColorTokens.brandPrimary)
        .sheet(isPresented: $showingProfile) {
            ProfileView()
        }
    }
}

// MARK: - Tab Wrappers with Profile Button

struct CalculatorViewWrapper: View {
    @Binding var showingProfile: Bool

    var body: some View {
        CalculatorView()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingProfile = true
                    } label: {
                        Image(systemName: "person.circle")
                            .font(.system(size: 22))
                            .foregroundColor(ColorTokens.foregroundPrimary)
                    }
                }
            }
    }
}

struct PeptideLibraryWrapper: View {
    @Binding var showingProfile: Bool

    var body: some View {
        PeptideLibraryView()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingProfile = true
                    } label: {
                        Image(systemName: "person.circle")
                            .font(.system(size: 22))
                            .foregroundColor(ColorTokens.foregroundPrimary)
                    }
                }
            }
    }
}

struct GLPJourneyWrapper: View {
    @Binding var showingProfile: Bool

    var body: some View {
        GLPJourneyView()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingProfile = true
                    } label: {
                        Image(systemName: "person.circle")
                            .font(.system(size: 22))
                            .foregroundColor(ColorTokens.foregroundPrimary)
                    }
                }
            }
    }
}

struct ProtocolWrapper: View {
    @Binding var showingProfile: Bool

    var body: some View {
        ProtocolOutputView()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingProfile = true
                    } label: {
                        Image(systemName: "person.circle")
                            .font(.system(size: 22))
                            .foregroundColor(ColorTokens.foregroundPrimary)
                    }
                }
            }
    }
}

// MARK: - Placeholder Views

struct ProtocolsPlaceholderView: View {
    var body: some View {
        NavigationStack {
            PFEmptyState(
                icon: "list.clipboard",
                title: "Protocols",
                message: "Protocol builder coming soon. Track your peptide protocols and manage dosing schedules.",
                actionTitle: nil,
                action: nil
            )
            .navigationTitle("Protocols")
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
