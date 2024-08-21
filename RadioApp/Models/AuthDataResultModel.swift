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
    let photoURL: String?
    let profileImagePath: String?
    let profileImagePathUrl: String?
    
    init(auth: AuthDataResultModel) {
        self.userID = auth.uid
        self.name = auth.userName
        self.email = auth.email
        self.photoURL = auth.profileImageURL
        self.profileImagePath = nil
        self.profileImagePathUrl = nil
    }
    
    init(
        userID: String,
        name: String? = nil,
        email: String? = nil,
        photoURL: String? = nil,
        profileImagePath: String? = nil,
        profileImagePathUrl: String? = nil
    ) {
        self.userID = userID
        self.name = name
        self.email = email
        self.photoURL = photoURL
        self.profileImagePath = profileImagePath
        self.profileImagePathUrl = profileImagePathUrl
    }
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case name = "name"
        case email = "email"
        case photoUrl = "photo_url"
        case profileImagePath = "profile_image_path"
        case profileImagePathUrl = "profile_image_path_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userID = try container.decode(String.self, forKey: .userID)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoURL = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.profileImagePath = try container.decodeIfPresent(String.self, forKey: .profileImagePath)
        self.profileImagePathUrl = try container.decodeIfPresent(String.self, forKey: .profileImagePathUrl)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userID, forKey: .userID)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoURL, forKey: .photoUrl)
        try container.encodeIfPresent(self.profileImagePath, forKey: .profileImagePath)
        try container.encodeIfPresent(self.profileImagePathUrl, forKey: .profileImagePathUrl)
    }
}
