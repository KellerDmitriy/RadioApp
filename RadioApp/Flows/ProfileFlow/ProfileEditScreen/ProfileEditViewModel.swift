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
    
    @Published var userEmail: String
    @Published var userName: String
    @Published var profileImage: UIImage?
    
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
            try await userService.updateUserProfileImageURL(
                userId: currentUser.userID,
                url: url.absoluteString
            )
        }
    }
    
    func deleteProfileImage() {
        guard let currentUser, let path = currentUser.profileImageURL else { return }
        
        Task {
            try await firebaseStorage.deleteImage(path: path)
            try await userService.updateUserProfileImageURL(
                userId: currentUser.userID,
                url: nil
            )
        }
    }
}
