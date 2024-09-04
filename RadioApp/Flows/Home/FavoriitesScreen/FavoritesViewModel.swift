//
//  FavoritesViewModel.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 24.08.2024.
//

import Foundation

final class FavoritesViewModel: ObservableObject {
    // MARK: - Stored Properties
    let userId: String
    
    private let userService: UserService
    private let networkService: NetworkService
    
    private let numberLimit = 20
    
    var favoritesStations: [StationModel] = []

    
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
    

}
