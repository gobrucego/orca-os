import SwiftUI

@main
struct PeptideFoxApp: App {
    @State private var showingLoadingScreen = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                // Main app content
                ContentView()
                    .opacity(showingLoadingScreen ? 0 : 1)

                // Loading screen overlay
                if showingLoadingScreen {
                    LoadingView(isShowing: $showingLoadingScreen)
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: showingLoadingScreen)
        }
    }
}

// MARK: - SwiftData Integration (Coming Soon)
// SwiftData will be integrated in Phase 2 for:
// - Protocol persistence
// - User preferences
// - Calculation history
// - Peptide tracking
