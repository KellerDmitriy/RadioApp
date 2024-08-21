//
//  AuthView.swift
//  RadioApp
//
//  Created by Денис Гиндулин on 28.07.2024.
//

import SwiftUI

// MARK: - SignInView
struct AuthView: View {
    // MARK: - Properties
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    
    @StateObject var viewModel: AuthViewModel
    @State private var isSignUpActive = false
    
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
            // Backgrounds
            AnimatedBackgroundView()
            AuthBackgroundView()
            
            VStack {
                Spacer()
                
                VStack(alignment: .leading) {
                    appLogo
                    titleText
                    subtitleText
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack {
                    inputFields
                    
                    if !isSignUpActive {
                        forgotEmail
                        socialMediaButton
                    }
                    
                    signInButton
                    
                    signUpButton
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
            }
            .animation(.easeOut, value: isSignUpActive)
            .padding()
            .alert(isPresented: isPresentedAlert()) {
                Alert(
                    title: Text(Resources.Text.error.localized(language)),
                    message: Text(viewModel.error?.localizedDescription ?? ""),
                    dismissButton: .default(Text(Resources.Text.ok.localized(language)),
                                            action: viewModel.cancelErrorAlert)
                )
            }
        }
    }
    
    // MARK: - Subviews
    private var appLogo: some View {
        Image("Group 3")
            .resizable()
            .frame(width: UIScreen.width * 1/4, height: UIScreen.width * 1/4)
    }
    
    private var titleText: some View {
        Text(
            isSignUpActive
            ? Resources.Text.signUp.localized(language)
            : Resources.Text.signIn.localized(language)
        )
        .font(.custom(.sfBold, size: UIScreen.height * 1/16))
        .padding(.bottom, UIScreen.height * 1/32)
    }
    
    private var subtitleText: some View {
        Text(
            isSignUpActive
            ? Resources.Text.toStartPlay.localized(language)
            : Resources.Text.toStartPlay.localized(language)
        )
        .font(.custom(.sfRegular, size: UIScreen.height * 1/48))
        .frame(maxWidth: UIScreen.width * 1/3)
    }
    
    private var inputFields: some View {
        VStack {
            if isSignUpActive {
                CustomTextField(
                    placeHolder: Resources.Text.enterName.localized(language), text: $viewModel.username
                )
                .padding(.top, 16)
                
                CustomTextField(
                    placeHolder: Resources.Text.email.localized(language), text: $viewModel.email
                )
                .keyboardType(.emailAddress)
                .padding(.top, 16)
                
                CustomTextField(
                    placeHolder: Resources.Text.password.localized(language),
                    isSecure: true,
                    text: $viewModel.password
                )
                .padding(.top, 16)
            } else {
                CustomTextField(
                    placeHolder: Resources.Text.email.localized(language),
                    text: $viewModel.email
                )
                .keyboardType(.emailAddress)
                .padding(.top, 16)
                
                CustomTextField(
                    placeHolder: Resources.Text.password.localized(language),
                    isSecure: true,
                    text: $viewModel.password
                )
                .padding(.top, 16)
            }
        }
    }
    
    private var forgotEmail: some View {
        HStack {
            Spacer()
            NavigationLink {
                ForgotPasswordView(viewModel: viewModel)
            } label: {
                Text(Resources.Text.forgotPassword.localized(language))
                    .foregroundStyle(DS.Colors.blueNeon)
                    .font(.custom(.sfRegular, size: 14))
                    .padding(.vertical, 8)
                    .padding(.trailing, 8)
            }
        }
    }
    
    private var socialMediaButton: some View {
        VStack {
            VStack {
                Divider()
                Text(Resources.Text.orConnectWith.localized(language))
                Divider()
            }
            .frame(maxWidth: .infinity)
            
            Button(action: googleButtonTap) {
                Image(Resources.Image.googleLogo)
                    .resizableToFit()
                    .frame(width: 40)
            }
        }
    }
    
    private var signInButton: some View {
        NavigationLink(destination: ContentView(), isActive: $viewModel.isAuthenticated) {
            CustomButton(
                action: isSignUpActive
                ? registerUser
                : signIn,
                title: isSignUpActive ? signUpText : signInText,
                buttonType: .onboarding
            )
        }
    }
    
    private var signUpButton: some View {
        Button(action: { isSignUpActive.toggle() }) {
            Text(
                isSignUpActive
                ? Resources.Text.orSignIn.localized(language)
                : Resources.Text.orSignUp.localized(language)
            )
            .foregroundStyle(.white)
        }
    }
    
    private var signInText: String {
        Resources.Text.signIn.localized(language)
    }
    
    private var signUpText: String {
        Resources.Text.signUp.localized(language)
    }
    
    // MARK: - Functions
    private func signIn() {
        Task {
            await viewModel.signIn()
        }
    }
    
    private func registerUser() {
        Task {
            await viewModel.registerUser()
            isSignUpActive.toggle()
        }
    }
    
    private func googleButtonTap() {
        
    }
    
    private func isPresentedAlert() -> Binding<Bool> {
        Binding(get: { viewModel.error != nil },
                set: { isPresenting in
            if isPresenting { return }
        })
    }
}

// MARK: - Preview
#Preview {
    AuthView()
}
