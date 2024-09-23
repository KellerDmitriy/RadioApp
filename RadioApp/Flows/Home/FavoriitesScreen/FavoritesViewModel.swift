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
    private let userService = DIContainer.resolve(forKey: .userService) ?? UserService()
    
    @Published var favoritesStations: [StationModel] = []
    @Published var selectedIndex: Int?
    @Published var isFavorite = false
    @Published var error: Error? = nil
    
    // MARK: - Initializer
    init(
        userId: String
    ) {
        self.userId = userId
    }

    func getStations() -> [StationModel] { favoritesStations }
    func getCurrentStation(_ index: Int) -> StationModel { getStations()[index] }
    func selectStation(at index: Int) { selectedIndex = index }
    func isSelectCell(_ index: Int) -> Bool { selectedIndex == index }
    func isFavoriteStation(_ index: Int) -> Bool { getCurrentStation(index).isFavorite }
    
    // Fetch favorite stations
    func getFavorites() async {
        do {
            favoritesStations = try await userService.getFavoritesForUser(userId)
        } catch {
            self.error = error
        }
    }
    
    func deleteFavorite(station: StationModel) async {
        do {
            try await userService.saveFavoriteStatus(
                for: userId,
                station: station,
                with: isFavorite)
            await getFavorites()
        } catch {
            self.error = error
        }
    }
    
    // Cancel error alert
    func cancelErrorAlert() {
        error = nil
    }  
}
