//
//  PopularViewModel.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 24.08.2024.
//

import Foundation

@MainActor
final class PopularViewModel: ObservableObject {
    // MARK: - Stored Properties
    @Published var userId: String
    
    private let userService: UserService
    private let networkService: NetworkService
    
    private let numberLimit = 30
    
    @Published var stations = [StationModel]()
    @Published var currentStation: StationModel?
    
    @Published var isVote = false
    @Published var error: Error? = nil
    
    // MARK: - Initializer
    init(
        userId: String,
        userService: UserService = .shared,
        networkService: NetworkService = .shared
    ) {
        self.userId = userId
        self.userService = userService
        self.networkService = networkService
    }
    
    // MARK: - Methods
    /// Fetches top stations from the network service
    func fetchTopStations() async {
        do {
            stations = try await networkService.getTopStations(numberLimit)
        } catch {
            self.error = error
        }
    }
    
    /// Cancels the error alert
    func cancelErrorAlert() {
        error = nil
    }
    
    /// Adds a station to the user's favorites
    func addUserFavorite() {
        guard let currentStation else { return }
        print(currentStation)
        Task {
            try? await userService.addFavoriteFor(userId, station: currentStation)
        }
    }
    
    /// Checks if a station is in the user's favorites
    func checkFavorite() {
//        guard !user.favorites.isEmpty else { return false }
//        return user.favorites.contains { $0.id == stationId }
        var isVote = false
        isVote.toggle()
       
    }
}
