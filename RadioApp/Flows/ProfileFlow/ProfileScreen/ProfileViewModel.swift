//
//  ProfileViewModel.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 28.07.2024.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseDatabase

@MainActor
final class ProfileViewModel: ObservableObject {
    // MARK: - Stored Properties
    @Published private(set) var currentUser: DBUser
    @Published var error: ProfileFlowError?
    @AppStorage("isOnboarding") var isOnboarding = true
    
    var userName: String {
        currentUser.name
    }
    var userEmail: String {
        currentUser.email
    }
    
    var profileImageURL: URL? {
            guard let urlString = currentUser.profileImagePathUrl, 
                    let url = URL(string: urlString) else {
                return nil
            }
            return url
        }
    
    private let authService: AuthService
    private let notificationsService: NotificationsService
    
    // MARK: - Initializer
    init(
        currentUser: DBUser,
        authService: AuthService = .shared,
        notificationsService: NotificationsService = .shared) {
            self.currentUser = currentUser
            self.authService = authService
            self.notificationsService = notificationsService
        }
    
    // MARK: - Methods
    func showLogoutAlert() { error = .logout }
    func cancelErrorAlert() { error = nil }
    
    func tapErrorOk() {
        switch error {
        case .logout:
            logOut()
        default: return
        }
    }

    
    //    MARK: - AuthService Methods
    func logOut() {
        do {
            try authService.signOut()
            isOnboarding.toggle()
        } catch {
            self.error = ProfileFlowError.map(error)
        }
    }
    
    //    MARK: - Notifications
    func notificationAction() {
        notificationsService.sendTestNotification()
    }
    
    func requestNotificationAuthorization() {
        notificationsService.requestNotificationAuthorization()
    }
}
