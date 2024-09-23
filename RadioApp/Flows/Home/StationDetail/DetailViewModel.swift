//
//  DetailViewModel.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 04.09.2024.
//

import Foundation

@MainActor
final class DetailViewModel: ObservableObject {
    // MARK: - Stored Properties
    let userId: String
    @Published var station: StationModel
    @Published var error: Error? = nil
    
    private let userService = DIContainer.resolve(forKey: .userService) ?? UserService()
    
    var isFavorite: Bool {
        station.isFavorite
    }
    
    // MARK: - Initializer
    init(
        userId: String,
        station: StationModel
    ) {
        self.userId = userId
        self.station = station
    }
    
    // MARK: - Methods
    
    /// Cancels the error alert
    func cancelErrorAlert() {
        error = nil
    }
    
    /// Checks if a station is in the user's favorites
    func checkFavorite(){
//        guard !user.favorites.isEmpty else { return false }
//        return user.favorites.contains { $0.id == stationId }
//        return false
    }
}
