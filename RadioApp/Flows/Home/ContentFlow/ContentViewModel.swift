//
//  ContentViewModel.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 27.08.2024.
//

import Foundation
import AVFAudio

final class ContentViewModel: ObservableObject {
    // MARK: - Stored Properties
    @Published private(set) var currentUser: DBUser? = nil
    @Published var userName: String = ""
    @Published var profileImageURL: URL?
    
    var volume: CGFloat = CGFloat(AVAudioSession.sharedInstance().outputVolume)
    
    private let networkService: NetworkService
    private let userService: UserService
    private let playerService: PlayerService
    private let authService: AuthService
    
    
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
    
    func loadCurrentUser() async throws {
        let authDataResult = try authService.getAuthenticatedUser()
        self.currentUser = try await userService.getUser(userId: authDataResult.uid)
        if let currentUser = currentUser {
            self.userName = currentUser.name
            self.profileImageURL = URL(string: currentUser.profileImagePathUrl ?? "")
        }
    }
}
