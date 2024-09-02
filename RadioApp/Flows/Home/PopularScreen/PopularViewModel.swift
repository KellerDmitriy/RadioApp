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
    
    private let numberLimit = 30
    
    @Published var stations = [StationModel]()
  
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
