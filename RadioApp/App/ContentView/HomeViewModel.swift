//
//  HomeViewModel.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 29.08.2024.
//

import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    
    private let userService: IUserService
    private let authService: IAuthService
    
    // MARK: - Stored Properties
    @Published private(set) var currentUser: DBUser? {
          didSet {
              print("User ID updated to: \(currentUser?.userID ?? "No ID")")
          }
      }
    @Published var error: Error?
    
    var user: DBUser {
        guard let currentUser else { return DBUser.getTestDBUser() }
        return currentUser
    }
    
    var userId: String {
        user.userID
    }
    
    var userName: String {
        user.name
    }
    
    var profileImageURL: URL? {
        guard let urlString = user.profileImagePathUrl else { return URL(fileURLWithPath: "") }
        return URL(string: urlString)
    }
    
    // MARK: - Initializer
    init(
        userService: IUserService = DIContainer.resolve(forKey: .userService) ?? UserService(),
        authServise: IAuthService = DIContainer.resolve(forKey: .authService) ?? AuthService()
    ) {
        self.userService = userService
        self.authService = authServise
    }
    
    // MARK: - Methods
    func loadCurrentUser() async throws {
        do {
            self.currentUser = try await userService.getUser(
                userId: authService.getAuthenticatedUser().uid
            )
        } catch {
            self.error = error
        }
    }
}
