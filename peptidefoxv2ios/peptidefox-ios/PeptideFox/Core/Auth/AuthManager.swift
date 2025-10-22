//
//  AuthManager.swift
//  PeptideFox
//
//  Created on 2025-10-21.
//

import SwiftUI

/// Authentication manager handling user authentication state
/// Uses local storage for MVP (use Keychain + backend in production)
@MainActor
class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    @Published var isAuthenticated = false
    @Published var userEmail: String?
    @Published var showingRegister = false
    @Published var showingSignIn = false
    
    private let userDefaultsKey = "peptidefox.auth.user"
    private let passwordKey = "peptidefox.auth.password"
    
    private init() {
        // Check if user is already signed in
        if let savedEmail = UserDefaults.standard.string(forKey: userDefaultsKey) {
            self.isAuthenticated = true
            self.userEmail = savedEmail
        }
    }
    
    /// Register a new user
    /// - Parameters:
    ///   - email: User email address
    ///   - password: User password (min 6 characters)
    ///   - completion: Result callback
    func register(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Validate email format
        guard email.contains("@") && email.contains(".") else {
            completion(.failure(AuthError.invalidEmail))
            return
        }
        
        // Validate password length
        guard password.count >= 6 else {
            completion(.failure(AuthError.weakPassword))
            return
        }
        
        // Check if user already exists
        if UserDefaults.standard.string(forKey: userDefaultsKey) != nil {
            completion(.failure(AuthError.userAlreadyExists))
            return
        }
        
        // Save credentials (simplified - use Keychain in production)
        UserDefaults.standard.set(email, forKey: userDefaultsKey)
        UserDefaults.standard.set(password, forKey: passwordKey)
        
        self.isAuthenticated = true
        self.userEmail = email
        self.showingRegister = false
        
        completion(.success(()))
    }
    
    /// Sign in existing user
    /// - Parameters:
    ///   - email: User email address
    ///   - password: User password
    ///   - completion: Result callback
    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Get saved credentials
        let savedEmail = UserDefaults.standard.string(forKey: userDefaultsKey)
        let savedPassword = UserDefaults.standard.string(forKey: passwordKey)
        
        // Validate credentials
        guard email == savedEmail, password == savedPassword else {
            completion(.failure(AuthError.invalidCredentials))
            return
        }
        
        self.isAuthenticated = true
        self.userEmail = email
        self.showingSignIn = false
        
        completion(.success(()))
    }
    
    /// Sign out current user
    func signOut() {
        self.isAuthenticated = false
        self.userEmail = nil
    }
    
    /// Show registration view
    func showRegister() {
        showingRegister = true
    }
    
    /// Show sign-in view
    func showSignIn() {
        showingSignIn = true
    }
}

/// Authentication errors
enum AuthError: LocalizedError {
    case invalidEmail
    case weakPassword
    case invalidCredentials
    case userAlreadyExists
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Please enter a valid email address"
        case .weakPassword:
            return "Password must be at least 6 characters"
        case .invalidCredentials:
            return "Invalid email or password"
        case .userAlreadyExists:
            return "An account with this email already exists"
        }
    }
}
