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
    let station: StationModel
    
    private let userService: UserService
    @Published var stationId = ""
    
    @Published var error: Error? = nil
    
    // MARK: - Initializer
    init(
        userId: String,
        station: StationModel,
        userService: UserService = .shared
    ) {
        self.userId = userId
        self.station = station
        self.userService = userService
    }
    
    // MARK: - Methods
    
    /// Cancels the error alert
    func cancelErrorAlert() {
        error = nil
    }
    
    /// Adds a station to the user's favorites
    func addUserFavorite() {
//        Task {
//            try? await userService.addFavoriteFor(userId, station: StationModel)
//        }
    }
    
    /// Checks if a station is in the user's favorites
    func checkFavorite() -> Bool {
//        guard !user.favorites.isEmpty else { return false }
//        return user.favorites.contains { $0.id == stationId }
        return false
    }
}
