//
//  UnauthenticatedProfileView.swift
//  PeptideFox
//
//  Created on 2025-10-21.
//

import SwiftUI

/// Profile view shown when user is not authenticated
struct UnauthenticatedProfileView: View {
    let onRegister: () -> Void
    let onSignIn: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // App Icon
            Image(systemName: "pills.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(Color(hex: "#60a5fa"))
            
            // Welcome Text
            VStack(spacing: 8) {
                Text("Welcome to PeptideFox")
                    .font(.system(size: 28, weight: .light))
                    .foregroundColor(Color(hex: "#e2e8f0"))
                
                Text("Sign in to save your protocols and preferences")
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "#94a3b8"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
            
            // Action Buttons
            VStack(spacing: 12) {
                Button(action: onRegister) {
                    Text("Create Account")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Color(hex: "#0f172a"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(hex: "#60a5fa"))
                        .cornerRadius(12)
                }
                
                Button(action: onSignIn) {
                    Text("Sign In")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(Color(hex: "#60a5fa"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(hex: "#1e293b"))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(hex: "#60a5fa"), lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "#0b1220"))
    }
}

// MARK: - Preview
#Preview {
    UnauthenticatedProfileView(
        onRegister: {},
        onSignIn: {}
    )
}
