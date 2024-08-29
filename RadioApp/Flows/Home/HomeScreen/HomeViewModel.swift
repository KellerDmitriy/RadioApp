//
//  HomeViewModel.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 29.08.2024.
//

import Foundation
import AVFAudio

@MainActor
final class HomeViewModel: ObservableObject {
    // MARK: - Stored Properties
      @Published private(set) var currentUser: DBUser? = nil
      @Published var volume: CGFloat = 0.0
      @Published var isPlay = false
      @Published var error: Error?
      
      var userName: String {
          currentUser?.name ?? ""
      }

      var profileImageURL: URL {
          guard let urlString = currentUser?.profileImagePathUrl else { return URL(fileURLWithPath: "") }
          return URL(string: urlString)!
      }
      
      private let networkService: NetworkService
      private let userService: UserService
      private let playerService: PlayerService
      private let authService: AuthService
      
      // MARK: - Initializer
      init(
          authService: AuthService = .shared,
          networkService: NetworkService = .shared,
          userService: UserService = .shared,
          playerService: PlayerService = .shared
      ) {
          self.authService = authService
          self.networkService = networkService
          self.userService = userService
          self.playerService = playerService
      }
      
      // MARK: - Methods
      func loadCurrentUser() async throws {
          do {
              let authDataResult = try authService.getAuthenticatedUser()
              self.currentUser = try await userService.getUser(userId: authDataResult.uid)
          } catch {
              self.error = error
          }
      }
      
      func getVolume() {
          volume = CGFloat(playerService.volume)
      }

}
