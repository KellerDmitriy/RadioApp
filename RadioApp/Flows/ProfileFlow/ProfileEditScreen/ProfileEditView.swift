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
    
    @State private var showChangedView = false
    @State private var blurBackground = false
    @State private var isImagePickerPresented = false
    @State private var imagePickerSource: UIImagePickerController.SourceType = .camera
    
    init(
        userEmail: String,
        userName: String,
        profileImage: UIImage?,

        authService: AuthService = .shared,
        firebaseService: FirebaseStorageService = .shared
    ) {
        self._viewModel = StateObject(
            wrappedValue: ProfileEditViewModel(
                userEmail: userEmail,
                userName: userName,
                profileImage: profileImage,
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
                            profileImage: $viewModel.profileImage,
                            showChangedPhotoView: $showChangedView
                        )
                        
                        // MARK: - Editable Fields Section
                        CustomTextField(
                            value: $viewModel.userName,
                            placeHolder: Resources.Text.enterName,
                            titleBorder: Resources.Text.fullName
                        )
                        .padding(.top, Drawing.fieldTopPadding)
                        
                        CustomTextField(
                            value: $viewModel.userEmail,
                            placeHolder: Resources.Text.enterEmail,
                            titleBorder: Resources.Text.email
                        )
                        .padding(.top, Drawing.fieldTopPadding)
                        
                        Spacer()
                        
                        CustomButton(
                            action: {
                                saveImageURL()
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
                viewModel.profileImage = image
            }
            .edgesIgnoringSafeArea(.all)
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
    func saveImageURL() {
//        viewModel.saveProfileImage(T##image: UIImage##UIImage)
    }
}

// MARK: - Preview
struct ProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditView(
            userEmail: "stephen@ds", userName: "Stephen",
            profileImage: (UIImage(named: "stephen")!)
        )
    }
}
