//
//  HomeViewModel.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 29.08.2024.
//

import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    // MARK: - Stored Properties
    @Published private(set) var currentUser: DBUser? {
          didSet {
              print("User ID updated to: \(currentUser?.userID ?? "No ID")")
          }
      }
    @Published var error: Error?
    @Published var userId = ""
    
    var userName: String {
        currentUser?.name ?? ""
    }
    
    var user: DBUser {
        guard let currentUser else { return DBUser.getTestDBUser() }
        return currentUser
    }
    
    var profileImageURL: URL {
        guard let urlString = currentUser?.profileImagePathUrl else { return URL(fileURLWithPath: "") }
        return URL(string: urlString)!
    }
    
    private let networkService = DIContainer.resolve(forKey: .networkService) ?? NetworkService()
    private let userService = DIContainer.resolve(forKey: .userService) ?? UserService()
    private let authService = DIContainer.resolve(forKey: .authService) ?? AuthService()
    

    
    // MARK: - Initializer
    init() {}
    
    // MARK: - Methods
    func loadCurrentUser() async throws {
        do {
            self.userId = try authService.getAuthenticatedUser().uid
            self.currentUser = try await userService.getUser(userId: userId)
        } catch {
            self.error = error
        }
    }
}
