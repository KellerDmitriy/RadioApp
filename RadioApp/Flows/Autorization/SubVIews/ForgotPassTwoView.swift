//
//  ForgotPassTwoView.swift
//  RadioApp
//
//  Created by Денис Гиндулин on 04.08.2024.
//

import SwiftUI

struct ForgotPassTwoView: View {
    @StateObject var viewModel: AuthViewModel
    
    // MARK: - Initializer
    init() {
        self._viewModel = StateObject(
            wrappedValue: AuthViewModel(
            )
        )
    }
    
    var body: some View {
        ZStack {
            AnimatedBackgroundView()
            AuthBackgroundView()
            
            VStack(alignment: .leading) {
                Spacer()
                
                BackBarButton()
                
                Text(Resources.Text.forgotPassword)
                    .font(.custom(.sfBold, size: UIScreen.height * 1/16))
                    .padding(.bottom, UIScreen.height * 1/32)
                
                SecureField(Resources.Text.password, text: $viewModel.password)
                    .font(.title)
                
                SecureField(Resources.Text.confirmPassword, text: $viewModel.password)
                    .font(.title)
                                
                CustomButton(action: {}, title: Resources.Text.changePassword, buttonType: .onboarding) // TODO: изменить тип кнопки и добавить действие
                
                Spacer()
            }
            .padding()
        }
    }
}


