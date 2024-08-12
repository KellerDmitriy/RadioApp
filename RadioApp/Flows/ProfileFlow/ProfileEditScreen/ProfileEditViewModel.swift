//
//  ProfileEditViewModel.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 11.08.2024.
//

import SwiftUI

final class ProfileEditViewModel: ObservableObject {

    
    @Published private(set) var currentUser: DBUser? = nil
    @Published var error: ProfileFlowError?
    
    var userEmail: String
    var userName: String
    var profileImage: UIImage?
    
    private let userService: UserService
    private let authService: AuthService
    private let firebaseStorage: FirebaseStorageService
    
    // MARK: - Initializer
    init(
        userEmail: String,
        userName: String,
        profileImage: UIImage?,
        userService: UserService = .shared,
        authService: AuthService = .shared,
        firebaseStorage: FirebaseStorageService = .shared)
    {
        self.userEmail = userEmail
        self.userName = userName
        self.profileImage = profileImage
        
        self.userService = userService
        self.authService = authService
        self.firebaseStorage = firebaseStorage
    }
    
    func saveProfileImage(_ image: UIImage) {
        guard let currentUser else { return }
        
        Task {
            let (path, name) = try await firebaseStorage.saveImage(
                image: image,
                userID: currentUser.userID
            )
            
            print("SUCCESS!")
            print(path)
            let url = try await firebaseStorage.getUrlForImage(path: path)
            try await userService.updateUserProfileImagePath(
                userId: currentUser.userID,
                path: path,
                url: url.absoluteString
            )
        }
    }
    
    func deleteProfileImage() {
        guard let currentUser, let path = currentUser.profileImagePath else { return }
        
        Task {
            try await firebaseStorage.deleteImage(path: path)
            try await userService.updateUserProfileImagePath(
                userId: currentUser.userID,
                path: nil,
                url: nil
            )
        }
    }
}
