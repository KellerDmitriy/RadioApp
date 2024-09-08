//
//  FavoritesViewModel.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 24.08.2024.
//

import Foundation

@MainActor
final class FavoritesViewModel: ObservableObject {
    // MARK: - Stored Properties
    let userId: String
    private let userService: UserService
    
    @Published var favoritesStations: [StationModel] = []
    @Published var currentStation: StationModel? 
    @Published var error: Error? = nil
    
    
    // MARK: - Initializer
    init(
        userId: String,
        userService: UserService = .shared
    ) {
        self.userId = userId
        self.userService = userService
    }

    // Fetch favorite stations
    func getFavorites() async {
        do {
            favoritesStations = try await userService.getFavoritesForUser(userId)
        } catch {
            self.error = error
        }
    }
    
    func deleteFavorite() async {
        do {
            guard let currentStation else { return }
            try await userService.deleteFavorite(userId, currentStation.id)
            await getFavorites()
        } catch {
            self.error = error
        }
    }
    
    // Cancel error alert
    func cancelErrorAlert() {
        error = nil
    }
    
    // Set the current station when a cell is activated
    func setCurrentStation(at index: Int) {
        currentStation = favoritesStations[index]
    }
    
}
