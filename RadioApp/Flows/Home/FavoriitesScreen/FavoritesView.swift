//
//  FavoritesView.swift
//  RadioApp
//
//  Created by Evgeniy K on 01.08.2024.
//

import SwiftUI

struct FavoritesView: View {
    //MARK: - PROPERTIES
    @StateObject var viewModel: FavoritesViewModel
    @EnvironmentObject var playerService: PlayerService
    
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    
    // MARK: - Initializer
    init(
        user: DBUser,
        userService: UserService = .shared,
        networkService: NetworkService = .shared
    ) {
        self._viewModel = StateObject(
            wrappedValue: FavoritesViewModel(
                user: user,
                userService: userService,
                networkService: networkService
            )
        )
    }
    //MARK: - BODY
    var body: some View {
        VStack {
            HStack {
                Text(Resources.Text.favorites.localized(language))
                    .font(.custom(DS.Fonts.sfRegular, size: 30))
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding(.leading)
            .padding(.top, 100)
            .background(DS.Colors.darkBlue)
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    ForEach(viewModel.stations) { station in
                        ZStack {
                            if playerService.currentStation.id != station.id {
                                FavoritesComponentView(
                                    isActive: true,
                                    station: station
                                )
                            }
                        }
                    }
                }
            }
            Spacer()
        }
        .background(DS.Colors.darkBlue)
        .onAppear {
        }
    }
}


// MARK: - Preview
#Preview {
    FavoritesView(user: DBUser.getTestDBUser())
}
