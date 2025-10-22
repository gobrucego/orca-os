//
//  RegisterView.swift
//  PeptideFox
//
//  Created on 2025-10-21.
//

import SwiftUI

/// User registration view
struct RegisterView: View {
    @StateObject private var authManager = AuthManager.shared
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
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
                        .textContentType(.newPassword)
                        .listRowBackground(Color(hex: "#1e293b"))
                    
                    SecureField("Confirm Password", text: $confirmPassword)
                        .textContentType(.newPassword)
                        .listRowBackground(Color(hex: "#1e293b"))
                } header: {
                    Text("Account Details")
                        .foregroundColor(Color(hex: "#94a3b8"))
                } footer: {
                    Text("Password must be at least 6 characters")
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
                
                // Register Button
                Section {
                    Button(action: register) {
                        HStack {
                            Spacer()
                            Text("Create Account")
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
            .navigationTitle("Create Account")
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
        !email.isEmpty && 
        !password.isEmpty && 
        password == confirmPassword && 
        password.count >= 6
    }
    
    // MARK: - Actions
    
    private func register() {
        errorMessage = ""
        
        authManager.register(email: email, password: password) { result in
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
    RegisterView()
}
