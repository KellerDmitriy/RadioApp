//
//  FavoritesViewModel.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 24.08.2024.
//

import Foundation

final class FavoritesViewModel: ObservableObject {
    // MARK: - Stored Properties
    private let user: DBUser
    
    private let userService: UserService
    private let networkService: NetworkService
    
    private let numberLimit = 20
    
    var stations: [StationModel] = []

    
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
    
    func checkFavorite(station: StationModel) -> Bool {
        guard user.favorites.count != 0 else { return false }
        return user.favorites.contains { stationIn in
            stationIn.id == station.id
        }
    }
    

}
