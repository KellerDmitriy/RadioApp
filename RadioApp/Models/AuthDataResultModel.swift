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
    let id: String
    var userName: String
    let email: String
    let profileImageURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userName
        case email
        case profileImageURL
    }
    
    init(user: User) {
        self.id = user.uid
        self.userName = user.displayName ?? ""
        self.email = user.email ?? ""
        self.profileImageURL = user.photoURL?.absoluteString
    }
}

struct DBUser: Identifiable, Codable {
    let id: String
    let name: String
    let email: String
    let profileImagePath: String?
    let profileImagePathUrl: String?
    var favorites: [StationModel] = []
    
    init(auth: AuthDataResultModel) {
        self.id = auth.id
        self.name = auth.userName
        self.email = auth.email
        self.profileImagePath = nil
        self.profileImagePathUrl = nil
        self.favorites = []
    }
    
    static func getTestDBUser() -> DBUser {
       return DBUser(
            id: "",
            name: "",
            email: "",
            profileImagePath: "",
            profileImagePathUrl: ""
          )
    }
    
    init(
        id: String,
        name: String,
        email: String,
        profileImagePath: String?,
        profileImagePathUrl: String?,
        favorites: [StationModel] = []
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.profileImagePath = profileImagePath
        self.profileImagePathUrl = profileImagePathUrl
        self.favorites = favorites
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case name = "name"
        case email = "email"
        case profileImagePath = "profile_image_path"
        case profileImagePathUrl = "profile_image_path_url"
        case favorites = "favorites_radio_stations"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        self.profileImagePath = try container.decodeIfPresent(String.self, forKey: .profileImagePath)
        self.profileImagePathUrl = try container.decodeIfPresent(String.self, forKey: .profileImagePathUrl)
        self.favorites = try container.decodeIfPresent([StationModel].self, forKey: .favorites) ?? []
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.profileImagePath, forKey: .profileImagePath)
        try container.encodeIfPresent(self.profileImagePathUrl, forKey: .profileImagePathUrl)
        try container.encodeIfPresent(self.favorites, forKey: .favorites)
    }
}
