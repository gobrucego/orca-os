//
//  SignInView.swift
//  PeptideFox
//
//  Created on 2025-10-21.
//

import SwiftUI

/// User sign-in view
struct SignInView: View {
    @StateObject private var authManager = AuthManager.shared
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                // Input Section
                Section {
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .listRowBackground(Color(hex: "#1e293b"))
                    
                    SecureField("Password", text: $password)
                        .textContentType(.password)
                        .listRowBackground(Color(hex: "#1e293b"))
                } header: {
                    Text("Sign In")
                        .foregroundColor(Color(hex: "#94a3b8"))
                }
                
                // Error Message
                if !errorMessage.isEmpty {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .listRowBackground(Color(hex: "#1e293b"))
                    }
                }
                
                // Sign In Button
                Section {
                    Button(action: signIn) {
                        HStack {
                            Spacer()
                            Text("Sign In")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(isValidForm ? Color(hex: "#0f172a") : Color(hex: "#94a3b8"))
                            Spacer()
                        }
                    }
                    .disabled(!isValidForm)
                    .listRowBackground(
                        isValidForm ? Color(hex: "#60a5fa") : Color(hex: "#1e293b")
                    )
                }
            }
            .navigationTitle("Sign In")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { 
                        dismiss() 
                    }
                    .foregroundColor(Color(hex: "#60a5fa"))
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(hex: "#0b1220"))
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Validation
    
    private var isValidForm: Bool {
        !email.isEmpty && !password.isEmpty
    }
    
    // MARK: - Actions
    
    private func signIn() {
        errorMessage = ""
        
        authManager.signIn(email: email, password: password) { result in
            switch result {
            case .success:
                dismiss()
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
    }
}

// MARK: - Preview
#Preview {
    SignInView()
}
