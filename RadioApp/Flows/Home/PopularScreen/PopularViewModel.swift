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
    @Published var error: Error? = nil
    
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
    }
    
    // MARK: - Methods
    /// Fetches top stations from the network service
    /// Fetches top stations from the network service and updates favorite status
    func fetchTopStations() async {
        do {
            var stationsFromAPI = try await networkService.getTopStations(numberLimit)
            let favoriteStations = try await userService.getFavoritesForUser(userId)
            

            for index in stationsFromAPI.indices {
                if favoriteStations.contains(where: { $0.id == stationsFromAPI[index].id }) {
                    stationsFromAPI[index].isFavorite = true
                }
            }
            stations = stationsFromAPI
            
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
                let isFavorite = station.isFavorite
                
                // Обновляем статус избранного для текущей станции
                var updatedStation = station
                updatedStation.isFavorite = !isFavorite
                
                // Сохраняем изменённую станцию в базе данных
                try await userService.saveFavoriteStatus(for: userId, station: updatedStation, with: updatedStation.isFavorite)
                
                // Обновляем локально массив станций
                if let index = stations.firstIndex(where: { $0.id == station.id }) {
                    stations[index] = updatedStation
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
