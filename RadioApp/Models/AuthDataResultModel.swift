//
//  UserModel.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 12.08.2024.
//

import Foundation
import FirebaseAuth

// MARK: - GoogleSignInResultModel
// Model to store the result of a Google Sign-In, containing the ID and access tokens
struct GoogleSignInResultModel {
    let idToken: String       // The ID token returned by Google Sign-In
    let accessToken: String   // The access token returned by Google Sign-In
}

// MARK: - AuthDataResultModel
// Model to store authentication data, conforming to Codable for easy JSON encoding/decoding
struct AuthDataResultModel: Codable {
    let uid: String            // The unique identifier for the user
    var userName: String       // The user's display name
    let email: String          // The user's email address
    let profileImageURL: String?  // The URL of the user's profile image (optional)

    // MARK: - CodingKeys
    // Custom keys for encoding/decoding, in case the property names differ from the JSON keys
    enum CodingKeys: String, CodingKey {
        case uid
        case userName
        case email
        case profileImageURL
    }
    
    // MARK: - Initializer
    // Initializes the model using a Firebase `User` object
    init(user: User) {
        self.uid = user.uid
        self.userName = user.displayName ?? ""
        self.email = user.email ?? ""
        self.profileImageURL = user.photoURL?.absoluteString
    }
}

// MARK: - DBUser
// Model representing a user stored in the database, conforming to Codable
struct DBUser: Codable {
    let userID: String              // The unique identifier for the user in the database
    let name: String                // The user's display name
    let email: String               // The user's email address
    let profileImagePath: String?   // The file path to the user's profile image (optional)
    let profileImagePathUrl: String? // The URL to the user's profile image (optional)
    var favorites: [StationModel] = []  // A list of the user's favorite radio stations

    // MARK: - Initializers

    // Initializes a DBUser using an AuthDataResultModel
    init(auth: AuthDataResultModel) {
        self.userID = auth.uid
        self.name = auth.userName
        self.email = auth.email
        self.profileImagePath = nil
        self.profileImagePathUrl = nil
        self.favorites = []
    }
    
    // Static method to provide a test instance of DBUser
    static func getTestDBUser() -> DBUser {
        return DBUser(
            userID: "",
            name: "",
            email: "",
            profileImagePath: "",
            profileImagePathUrl: "",
            favorites: []
        )
    }
    
    // Custom initializer to create a DBUser with specified values
    init(
        userID: String,
        name: String,
        email: String,
        profileImagePath: String?,
        profileImagePathUrl: String?,
        favorites: [StationModel] = []
    ) {
        self.userID = userID
        self.name = name
        self.email = email
        self.profileImagePath = profileImagePath
        self.profileImagePathUrl = profileImagePathUrl
        self.favorites = favorites
    }
    
    // MARK: - CodingKeys
    // Custom keys for encoding/decoding to handle different JSON keys
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"                   // Maps "user_id" JSON key to "userID" property
        case name = "name"
        case email = "email"
        case profileImagePath = "profile_image_path"     // Maps "profile_image_path" JSON key to "profileImagePath" property
        case profileImagePathUrl = "profile_image_path_url" // Maps "profile_image_path_url" JSON key to "profileImagePathUrl" property
        case favorites = "favorites"
    }
    
    // Custom initializer for decoding JSON into a DBUser instance
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userID = try container.decode(String.self, forKey: .userID)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        self.profileImagePath = try container.decodeIfPresent(String.self, forKey: .profileImagePath)
        self.profileImagePathUrl = try container.decodeIfPresent(String.self, forKey: .profileImagePathUrl)
        self.favorites = try container.decodeIfPresent([StationModel].self, forKey: .favorites) ?? []
    }
    
    // Method to encode a DBUser instance into JSON
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userID, forKey: .userID)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.profileImagePath, forKey: .profileImagePath)
        try container.encodeIfPresent(self.profileImagePathUrl, forKey: .profileImagePathUrl)
        try container.encodeIfPresent(self.favorites, forKey: .favorites)
    }
}
