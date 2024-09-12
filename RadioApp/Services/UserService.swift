//
//  UserService.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 12.08.2024.
//
import Foundation
import FirebaseFirestore

// MARK: - UserService
// A service class responsible for handling user-related operations with Firestore
final class UserService {
    // MARK: - Properties
    // Singleton instance of UserService
    static let shared = UserService()
    
    // Reference to the "users" collection in Firestore
    private let userCollection: CollectionReference = Firestore.firestore().collection("users")
    
    // Private initializer to enforce singleton pattern
    private init() {}
    
    // MARK: - Private Methods
    // Returns a reference to a specific user document in the Firestore collection
    private func userDocument(_ userId: String) -> DocumentReference {
        guard !userId.isEmpty else {
            fatalError("User ID cannot be empty.")
        }
        return userCollection.document(userId)
    }
    
    // MARK: - Public Methods
    // Creates a new user in the Firestore database
    func createNewUser(_ user: DBUser) async throws {
        try userDocument(user.userID).setData(from: user, merge: false)
    }
    
    // Retrieves a user from the Firestore database
    func getUser(userId: String) async throws -> DBUser {
        guard !userId.isEmpty else {
            throw NSError(domain: "InvalidUserID", code: 400, userInfo: [NSLocalizedDescriptionKey: "User ID cannot be empty."])
        }
        return try await userDocument(userId).getDocument(as: DBUser.self)
    }
    
    // Updates the user's name in the Firestore database
    func updateUserName(_ name: String, userID: String) async throws {
        let data: [String : Any] = [DBUser.CodingKeys.name.rawValue : name]
        try await userDocument(userID).updateData(data)
    }
    
    // Updates the user's email in the Firestore database
    func updateUserEmail(_ email: String, userID: String) async throws {
        let data: [String : Any] = [DBUser.CodingKeys.email.rawValue : email]
        try await userDocument(userID).updateData(data)
    }
    
    // Updates the user's profile image path and URL in the Firestore database
    func updateUserProfileImagePath(userId: String, path: String?, url: String?) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.profileImagePath.rawValue : path as Any,
            DBUser.CodingKeys.profileImagePathUrl.rawValue : url as Any,
        ]
        try await userDocument(userId).updateData(data)
    }
    
    // MARK: - Favorites CRUD Operations

    // Saves the favorite status of a station for a specific user
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
    
    // Retrieves all favorite stations for a specific user
    func getFavoritesForUser(_ userId: String) async throws -> [StationModel] {
        let user = try await getUser(userId: userId)
        return user.favorites
    }
    
    // Adds a station to the user's favorites if it is not already present
    private func saveFavoriteFor(_ userId: String, station: StationModel) async throws {
        var user = try await getUser(userId: userId)
        
        if !user.favorites.contains(where: { $0.id == station.id }) {
            user.favorites.append(station)
            let data = try Firestore.Encoder().encode(user)
            try await userDocument(userId).setData(data, merge: true)
        }
    }
    
    // Deletes a favorite station for a specific user
    private func deleteFavorite(_ userId: String, _ stationId: String) async throws {
        var user = try await getUser(userId: userId)
        
        if let index = user.favorites.firstIndex(where: { $0.id == stationId }) {
            user.favorites.remove(at: index)
            let data = try Firestore.Encoder().encode(user)
            try await userDocument(userId).setData(data, merge: true)
        } else {
            throw NSError(domain: "StationNotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "Station not found in user's favorites."])
        }
    }
    
    // Checks if a station is already a favorite for a specific user
    private func isFavorite(_ userId: String, _ currentStationId: String) async throws -> Bool {
        let favoriteStations = try await getFavoritesForUser(userId)
        return favoriteStations.contains { $0.id == currentStationId }
    }
}
