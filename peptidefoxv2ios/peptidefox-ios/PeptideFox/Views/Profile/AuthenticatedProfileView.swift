//
//  AuthenticatedProfileView.swift
//  PeptideFox
//
//  Created on 2025-10-21.
//

import SwiftUI

/// Profile view shown when user is authenticated (Settings screen)
struct AuthenticatedProfileView: View {
    @Binding var isDarkMode: Bool
    @Binding var fontSize: String
    let onSignOut: () -> Void
    
    @StateObject private var authManager = AuthManager.shared
    
    var body: some View {
        List {
            // User Info Section
            Section {
                HStack(spacing: 16) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(Color(hex: "#60a5fa"))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(authManager.userEmail ?? "User")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(Color(hex: "#e2e8f0"))
                        
                        Text("PeptideFox Member")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "#94a3b8"))
                    }
                }
                .padding(.vertical, 8)
                .listRowBackground(Color(hex: "#1e293b"))
            }
            
            // Preferences Section
            Section {
                // Dark Mode Toggle
                Toggle(isOn: $isDarkMode) {
                    HStack(spacing: 12) {
                        Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                            .foregroundColor(Color(hex: "#60a5fa"))
                            .frame(width: 24)
                        Text("Dark Mode")
                            .foregroundColor(Color(hex: "#e2e8f0"))
                    }
                }
                .tint(Color(hex: "#60a5fa"))
                .listRowBackground(Color(hex: "#1e293b"))
                
                // Font Size Picker
                Picker(selection: $fontSize) {
                    ForEach(FontSize.allCases, id: \.rawValue) { size in
                        Text(size.rawValue)
                            .tag(size.rawValue)
                    }
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "textformat.size")
                            .foregroundColor(Color(hex: "#60a5fa"))
                            .frame(width: 24)
                        Text("Font Size")
                            .foregroundColor(Color(hex: "#e2e8f0"))
                    }
                }
                .listRowBackground(Color(hex: "#1e293b"))
            } header: {
                Text("Preferences")
                    .foregroundColor(Color(hex: "#94a3b8"))
            }
            
            // About Section
            Section {
                NavigationLink {
                    AboutView()
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "info.circle")
                            .foregroundColor(Color(hex: "#60a5fa"))
                            .frame(width: 24)
                        Text("About PeptideFox")
                            .foregroundColor(Color(hex: "#e2e8f0"))
                    }
                }
                .listRowBackground(Color(hex: "#1e293b"))
            }
            
            // Sign Out Section
            Section {
                Button(action: onSignOut) {
                    HStack {
                        Spacer()
                        Text("Sign Out")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.red)
                        Spacer()
                    }
                }
                .listRowBackground(Color(hex: "#1e293b"))
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color(hex: "#0b1220"))
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        AuthenticatedProfileView(
            isDarkMode: .constant(true),
            fontSize: .constant("Medium"),
            onSignOut: {}
        )
        .navigationTitle("Profile")
    }
}
