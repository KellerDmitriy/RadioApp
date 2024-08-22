//
//  UserModel.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 12.08.2024.
//

import Foundation
import FirebaseAuth

// MARK: - GoogleSignInResultModel
struct GoogleSignInResultModel {
    let idToken: String
    let accessToken: String
}

// MARK: - AuthDataResultModel
struct AuthDataResultModel: Codable {
    let uid: String
    let userName: String?
    let email: String?
    let profileImageURL: String?

    enum CodingKeys: String, CodingKey {
        case uid
        case userName
        case email
        case profileImageURL
    }
    
    init(user: User) {
        self.uid = user.uid
        self.userName = user.displayName
        self.email = user.email
        self.profileImageURL = user.photoURL?.absoluteString
    }
}

struct DBUser: Codable {
    let userID: String
    let name: String?
    let email: String?
    let profileImageURL: String?
    var favorites: [StationModel] = []
    
    init(auth: AuthDataResultModel) {
        self.userID = auth.uid
        self.name = auth.userName
        self.email = auth.email
        self.profileImageURL = auth.profileImageURL
        self.favorites = []
    }
    
    init(
        userID: String,
        name: String? = nil,
        email: String? = nil,
        profileImageURL: String? = nil,
        favorites: [StationModel] = []
    ) {
        self.userID = userID
        self.name = name
        self.email = email
        self.profileImageURL = profileImageURL
        self.favorites = favorites
    }
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case name = "name"
        case email = "email"
        case profileImageURL = "profile_image_url"
        case favorites = "favorites_radio_stations"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userID = try container.decode(String.self, forKey: .userID)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.profileImageURL = try container.decodeIfPresent(String.self, forKey: .profileImageURL)
        self.favorites = try container.decodeIfPresent([StationModel].self, forKey: .favorites) ?? []
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userID, forKey: .userID)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.profileImageURL, forKey: .profileImageURL)
        try container.encodeIfPresent(self.favorites, forKey: .favorites)
    }
}
