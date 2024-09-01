//
//  ForgotPassOneView.swift
//  RadioApp
//
//  Created by Денис Гиндулин on 04.08.2024.
//

import SwiftUI

struct ForgotPasswordView: View {
    // MARK: - Properties
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    
    @StateObject var viewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            AnimatedBackgroundView()
            AuthBackgroundView()
            
            VStack(alignment: .leading) {
                Spacer()
                
                Text(Resources.Text.forgotPassword
                    .localized(language)
                )
                    .font(
                        .custom(.sfBold,
                         size: UIScreen.height * 1/16)
                    )
                    .padding(
                        .bottom,
                        UIScreen.height * 1/32
                    )
                
                CustomTextField(
                    placeHolder: Resources.Text.email.localized(language), text: $viewModel.forgotEmail
                )
                .keyboardType(.emailAddress)
                .padding(.bottom, 16)
                
                CustomButton(
                    action: customButtonTap,
                    title: Resources.Text.sent.localized(language),
                    buttonType: .onboarding
                )
                
                Spacer()
            }
            .padding()
            .navigationTitle(Resources.Text.forgotPassword.localized(language))
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackBarButton()
                }
            }
        }
    }
    
    private func customButtonTap() {
        Task {
           await viewModel.resetPassword()
        }
    }
}

    // MARK: - Preview
    #Preview {
        ForgotPasswordView(viewModel: AuthViewModel())
    }
