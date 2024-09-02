//
//  AllStationViewModel.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 24.08.2024.
//

import Foundation

final class AllStationViewModel: ObservableObject {
    
    private let networkService: NetworkService
    
    private let numberLimit = 20
    
    var stations = [StationModel]()

    var searchText = ""
    
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
    
    func fetchAllStations() async throws {
        var fetchedAllStations: [StationModel]
        fetchedAllStations = try await networkService.getAllStations()
        stations = fetchedAllStations
    }
    
}
