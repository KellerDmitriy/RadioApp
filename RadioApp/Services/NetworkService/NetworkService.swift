//
//  NetworkService.swift
//  RadioApp
//
//  Created by Dmitriy Eliseev on 28.07.2024.v
//

import Foundation

final class NetworkService {
    
    public static let shared = NetworkService()
    private init() {}
    
    // MARK: - get top stations
    
    func getTopStations(_ numberLimit: Int) async throws -> [StationModel] {
        var stations = [StationModel]()
        
        guard let url = URLManager.shared.createURLTop(numberLimit: numberLimit) else {
            throw NetworkError.badURL
        }
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        
        guard let decodedStations = try? JSONDecoder().decode([StationModel].self, from: data) else {
            throw NetworkError.decodingError
        }
        
        stations = decodedStations
        return stations
    }
    
    // MARK: - get top stations
    
    func getAllStations() async throws -> [StationModel] {
        var allStations = [StationModel]()
        
        guard let url = URLManager.shared.createURLAll() else {
            throw NetworkError.badURL
        }
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        
        guard let decodedStations = try? JSONDecoder().decode([StationModel].self, from: data) else {
            throw NetworkError.decodingError
        }
        
        allStations = decodedStations
        return allStations
    }
    
    // MARK: - get station by UUID
    
    func getStationById(id: String) async throws -> [StationModel] {
        var stationById = [StationModel]()
        
        guard let url = URLManager.shared.createURLUUID(id: id) else {
            throw NetworkError.badURL
        }
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        
        guard let decodedStation = try? JSONDecoder().decode([StationModel].self, from: data) else {
            throw NetworkError.decodingError
        }
        
        stationById = decodedStation
        return stationById
    }
    
    
    // MARK: - vote for station by UUID.
    
    func voteStationById(id: String) async throws {
        
        guard let url = URLManager.shared.createURLUUID(id: id) else {
            throw NetworkError.badURL
        }
        let urlRequest = URLRequest(url: url)
        let (_, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.badResponse
        }
    }
    
    // MARK: - search Station
    
    func searchByName(searchText: String) async throws -> [StationModel] {
        var searchByName = [StationModel]()
        
        guard let url = URLManager.shared.createURLSearch(searchText: searchText) else {
            throw NetworkError.badURL
        }
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        
        guard let decodedStation = try? JSONDecoder().decode([StationModel].self, from: data) else {
            throw NetworkError.decodingError
        }
        
        searchByName = decodedStation
        return searchByName
    }
    
    
}


// MARK: - network errors

enum NetworkError: Error {
    case badURL
    case badData
    case badResponse
    case decodingError
}

