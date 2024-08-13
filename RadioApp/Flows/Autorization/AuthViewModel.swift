//
//  AuthViewModel.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 11.08.2024.
//

import SwiftUI

final class AuthViewModel: ObservableObject {
    var email = ""
    var password = ""
    var username = ""
   
    @Published var isAuthenticated: Bool
    @Published var error: Error?
    
    private let authService: AuthService
    @Published var isUserRegistered = false
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
    
    func registerUser() {
        Task {
            try await authService.createUser(name: username, email: email, password: password)
            isUserRegistered = true
        }
    }
    
}
