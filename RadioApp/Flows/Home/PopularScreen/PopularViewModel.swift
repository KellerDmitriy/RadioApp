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
    @Published var userId: String
    
    private let userService: UserService
    private let networkService: NetworkService
    
    private let numberLimit = 20
    
    @Published var stations = [StationModel]()
    @Published var currentIndex: Int?
    @Published var error: Error? = nil

    
    var currentStation: StationModel? {
        guard let currentIndex = currentIndex,
                stations.indices.contains(currentIndex) else {
            return nil
        }
        return stations[currentIndex]
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
    }
    
    // MARK: - Methods
    /// Fetches top stations from the network service
    func fetchTopStations() async {
        do {
            stations = try await networkService.getTopStations(numberLimit)
        } catch {
            self.error = error
        }
    }
    
    /// Cancels the error alert
    func cancelErrorAlert() {
        error = nil
    }
    
    func toggleFavorite(station: StationModel) {
           Task {
               do {
                   let isFavorite = station.isFavorite ?? false
                   try await userService.saveFavoriteStatus(for: userId, station: station, with: !isFavorite)
                   
                   if let index = stations.firstIndex(where: { $0.id == station.id }) {
                       stations[index].isFavorite = !isFavorite
                   }
               } catch {
                   self.error = error
               }
           }
       }
       
       func fetchFavorites() async {
           do {
               self.stations = try await userService.getFavoritesForUser(userId)
           } catch {
               self.error = error
           }
       }
}
