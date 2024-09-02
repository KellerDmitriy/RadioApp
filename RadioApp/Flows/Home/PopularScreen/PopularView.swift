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
        networkService: NetworkService = .shared
    ) {
        self._viewModel = StateObject(
            wrappedValue: PopularViewModel(
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
                    ForEach(viewModel.stations.indices,  id: \.self) { index in
                        ZStack {
                            if playerService.currentStation.stationuuid == viewModel.stations[index].stationuuid {
                                StationPopularView(
                                    isActive: true,
                                    station: viewModel.stations[index]
                                )
                                .onLongPressGesture {
                                    isDetailViewActive = true
                                }
                            } else {
                                StationPopularView(
                                    isActive: false,
                                    station: viewModel.stations[index]
                                )
                                .onTapGesture {
                                    playerService.indexRadio = index
                                    playerService.playAudio()
                                }
                            }
                        }
                    }
                }
            }
        }
        .background(DS.Colors.darkBlue)
        .task {
            Task {
                try await viewModel.fetchTopStations()
                playerService.addStationForPlayer(viewModel.stations)
                playerService.playAudio()
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
        
        NavigationLink(
            destination: StationDetailsView()
                .environmentObject(playerService),
            isActive: $isDetailViewActive) {
                EmptyView()
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
    PopularView()
        .environmentObject(PlayerService())
}




