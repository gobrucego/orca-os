//
//  ProfileView.swift
//  PeptideFox
//
//  Created on 2025-10-21.
//

import SwiftUI

/// Main profile view with authentication state handling
struct ProfileView: View {
    @StateObject private var authManager = AuthManager.shared
    @AppStorage("isDarkMode") private var isDarkMode = true
    @AppStorage("fontSize") private var fontSize = FontSize.medium.rawValue
    
    var body: some View {
        NavigationStack {
            Group {
                if authManager.isAuthenticated {
                    // Authenticated: Show Settings
                    AuthenticatedProfileView(
                        isDarkMode: $isDarkMode,
                        fontSize: $fontSize,
                        onSignOut: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                authManager.signOut()
                            }
                        }
                    )
                } else {
                    // Unauthenticated: Show Welcome Screen
                    UnauthenticatedProfileView(
                        onRegister: { authManager.showRegister() },
                        onSignIn: { authManager.showSignIn() }
                    )
                }
            }
            .navigationTitle("Profile")
        }
        .sheet(isPresented: $authManager.showingRegister) {
            RegisterView()
        }
        .sheet(isPresented: $authManager.showingSignIn) {
            SignInView()
        }
    }
}

// MARK: - Preview
#Preview("Unauthenticated") {
    ProfileView()
}

#Preview("Authenticated") {
    let manager = AuthManager.shared
    manager.isAuthenticated = true
    manager.userEmail = "user@example.com"
    return ProfileView()
}
