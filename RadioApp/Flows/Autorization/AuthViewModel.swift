//
//  AuthViewModel.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 11.08.2024.
//

import SwiftUI
import GoogleSignIn

final class AuthViewModel: ObservableObject {
    var email = ""
    var password = ""
    var username = ""
    
    var forgotEmail = ""
    
    @Published var isAuthenticated: Bool
    @Published var error: Error?
    
    private let authService: AuthService

    // MARK: - Initializer
    init(authService: AuthService = .shared) {
        self.authService = authService
        isAuthenticated = authService.isAuthenticated()
    }
    
    func cancelErrorAlert() { error = nil }
    
    //    MARK: - AuthService Methods
    func signIn() async {
        do {
            try await authService.signInUser(email: email, password: password)
            isAuthenticated = authService.isAuthenticated()
            print("isAuthenticated set to \(isAuthenticated)")
        } catch {
            self.error = error
        }
    }
    
    func registerUser() async {
        do {
            try await authService.createUser(name: username, email: email, password: password)
        } catch {
            await MainActor.run {
                self.error = error
            }
        }
    }
    
    func resetPassword() async {
        do {
            try await authService.resetPassword(email: forgotEmail)
        } catch {
            self.error = error
        }
    }
    
    func signInGoogle() async throws {
        do {
            try await authService.signInWithGoogle()
            isAuthenticated = authService.isAuthenticated()
        } catch {
            self.error = error
        }
    }
}
