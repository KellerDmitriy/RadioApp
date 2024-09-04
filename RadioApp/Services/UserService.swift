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
    
    //    MARK: Favorites CRUD
    private func userFavoritesCollection(_ userId: String) -> CollectionReference {
        userDocument(userId).collection("favorite_radio_stations")
    }
    
    private func userFavoritesDocument(userId: String, favoritesId: String) -> DocumentReference {
        userFavoritesCollection(userId).document(favoritesId)
    }
    
    func addFavoriteFor(_ userID: String) async throws {
        let document = userFavoritesCollection(userID).document()
        
        guard let snapshot = try? await document.getDocument(),
              let station = StationModel(docSnap: snapshot) else {
            throw NSError(domain: "DataError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to create StationModel from snapshot"])
        }
        
        let data = station.representation
        
        try await document.setData(data, merge: false)
    }
    

    func removeUserFavorite(userId: String, favoriteId: String) async throws {
        try await userFavoritesDocument(userId: userId, favoritesId: favoriteId).delete()
        
    }

//    func deleteFavorites(user: DBUser) async throws {
//        do {
//            try await userFavoritesCollection(user.userID).delete()
//        } catch {
//            print("problem with delete favorite")
//            throw error
//        }
//    }
}
