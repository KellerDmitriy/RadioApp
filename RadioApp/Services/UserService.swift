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
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    func updateUserProfileImagePath(userId: String, path: String?, url: String?) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.profileImagePath.rawValue : path,
            DBUser.CodingKeys.profileImagePathUrl.rawValue : url,
        ]

        try await userDocument(userId: userId).updateData(data)
    }
}
