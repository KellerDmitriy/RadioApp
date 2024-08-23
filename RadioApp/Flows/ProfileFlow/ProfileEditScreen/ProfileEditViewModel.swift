//
//  ProfileEditViewModel.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 11.08.2024.
//

import SwiftUI
@MainActor
final class ProfileEditViewModel: ObservableObject {
    
    @Published private(set) var currentUser: DBUser? = nil
    @Published var error: ProfileFlowError?
    
    @Published var userName: String = ""
    @Published var userEmail: String = ""
    @Published var profileImage: URL? = nil
    
    private let userService: UserService
    private let authService: AuthService
    private let firebaseStorage: FirebaseStorageService
    
    // MARK: - Initializer
    init(
        userService: UserService = .shared,
        authService: AuthService = .shared,
        firebaseStorage: FirebaseStorageService = .shared)
    {
        self.userService = userService
        self.authService = authService
        self.firebaseStorage = firebaseStorage
    }
    
    func loadCurrentUser() async throws {
        let authDataResult = try authService.getAuthenticatedUser()
        self.currentUser = try await userService.getUser(userId: authDataResult.uid)
        if let currentUser = currentUser {
            userName = currentUser.name
            userEmail = currentUser.email
            profileImage = URL(string: currentUser.profileImagePathUrl ?? "")
        }
    }
    
    func updateUserName() async {
        guard let currentUser else { return }
        do {
            try await userService.updateUserName(userName, userID: currentUser.userID)
        } catch {
            self.error = ProfileFlowError.map(error)
        }
    }
    
    func updateUserEmail() async {
        guard let currentUser else { return }
        do {
            try await authService.updateEmail(email: userEmail)
            try await userService.updateUserEmail(userEmail, userID: currentUser.userID)
        } catch {
            self.error = ProfileFlowError.map(error)
        }
    }
    
    func saveProfileImage(_ image: UIImage) {
        guard let currentUser = currentUser else { return }
        
        Task {
       
            guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
            
            do {
                let (path, _) = try await firebaseStorage.saveImage(data: imageData, userID: currentUser.userID)
                
                let url = try await firebaseStorage.getUrlForImage(path: path)
              
                try await userService.updateUserProfileImagePath(
                    userId: currentUser.userID,
                    path: path,
                    url: url.absoluteString
                )
            } catch {
                self.error = ProfileFlowError.map(error)
            }
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
