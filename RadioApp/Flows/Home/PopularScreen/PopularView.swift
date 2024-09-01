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
            .padding(.leading)
            .padding(.top, 100)
            .background(DS.Colors.darkBlue)
            
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 139))], spacing: 15) {
                        
                        ForEach(viewModel.stations.indices,  id: \.self) { index in
                            
                            ZStack {
                                StationPopularView(
                                    selectedStationID: $viewModel.selectedStationID,
                                    station: viewModel.stations[index]
                                )
                                
                            }
                            .onTapGesture {
                                viewModel.currentStation = viewModel.stations[index]
                                playerService.playAudio(url: viewModel.selectedStationURL)
                            }
                            .onLongPressGesture {
                                isDetailViewActive = true
                            }
                        }
                    }
                }
            }
        }
        Spacer()
        
            .background(NavigationLink(
                destination: StationDetailsView(station: viewModel.currentStation ?? StationModel.testStation())
                    .environmentObject(playerService),
                isActive: $isDetailViewActive) { EmptyView()
                }
            )
            .background(DS.Colors.darkBlue)
            .task {
                Task {
                    try await viewModel.fetchTopStations()
                }
            }
    }
}



// MARK: - Preview
#Preview {
    PopularView()
        .environmentObject(PlayerService())
}




