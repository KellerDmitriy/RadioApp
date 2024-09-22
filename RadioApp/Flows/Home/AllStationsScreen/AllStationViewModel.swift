//
//  AllStationViewModel.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 24.08.2024.
//

import Foundation

final class AllStationViewModel: ObservableObject {
    let userId: String
    
    @Published var currentStation: StationModel?
    
    private let networkService = DIService.resolve(forKey: .networkService) ?? NetworkService()
    private let userService = DIService.resolve(forKey: .userService) ?? UserService()
    
    private let numberLimit = 20
    
    var stations = [StationModel]()

    var searchText = ""
    
    var isActiveDetailView = false
    

    init(
        userId: String
    ) {
        self.userId = userId
    }
    
    func fetchTopStations() async throws {
        var fetchedStations: [StationModel]
        fetchedStations = try await networkService.getTopStations(numberLimit)
        stations = fetchedStations
    }
    
    func fetchAllStations() async throws {
        var fetchedAllStations: [StationModel]
        fetchedAllStations = try await networkService.getAllStations()
        stations = fetchedAllStations
    }
    
    /// Checks if a station is in the user's favorites
    func checkFavorite() -> Bool {
//        guard !user.favorites.isEmpty else { return false }
//        guard let currentStation else { return false }
//        return user.favorites.contains { $0.id == currentStation.id }
        return false
    }
}
