//
//  PopularViewModel.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 24.08.2024.
//

import Foundation

struct FetchTaskToken: Equatable {
    var stations: String
    var token: Date
}
fileprivate let dateFormatter = DateFormatter()

@MainActor
final class PopularViewModel: ObservableObject {
    // MARK: - Stored Properties
    @Published var userId: String
    
    private let userService: UserService
    private let networkService: NetworkService
    private let timeIntervarForUpdateCache: TimeInterval = 24 * 60
    private let cache: DiskCache<[StationModel]>
    private let numberLimit = 5
    
    @Published var fetchTaskToken: FetchTaskToken
    @Published var phase: DataFetchPhase<[StationModel]> = .empty
    
    var stations: [StationModel] {
        phase.value ?? []
    }
    
    var currentStation: StationModel? = nil
    
    // MARK: - Initializer
    init(
        userId: String,
        userService: UserService = .shared,
        networkService: NetworkService = .shared
    ) {
        self.userId = userId
        self.userService = userService
        self.networkService = networkService
        self.fetchTaskToken = FetchTaskToken(stations: "RadioStations", token: Date())
        self.cache = DiskCache<[StationModel]>(
            filename: "xca_radio_stations",
            expirationInterval: timeIntervarForUpdateCache
        )
        
        Task(priority: .userInitiated) {
            try? await cache.loadFromDisk()
        }
    }
    
    func refreshTask() async {
        await cache.removeValue(forKey: fetchTaskToken.stations)
        fetchTaskToken.token = Date()
    }
    
    // MARK: - Methods
    /// Fetches top stations from the network service
    /// Fetches top stations from the network service and updates favorite status
    func fetchTopStations(ignoreCache: Bool = false) async {
        let keyForCache = fetchTaskToken.stations
        if !ignoreCache, let stationsFromCache = await cache.value(forKey: keyForCache) {
            phase = .success(stationsFromCache)
            print("CACHE HIT")
            return
        }
        print("CACHE MISSED/EXPIRED")
        phase = .empty
        do {
            var stationsFromAPI = try await networkService.getTopStations(numberLimit)
            let favoriteStations = try await userService.getFavoritesForUser(userId)
            
            for index in stationsFromAPI.indices {
                if favoriteStations.contains(where: { $0.id == stationsFromAPI[index].id }) {
                    stationsFromAPI[index].isFavorite = true
                }
            }
            
            await cache.setValue(stationsFromAPI, forKey: keyForCache)
            try? await cache.saveToDisk()
            
            print("CACHE SET")
            phase = .success(stationsFromAPI)
        } catch {
            phase = .failure(error)
        }
    }
    
    /// Cancels the error alert
    func cancelErrorAlert() {
        Task {
            await fetchTopStations()
        }
    }
    
    func toggleFavorite(station: StationModel) {
        Task {
            do {
                let isFavorite = station.isFavorite
                
                // Обновляем статус избранного для текущей станции
                var updatedStation = station
                updatedStation.isFavorite = !isFavorite
                
                // Сохраняем изменённую станцию в базе данных
                try await userService.saveFavoriteStatus(for: userId, station: updatedStation, with: updatedStation.isFavorite)
                
                // Обновляем локально массив станций
                if var currentStations = phase.value,
                   let index = currentStations.firstIndex(where: { $0.id == station.id }) {
                    currentStations[index] = updatedStation
                    phase = .success(currentStations)
                }
            } catch {
                phase = .failure(error)
            }
        }
    }
}
