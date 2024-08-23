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
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    // MARK: - Public Methods
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userID).setData(from: user, merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    func updateUserName(_ name: String, userID: String) async throws {
        let data: [String : Any] = [DBUser.CodingKeys.name.rawValue : name]
        try await userDocument(userId: userID).updateData(data)
    }
    
    func updateUserEmail(_ email: String, userID: String) async throws {
        let data: [String : Any] = [DBUser.CodingKeys.email.rawValue : email]
        try await userDocument(userId: userID).updateData(data)
    }
    
    func updateUserProfileImagePath(userId: String, path: String?, url: String?) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.profileImagePath.rawValue : path,
            DBUser.CodingKeys.profileImagePathUrl.rawValue : url,
        ]

        try await userDocument(userId: userId).updateData(data)
    }
    
    private func userFavoriteRadioStationsCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("favorite_radio_stations")
    }
    
    private func userFavoriteProductDocument(userId: String, favoriteRadioStationId: String) -> DocumentReference {
        userFavoriteRadioStationsCollection(userId: userId).document(favoriteRadioStationId)
    }
    
}
