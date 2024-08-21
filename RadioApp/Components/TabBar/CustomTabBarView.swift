//
//  CustomTabBarView.swift
//  RadioApp
//
//  Created by Dmitriy Eliseev on 28.07.2024.
//

import SwiftUI


// MARK: - CustomTabBarView
struct CustomTabBarView: View {
    @State var isActiveDetailView = false
    @Binding var selectedTab: Tab
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    // MARK: - Body
    var body: some View {
        HStack {
            // Popular Button
            Button {
                selectedTab = .popular
//                appManager.isActiveDetailView = false
            } label: {
                VStack {
                    Text(selectedTab == .popular 
                         ? Resources.Text.popular.localized(language)
                         : Resources.Text.popular.localized(language)
                    )
                        .font(.custom(DS.Fonts.sfMedium, size: 19))
                        .foregroundColor(selectedTab == .popular ? Color.white : DS.Colors.grayNotActive)

                    Circle()
                        .frame(width: 15, height: 15)
                        .foregroundColor(selectedTab == .popular ? DS.Colors.blueNeon : DS.Colors.darkBlue)
                        .clipShape(Circle())
                }
            }
            .frame(maxWidth: UIScreen.main.bounds.width / 3)

            // Favorites Button
            Button {
                selectedTab = .favorites
//                appManager.isActiveDetailView = false
            } label: {
                VStack {
                    Text(selectedTab == .favorites 
                         ? Resources.Text.favorites.localized(language)
                         : Resources.Text.favorites.localized(language)
                    )
                        .font(.custom(DS.Fonts.sfMedium, size: 19))
                        .foregroundColor(selectedTab == .favorites ? Color.white : DS.Colors.grayNotActive)
                    
                    Circle()
                        .frame(width: 15, height: 15)
                        .foregroundColor(selectedTab == .favorites ? DS.Colors.blueNeon : DS.Colors.darkBlue)
                        .clipShape(Circle())
                }
            }
            .frame(maxWidth: UIScreen.main.bounds.width / 3)

            // All Stations Button
            Button {
                selectedTab = .allStations
//                appManager.isActiveDetailView = false
            } label: {
                VStack {
                    Text(selectedTab == .allStations 
                         ? Resources.Text.allStations.localized(language)
                         : Resources.Text.allStations.localized(language)
                    )
                        .font(.custom(DS.Fonts.sfMedium, size: 19))
                        .foregroundColor(selectedTab == .allStations ? Color.white : DS.Colors.grayNotActive)

                    Circle()
                        .frame(width: 15, height: 15)
                        .foregroundColor(selectedTab == .allStations ? DS.Colors.blueNeon : DS.Colors.darkBlue)
                        .clipShape(Circle())
                }
            }
            .frame(maxWidth: UIScreen.main.bounds.width / 3)
        }
        .overlay {
            HStack(spacing: 30) {
                BackButtonView()
                PlayButtonView()
                ForwardButtonView()
            }
            .offset(CGSize(width: 4, height: -120))
        }
        .frame(height: 80)
        .padding(.bottom, 3)
        .background(DS.Colors.darkBlue)
    }
}

// MARK: - Preview
#Preview {
    CustomTabBarView(selectedTab: .constant(.popular))
//        .environmentObject(HomeViewModel())
}
