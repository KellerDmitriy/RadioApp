//
//  AuthViewModel.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 11.08.2024.
//

import SwiftUI
import GoogleSignIn

@MainActor
final class AuthViewModel: ObservableObject {
    var email = ""
    var password = ""
    var username = ""
    var forgotEmail = ""
    
    @Published var isAuthenticated: Bool
    @Published var error: Error?
    
    private let authService: AuthService
    private let userService: UserService
    
    // MARK: - Initializer
    init(authService: AuthService = .shared, userService: UserService = .shared) {
        self.authService = authService
        self.userService = userService
        isAuthenticated = authService.isAuthenticated()
    }
    
    func cancelErrorAlert() {
        Task { @MainActor in
            error = nil
        }
    }
    
    //    MARK: - AuthService Methods
    func signIn() async {
        do {
            try await authService.signInUser(email: email, password: password)
            await MainActor.run {
                isAuthenticated = authService.isAuthenticated()
            }
        } catch {
            await MainActor.run {
                self.error = error
            }
        }
    }
    
    func registerUser() async {
        do {
            var authDataResult = try await authService.createUser(email: email, password: password)
            authDataResult.userName = username
            let user = DBUser(auth: authDataResult)
            try await userService.createNewUser(user)
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
            await MainActor.run {
                self.error = error
            }
        }
    }
    
    func signInGoogle() async throws {
        do {
           let authDataResult = try await authService.signInWithGoogle()
            let user = DBUser(auth: authDataResult)
            try await userService.createNewUser(user)
            await MainActor.run {
                isAuthenticated = authService.isAuthenticated()
            }
        } catch {
            await MainActor.run {
                self.error = error
            }
        }
    }
}
