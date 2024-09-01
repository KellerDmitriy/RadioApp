//
//  ProfileEditView.swift
//  RadioApp
//
//  Created by Dmitriy Eliseev on 28.07.2024.
//

import SwiftUI

struct ProfileEditView: View {
    // MARK: - Properties
    @StateObject var viewModel: ProfileEditViewModel
    @State private var selectedProfileImage: UIImage? = nil
    @State private var showChangedView = false
    @State private var blurBackground = false
    @State private var isImagePickerPresented = false
    @State private var imagePickerSource: UIImagePickerController.SourceType = .camera
    
    init(
        userService: UserService = .shared,
        authService: AuthService = .shared,
        firebaseService: FirebaseStorageService = .shared
    ) {
        self._viewModel = StateObject(
            wrappedValue: ProfileEditViewModel(
                userService: userService,
                authService: authService,
                firebaseStorage: firebaseService
            )
        )
    }
    
    // MARK: - Drawing Constants
    private struct Drawing {
        static let avatarSize: CGFloat = 100
        static let editIconSize: CGFloat = 32
        static let spacing: CGFloat = 16
        static let topPadding: CGFloat = 50
        static let fieldTopPadding: CGFloat = 40
        static let iconOffset: CGFloat = 35
        static let textFontSize: CGFloat = 14
        static let blurRadius: CGFloat = 10
        static let overlayOpacity: CGFloat = 0.4
        static let changePhotoViewWidth: CGFloat = 300
        static let changePhotoViewHeight: CGFloat = 200
        static let changePhotoViewCornerRadius: CGFloat = 12
        static let changePhotoViewShadowRadius: CGFloat = 10
    }
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    AnimatedBackgroundView()
                        .ignoresSafeArea()
                    
                    VStack(spacing: Drawing.spacing) {
                        // MARK: - Profile Image Section
                        ProfileHeaderView(
                            userName: $viewModel.userName,
                            userEmail: $viewModel.userEmail,
                            profileImageURL: $viewModel.profileImage,
                            showChangedPhotoView: $showChangedView
                        )
                        
                        // MARK: - Editable Fields Section
                        CustomTextField(
                            placeHolder: Resources.Text.enterName,
                            text: $viewModel.userName
                        )
                        .padding(.top, Drawing.fieldTopPadding)
                        
                        CustomTextField(
                            placeHolder: Resources.Text.enterEmail, text: $viewModel.userEmail
                        )
                        .keyboardType(.emailAddress)
                        .padding(.top, Drawing.fieldTopPadding)
                        
                        Spacer()
                        
                        CustomButton(
                            action: {
                                Task {
                                    await viewModel.updateUserName()
                                }
                                if let selectedProfileImage = selectedProfileImage {
                                    saveImage(selectedProfileImage)
                                }
                            },
                            title: Resources.Text.saveChanges,
                            buttonType: .profile
                        )
                        
                        Spacer()
                    }
                    .padding(.top, Drawing.topPadding)
                    .padding(Drawing.spacing)
                    .navigationTitle(Resources.Text.profile.capitalized)
                    .navigationBarBackButtonHidden(true)
                    
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            BackBarButton()
                        }
                    }
                }
            }
            .blur(radius: showChangedView ? Drawing.blurRadius : 0)
            
            if showChangedView {
                Color.black.opacity(Drawing.overlayOpacity)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            hideChangedPhotoView()
                        }
                    }
                
                ChangePhotoView(
                    onTakePhoto: {
                        showImagePicker(source: .camera)
                        hideChangedPhotoView()
                    },
                    onChoosePhoto: {
                        showImagePicker(source: .photoLibrary)
                        hideChangedPhotoView()
                    },
                    onDeletePhoto: {
                        deletePhoto()
                        hideChangedPhotoView()
                    }
                )
                .frame(width: Drawing.changePhotoViewWidth, height: Drawing.changePhotoViewHeight)
                .background(Color.white)
                .cornerRadius(Drawing.changePhotoViewCornerRadius)
                .shadow(radius: Drawing.changePhotoViewShadowRadius)
                .transition(.move(edge: .top))
                .zIndex(1)
            }
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(sourceType: imagePickerSource) { image in
                selectedProfileImage = image
            }
            .edgesIgnoringSafeArea(.all)
        }
        .task {
            try? await viewModel.loadCurrentUser()
        }
    }
    
    // MARK: - Helper Functions
    func showChangedPhotoView() {
        blurBackground = true
        showChangedView = true
    }
    
    func hideChangedPhotoView() {
        blurBackground = false
        showChangedView = false
    }
    
    func showImagePicker(source: UIImagePickerController.SourceType) {
        imagePickerSource = source
        isImagePickerPresented = true
    }
    
    func deletePhoto() {
        viewModel.deleteProfileImage()
    }
    
    func saveImage(_ image: UIImage) {
        viewModel.saveProfileImage(image)
    }
    
    // MARK: - Helper Functions
    private func image(_ image: UIImage?) -> Image {
        if let profileImage = image {
            return Image(uiImage: profileImage)
        } else {
            return Image(uiImage: UIImage(systemName: "person.fill")!)
        }
    }

}

// MARK: - Preview
#Preview {
    ProfileEditView()
}
