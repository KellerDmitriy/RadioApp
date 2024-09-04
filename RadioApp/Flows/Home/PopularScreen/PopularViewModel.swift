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
    private let user: DBUser
    private let userService: UserService
    private let networkService: NetworkService
    
    private let numberLimit = 30
    
    @Published var stations = [StationModel]()
    @Published var error: Error? = nil
    
    // MARK: - Initializer
    init(
        user: DBUser,
        userService: UserService = .shared,
        networkService: NetworkService = .shared
    ) {
        self.user = user
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
    func addUserFavorite(stationId: String) {
        Task {
            try? await userService.addFavoriteFor(user.userID)
        }
    }
    
    /// Checks if a station is in the user's favorites
    func checkFavorite(station: StationModel) -> Bool {
        guard !user.favorites.isEmpty else { return false }
        return user.favorites.contains { $0.id == station.id }
    }
}
