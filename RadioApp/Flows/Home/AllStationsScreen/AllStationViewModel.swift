//
//  AllStationViewModel.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 24.08.2024.
//

import Foundation

final class AllStationViewModel: ObservableObject {
    
    private let networkService: NetworkService
    private let playerService: PlayerService
    
    private let numberLimit = 20
    
    var stations = [StationModel]()
    var selectedStation = ""
    var searchText = ""
    var isActiveDetailView = false
    
    @Published var volume: CGFloat
    
    init(
        volume: CGFloat,
        networkService: NetworkService = .shared,
        playerService: PlayerService = .shared
    ) {
        self.volume = volume
        self.networkService = networkService
        self.playerService = playerService
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
    
    func playAudio(_ url: String) {
        playerService.playAudio(url: url)
    }
}
