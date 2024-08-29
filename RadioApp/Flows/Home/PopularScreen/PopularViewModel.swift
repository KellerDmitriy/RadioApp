//
//  PopularViewModel.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 24.08.2024.
//

import Foundation

@MainActor
final class PopularViewModel: ObservableObject {
    // MARK: - Stored Properties
    private let networkService: NetworkService
    private let playerService: PlayerService
    
    private let numberLimit = 20
    
    var stations = [StationModel]()
    var selectedStation = ""
    var isActiveDetailView = false
    
    @Published var isPlayMusic: Bool
    @Published var volume: CGFloat
    @Published var error: Error? = nil
    
    // MARK: - Initializer
    init(
        isPlayMusic: Bool,
        volume: CGFloat,
        networkService: NetworkService = .shared,
        playerService: PlayerService = .shared
    ) {
        self.isPlayMusic = isPlayMusic
        self.volume = volume
        self.networkService = networkService
        self.playerService = playerService
    }
    
    func fetchTopStations() async throws {
        do {
            stations = try await networkService.getTopStations(numberLimit: numberLimit)
        } catch {
            self.error = error
        }
    }
    
    func playFirstStation() {
       if isPlayMusic {
            selectedStation = stations[0].stationuuid
            playAudio(stations[0].url)
        }
    }
    
    func playAudio(_ url: String) {
        playerService.playAudio(url: url)
    }
}
