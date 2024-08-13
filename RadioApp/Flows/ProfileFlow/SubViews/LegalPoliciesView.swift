//
//  LegalPoliciesView.swift
//  RadioApp
//
//  Created by Dmitriy Eliseev on 28.07.2024.
//

import SwiftUI

struct LegalPoliciesView: View {
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    
    var body: some View {
        ZStack {
            DS.Colors.darkBlue
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading) {
                    Text(Resources.Text.terms.localized(language))
                        .font(.custom(.sfBold, size: 18))
                    
                    Text(Resources.Text.termsDescription.localized(language))
                        .padding(.top, 6)
                    
                    Text(Resources.Text.termsDescription2.localized(language))
                    
                    Text(Resources.Text.changesToService.localized(language))
                        .font(.custom(.sfBold, size: 16))
                        .padding(.top, 20)
                    
                    Text(Resources.Text.changesDescription.localized(language))
                        .padding(.top, 6)
                    
                    Text(Resources.Text.changesDescription2.localized(language))
                    
                    Spacer()
                }
                .font(.custom(.sfBold, size: 16))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .navigationTitle(Resources.Text.legalAndPolicies.localized(language))
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
    LegalPoliciesView()
}
