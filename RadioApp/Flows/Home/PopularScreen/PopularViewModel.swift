//
//  PopularViewModel.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 24.08.2024.
//

import Foundation

final class PopularViewModel: ObservableObject {
    private let networkService: NetworkService
    private let playerService: PlayerService
    
    private let numberLimit = 20
    
    var stations = [StationModel]()
    var selectedStation = ""
    var isActiveDetailView = false
    
    @Published var isPlay = false
    @Published var volume: CGFloat
    @Published var error: Error? = nil
    
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
        do {
            var fetchedStations: [StationModel]
            fetchedStations = try await networkService.getTopStations(numberLimit: numberLimit)
            stations = fetchedStations
        } catch {
            self.error = error
        }
    }
    
    func playFirstStation() {
        if stations.count > 0 {
            selectedStation = stations[0].stationuuid
            playAudio(stations[0].url)
        }
    }
    
    func playAudio(_ url: String) {
        playerService.playAudio(url: url)
    }
}
