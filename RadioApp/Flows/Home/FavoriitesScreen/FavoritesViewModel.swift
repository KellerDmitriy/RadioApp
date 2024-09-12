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
    
    
    @Published var isFavorite = false
    @Published var error: Error? = nil
    
    var index: Int? = nil
    
    var currentStation: StationModel? {
          guard let index = index, index >= 0, index < favoritesStations.count else {
              return nil
          }
          return favoritesStations[index]
      }
    
    var isSelect: Bool {
        guard let index = index, index >= 0, index < favoritesStations.count else {
            return false
        }
        return favoritesStations[index].id == (currentStation?.id ?? "")
    }
    
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
            try await userService.saveFavoriteStatus(
                for: userId,
                station: currentStation,
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
    
    // Set the current station when a cell is activated
    func setCurrentIndex(_ index: Int) {
        self.index = index
    }
    
}
