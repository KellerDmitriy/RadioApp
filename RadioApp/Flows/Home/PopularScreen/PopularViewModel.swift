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
    
    private let numberLimit = 20
    
    @Published var stations = [StationModel]()
    
    @Published var currentStation: StationModel?
  
    // MARK: - Computed Properties
    
       var selectedStationID: String {
           get {
               return currentStation?.stationuuid ?? ""
           }
           set {
               if let newStation = stations.first(where: { $0.stationuuid == newValue }) {
                   currentStation = newStation
               }
           }
       }
    
    var selectedStationURL: String {
        get {
            return currentStation?.url ?? ""
        }
        set {
            if let newStation = stations.first(where: { $0.url == newValue }) {
                currentStation = newStation
            }
        }
    }
    
    @Published var error: Error? = nil
    
    // MARK: - Initializer
    init(
        networkService: NetworkService = .shared
    ) {
        self.networkService = networkService
    }
    
    func fetchTopStations() async throws {
        do {
            stations = try await networkService.getTopStations(numberLimit: numberLimit)
        } catch {
            self.error = error
        }
    }
}
