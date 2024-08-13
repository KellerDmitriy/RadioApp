//
//  SignInView.swift
//  RadioApp
//
//  Created by Денис Гиндулин on 28.07.2024.
//

import SwiftUI

// MARK: - SignInView
struct SignInView: View {
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
            
            VStack(alignment: .leading) {
                Spacer()
                
                appLogo
                
                titleText
                
                subtitleText
                
                inputFields
                
                socialMediaButton
                
                signInButton
                
                signUpButton
                
                Spacer()
            }
            .padding()
            .alert(isPresented: isPresentedAlert()) {
                Alert(
                    title: Text(Resources.Text.error.localized(language)),
                    message: Text(viewModel.error?.localizedDescription ?? ""),
                    dismissButton: .default(Text(Resources.Text.ok.localized(language)),
                    action: viewModel.cancelErrorAlert)
                )
            }
            NavigationLink(
                destination: SignUpView(),
                isActive: $isSignUpActive
            ) {
                EmptyView()
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
        Text(Resources.Text.signIn.localized(language))
            .font(.custom(.sfBold, size: UIScreen.height * 1/16))
            .padding(.bottom, UIScreen.height * 1/32)
    }
    
    private var subtitleText: some View {
        Text(Resources.Text.toStartPlay.localized(language))
            .font(.custom(.sfRegular, size: UIScreen.height * 1/48))
            .frame(maxWidth: UIScreen.width * 1/3)
    }
    
    private var inputFields: some View {
        VStack {
            CustomTextField(
                value: $viewModel.email,
                placeHolder: Resources.Text.email.localized(language),
                titleBorder: Resources.Text.email
            )
            .autocapitalization(.none)
            .keyboardType(.emailAddress)
            .padding(.top, 16)
            
            CustomTextField(
                value: $viewModel.password,
                placeHolder: Resources.Text.password.localized(language),
                titleBorder: Resources.Text.password.localized(language),
                isSecure: true
            )
            .padding(.top, 16)
            .autocapitalization(.none)
        }
        
    }
    
    private var socialMediaButton: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(Resources.Text.orConnectWith.localized(language))
            
            Button(action: {}) {
                Text("G+")
                    .foregroundStyle(.white)
            }
        }
    }
    
    private var signInButton: some View {
        NavigationLink(destination: ContentView(), isActive: $viewModel.isAuthenticated) {
            CustomButton(action: {
                Task {
                    await signIn()
                }
            },
            title: Resources.Text.signIn.localized(language),
            buttonType: .onboarding
            )
        }
    }
    
    private var signUpButton: some View {
        Button(action: { isSignUpActive = true }) {
            Text(Resources.Text.orSignUp.localized(language))
                .foregroundStyle(.white)
        }
    }
    
    // MARK: - Functions
    private func signIn() async {
        await viewModel.signIn()
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
    SignInView()
}
