//
//  FavoritesViewModel.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 24.08.2024.
//

import Foundation

final class FavoritesViewModel: ObservableObject {
    
    private let networkService: NetworkService
    
    private let numberLimit = 20
    
    var stations = [StationModel]()
    var selectedStation = ""
    var isActiveDetailView = false
    
    
    init(
        networkService: NetworkService = .shared
    ) {
        self.networkService = networkService
    }
    
    func fetchTopStations() async throws {
        var fetchedStations: [StationModel]
        fetchedStations = try await networkService.getTopStations(numberLimit: numberLimit)
        stations = fetchedStations
    }

}
