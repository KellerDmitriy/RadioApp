//
//  PopularView.swift
//  RadioApp
//
//  Created by Dmitriy Eliseev on 31.07.2024.
//

import SwiftUI

struct PopularView: View {
    //MARK: - PROPERTIES
    @StateObject var viewModel: PopularViewModel
    @EnvironmentObject var playerService: PlayerService
    
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    
    @State private var isDetailViewActive = false
    
    // MARK: - Initializer
    init(
        userId: String,
        userService: UserService = .shared,
        networkService: NetworkService = .shared
    ) {
        self._viewModel = StateObject(
            wrappedValue: PopularViewModel(
                userId: userId,
                userService: userService,
                networkService: networkService
            )
        )
    }
    
    //MARK: - BODY
    var body: some View {
        VStack {
            HStack {
                Text(Resources.Text.popular.localized(language))
                    .font(.custom(DS.Fonts.sfRegular, size: 30))
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding(.top, 100)
            .background(DS.Colors.darkBlue)
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 139))], spacing: 15) {
                    ForEach(viewModel.stations, id: \.id) { station in
                        ZStack {
                            PopularCellView(
                                isSelect: station.id == playerService.currentStation.id,
                                isFavorite: station.isFavorite ?? false,
                                isPlayMusic: playerService.isPlayMusic,
                                station: station,
                                favoriteAction: { viewModel.toggleFavorite(station: station)}
                            )
                            .onTapGesture {
                                playerService.currentStation = station
                                playerService.playAudio()
                            }
                            
                            .onLongPressGesture {
                                isDetailViewActive = true
                            }
                        }
                    }
                }
            }
        }
        .background(DS.Colors.darkBlue)
        .task {
            Task {
                await viewModel.fetchTopStations()
                playerService.addStationForPlayer(viewModel.stations)
                if viewModel.error == nil {
                    playerService.playAudio()
                }
            }
        }
        
        .alert(isPresented: isPresentedAlert()) {
            Alert(
                title: Text(Resources.Text.error.localized(language)),
                message: Text(viewModel.error?.localizedDescription ?? ""),
                dismissButton: .default(Text(Resources.Text.ok.localized(language)),
                                        action: viewModel.cancelErrorAlert)
            )
        }
        
        if let currentStation = viewModel.currentStation {
                NavigationLink(
                    destination: DetailsView(
                        viewModel.userId,
                        station: currentStation
                    )
                    .environmentObject(playerService),
                    isActive: $isDetailViewActive
                ) {
                    EmptyView()
                }
            }
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
    PopularView(userId: "")
        .environmentObject(PlayerService())
}




