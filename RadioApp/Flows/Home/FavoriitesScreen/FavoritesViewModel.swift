//
//  FavoritesViewModel.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 24.08.2024.
//

import Foundation

final class FavoritesViewModel: ObservableObject {
    
    private let networkService: NetworkService
    private let playerService: PlayerService
    
    private let numberLimit = 20
    
    var stations = [StationModel]()
    var selectedStation = ""
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
    
    func playFirstStation() {
        if stations.count > 0 {
            print(stations.count)
            selectedStation = stations[0].stationuuid
            playAudio(stations[0].url)
        }
    }
    
    func playAudio(_ url: String) {
        playerService.playAudio(url: url)
    }
    
}
