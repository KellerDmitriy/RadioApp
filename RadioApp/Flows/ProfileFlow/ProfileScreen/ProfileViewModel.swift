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
    @Published private(set) var currentUser: DBUser? = nil
    
    @Published var error: ProfileFlowError?
    @AppStorage("isOnboarding") var isOnboarding = true
    
    var userName: String { currentUser?.name ?? "" }
    var userEmail: String { currentUser?.email ?? "" }
    var profileImageURL: URL {
        guard let urlString = currentUser?.profileImagePathUrl else { return URL(fileURLWithPath: "") }
        return URL(string: urlString)!
    }
    
    private let userService: UserService
    private let authService: AuthService
    private let notificationsService: NotificationsService
    
    // MARK: - Initializer
    init(
        userService: UserService = .shared,
        authService: AuthService = .shared,
        notificationsService: NotificationsService = .shared) {
            self.userService = userService
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
    
    // MARK: - Storage Methods
    
    
    //    MARK: - AuthService Methods
    func loadCurrentUser() async throws {
        let authDataResult = try authService.getAuthenticatedUser()
        self.currentUser = try await userService.getUser(userId: authDataResult.uid)
    }
    
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
