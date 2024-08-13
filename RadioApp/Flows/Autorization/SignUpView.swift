//
//  SignUpView.swift
//  RadioApp
//
//  Created by Денис Гиндулин on 28.07.2024.
//

import SwiftUI

// MARK: - SignUpView
struct SignUpView: View {
    // MARK: - Properties
    @StateObject var viewModel: AuthViewModel
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    
    // MARK: - Initializer
    init(
        authService: AuthService = .shared
    ) {
        self._viewModel = StateObject(
            wrappedValue: AuthViewModel(
                authService: authService
            )
        )
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Background Views
            AnimatedBackgroundView()
            AuthBackgroundView()
            
            // Content
            VStack(alignment: .leading) {
                Spacer()
                
                // App Logo
                Image("Group 3")
                    .resizable()
                    .frame(width: UIScreen.width * 1/4, height: UIScreen.width * 1/4)
                
                // Title Text
                Text(Resources.Text.signUp.localized(language))
                    .font(.custom(.sfBold, size: UIScreen.height * 1/16))
                    .padding(.bottom, UIScreen.height * 1/32)
                

                // Input Fields
                CustomTextField(
                    value: $viewModel.username,
                    placeHolder: Resources.Text.enterName.localized(language),
                    titleBorder: Resources.Text.name.localized(language)
                )
                .autocapitalization(.none)
                .padding(.top, 16)
                
                CustomTextField(
                    value: $viewModel.email,
                    placeHolder: Resources.Text.email.localized(language),
                    titleBorder: Resources.Text.email
                )
                .autocapitalization(.none)
                .padding(.top, 16)
                .keyboardType(.emailAddress)
                
                CustomTextField(
                    value: $viewModel.password,
                    placeHolder: Resources.Text.password.localized(language),
                    titleBorder: Resources.Text.password.localized(language),
                    isSecure: true
                )
                .autocapitalization(.none)
                .padding(.top, 16)
                                
                // Register Button
                CustomButton(action: viewModel.registerUser, title: Resources.Text.signUp.localized(language), buttonType: .onboarding)
                // TODO: изменить тип кнопки
                
                // Sign In Button
                Button(action: {}) {
                    Text(Resources.Text.orSignIn.localized(language))
                        .foregroundStyle(.white)
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackBarButton()
            }
        }
    }
}

// MARK: - Preview
#Preview {
    SignUpView()
}
