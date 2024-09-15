//
//  PopularViewModel.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 24.08.2024.
//

import Foundation

// MARK: - FetchTaskToken

struct FetchTaskToken: Equatable {
    var stations: String
    var token: Date
}

// MARK: - PopularViewModel
@MainActor
final class PopularViewModel: ObservableObject {
    // MARK: - Stored Properties
    private let userService: UserService
    private let networkService: NetworkService
    private let timeIntervalForUpdateCache: TimeInterval = 24 * 60
    private let cache: DiskCache<[StationModel]>
    private let numberLimit = 5
    
    @Published var userId: String
    @Published var fetchTaskToken: FetchTaskToken
    @Published var phase: DataFetchPhase<[StationModel]> = .empty
    @Published var selectedOrder: DisplayOrderType = .alphabetical
    @Published var selectedIndex: Int?
    
    // MARK: - Computed Properties
    private var sortedStations: [StationModel] {
        guard let stations = phase.value else { return [] }
        switch selectedOrder {
        case .alphabetical:
            return stations.sorted(by: { $0.name < $1.name })
        case .favoriteFirst:
            return stations.sorted { $0.isFavorite && !$1.isFavorite }
        }
    }
    
    var currentIndex: Int {
         selectedIndex ?? 0
    }
    
    var error: Error? {
        if case let .failure(error) = phase {
            return error
        }
        return nil
    }
    
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
            expirationInterval: timeIntervalForUpdateCache
        )
        
        Task(priority: .userInitiated) {
            try? await cache.loadFromDisk()
        }
    }
    
    // MARK: - Methods
    func getStations() -> [StationModel] { sortedStations }
    func getCurrentStation(_ index: Int) -> StationModel { getStations()[index] }
    func selectStation(at index: Int) { selectedIndex = index }
    func isSelectCell(_ index: Int) -> Bool { selectedIndex == index }
    func isFavoriteStation(_ index: Int) -> Bool { getCurrentStation(index).isFavorite }
    
    
    /// Fetches top stations from the network service and updates the favorite status.
    func fetchTopStations(ignoreCache: Bool = false) async {
        phase = .empty
        do {
            if !ignoreCache, let cachedStations = await cache.value(forKey: fetchTaskToken.stations) {
                print("CACHE HIT")
                phase = .success(cachedStations)
            } else {
                let stationsFromAPI = try await loadStationsFromAPI()
                print("CACHE MISSED/EXPIRED")
                phase = .success(stationsFromAPI)
            }
            
            let favoriteStations = try await userService.getFavoritesForUser(userId)
            updateFavoritesStatus()
        } catch {
            phase = .failure(error)
        }
    }
    
    /// Refreshes the cache and updates the fetch task token.
    func refreshTask() async {
        await cache.removeValue(forKey: fetchTaskToken.stations)
        fetchTaskToken.token = Date()
    }
    
    /// Cancels the error alert and refreshes the data.
    func cancelErrorAlert() {
        Task {
            await fetchTopStations(ignoreCache: true)
        }
    }
    
    /// Toggles the favorite status of the current station.
    func toggleFavorite(_ index: Int) {
        Task {
            do {
                var updatedStation = getCurrentStation(index)
                updatedStation.isFavorite.toggle()
            
                try await userService.saveFavoriteStatus(
                    for: userId,
                    station: updatedStation,
                    with: updatedStation.isFavorite
                )
                
                if var currentStations = phase.value,
                   let index = currentStations.firstIndex(where: { $0.id == getCurrentStation(index).id }) {
                    currentStations[index] = updatedStation
                    phase = .success(currentStations)
                }
            } catch {
                phase = .failure(error)
            }
        }
    }
    
    // MARK: - Private Methods
    private func updateFavoritesStatus() {
        guard var currentStations = phase.value else { return }
        Task {
            do {
                let favoriteStations = try await userService.getFavoritesForUser(userId)
                for index in currentStations.indices {
                    currentStations[index].isFavorite = favoriteStations.contains { $0.id == currentStations[index].id }
                }
                phase = .success(currentStations)
            } catch {
                print("Error updating favorite status: \(error)")
            }
        }
    }
    
    private func loadStationsFromAPI() async throws -> [StationModel] {
        let stationsFromAPI = try await networkService.getTopStations(numberLimit)
        await cache.setValue(stationsFromAPI, forKey: fetchTaskToken.stations)
        try? await cache.saveToDisk()
        return stationsFromAPI
    }
}
