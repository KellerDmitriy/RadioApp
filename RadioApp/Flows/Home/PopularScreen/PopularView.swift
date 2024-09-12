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
            HStack() {
                Text(Resources.Text.popular.localized(language))
                    .font(.custom(DS.Fonts.sfRegular, size: 30))
                    .foregroundStyle(.white)
                
                Spacer()
                
                Picker(
                    LocalizedStringKey("display_order"),
                    selection: $viewModel.selectedOrder) {
                    ForEach(DisplayOrderType.allCases, id: \.self) { order in
                        Text(order.name).tag(order)
                    }
                }
                .accentColor(.white)
                .pickerStyle(MenuPickerStyle())
                .frame(maxWidth: 200)
                .labelsHidden()
                .offset(x: 30)
            }

            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 139))], spacing: 15) {
                    ForEach(viewModel.stations.indices, id: \.self) { index in
                        let station = viewModel.stations[index]
                        let isSelected = station.id == viewModel.currentStation?.id
                        let isFavorite = station.isFavorite
                        
                        ZStack {
                            PopularCellView(
                                isSelect: isSelected,
                                isFavorite: isFavorite,
                                isPlayMusic: playerService.isPlayMusic,
                                station: station,
                                favoriteAction: { viewModel.toggleFavorite() }
                            )
                        }
                        .onTapGesture {
                            viewModel.index = index
                            playerService.indexRadio = index
                            playerService.playAudio()
                        }
                        .onLongPressGesture {
                            if station.id == playerService.currentStation?.id {
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
            }
        }
        .refreshable {
            await refreshTask()
        }
        
        .alert(isPresented: isPresentedAlert()) {
            Alert(
                title: Text(Resources.Text.error.localized(language)),
                message: Text(viewModel.error?.localizedDescription ?? ""),
                dismissButton: .default(Text(Resources.Text.ok.localized(language)),
                                        action: viewModel.cancelErrorAlert)
            )
        }
        
        if isDetailViewActive, let currentStation = viewModel.currentStation {
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
    
    private func refreshTask() async {
        await viewModel.refreshTask()
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
    PopularView(userId: "EySUMWfrYxRzC06bjVW7Yy3P2FE3")
        .environmentObject(PlayerService())
}




