//
//  UserService.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 12.08.2024.
//

import Foundation
import FirebaseFirestore

final class UserService {
    // MARK: - Properties
    static let shared = UserService()
    
    private init() {}
    private let userCollection: CollectionReference = Firestore.firestore().collection("users")
    
    // MARK: - Private Methods
    private func userDocument(_ userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    // MARK: - Public Methods
    func createNewUser(_ user: DBUser) async throws {
        try userDocument(user.userID).setData(from: user, merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId).getDocument(as: DBUser.self)
    }
    
    func updateUserName(_ name: String, userID: String) async throws {
        let data: [String : Any] = [DBUser.CodingKeys.name.rawValue : name]
        try await userDocument(userID).updateData(data)
    }
    
    func updateUserEmail(_ email: String, userID: String) async throws {
        let data: [String : Any] = [DBUser.CodingKeys.email.rawValue : email]
        try await userDocument(userID).updateData(data)
    }
    
    func updateUserProfileImagePath(userId: String, path: String?, url: String?) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.profileImagePath.rawValue : path,
            DBUser.CodingKeys.profileImagePathUrl.rawValue : url,
        ]
        
        try await userDocument(userId).updateData(data)
    }
    
    
    
    // MARK: - Favorites CRUD
    func deleteFavorite(_ userId: String, _ stationId: String) async throws {
        var user = try await getUser(userId: userId)
        
        if let index = user.favorites.firstIndex(where: { $0.id == stationId }) {
            user.favorites.remove(at: index)
            let data = try Firestore.Encoder().encode(user)
            try await userDocument(userId).setData(data, merge: true)
        } else {
            throw NSError(domain: "StationNotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "Station not found in user's favorites."])
        }
    }
    
    func saveFavoriteStatus(for userId: String, station: StationModel, with status: Bool) async throws {
        let isCurrentlyFavorite = try await isFavorite(userId, station.id)
        
        if status {
            if !isCurrentlyFavorite {
                try await saveFavoriteFor(userId, station: station)
            }
        } else {
            if isCurrentlyFavorite {
                try await deleteFavorite(userId, station.id)
            }
        }
    }
    
    func getFavoritesForUser(_ userId: String) async throws -> [StationModel] {
        let user = try await getUser(userId: userId)
        return user.favorites
    }
    
            
    func saveFavoriteFor(_ userId: String, station: StationModel) async throws {
        var user = try await getUser(userId: userId)
        
        if !user.favorites.contains(where: { $0.id == station.id }) {
            var favoriteStation = station
            
            user.favorites.append(favoriteStation)
            
            let data = try Firestore.Encoder().encode(user)
            try await userDocument(userId).setData(data, merge: true)
        }
    }
    
    private func isFavorite(_ userId: String, _ currentStationId: String) async throws -> Bool {
        let favoriteStations = try await getFavoritesForUser(userId)
        return favoriteStations.contains { $0.id == currentStationId }
    }
}
