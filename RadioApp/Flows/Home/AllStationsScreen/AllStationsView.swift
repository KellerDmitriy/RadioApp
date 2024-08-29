//
//  AllStationsView.swift
//  RadioApp
//
//  Created by Evgeniy K on 01.08.2024.
//

import SwiftUI

struct AllStationsView: View {
    @StateObject var viewModel: AllStationViewModel
    
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
  
    @State private var isSearching: Bool = false
    
    init(
        volume: CGFloat,
        networkService: NetworkService = .shared,
        playerService: PlayerService = .shared
    ) {
        self._viewModel = StateObject(
            wrappedValue: AllStationViewModel(
                volume: volume, networkService: networkService,
                playerService: playerService
            )
        )
    }
    
    var body: some View {
        VStack{
            HStack {
                Text(Resources.Text.allStations.localized(language))
                    .font(.custom(DS.Fonts.sfRegular, size: 30))
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding(.leading, 60)
            .padding(.top, 100)
            // search view
            SearchBarView(
                searchText: $viewModel.searchText,
                isSearching: $isSearching
            )
                .frame(height: 56)
            Spacer()
            HStack{
                VolumeView(rotation: false, 
                           volume: $viewModel.volume
                )
                    .frame(width: 33 ,height: 250)
                    .padding(.leading, 15)
                VStack {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(pinnedViews: .sectionHeaders) {
                            ForEach(viewModel.stations, id: \.stationuuid) { station in
                                NavigationLink {
                                    StationDetailsView(station: station, volume: $viewModel.volume
                                    )
                                    
                                } label: {
                                    StationView(station: station, selectedStationID: $viewModel.selectedStation, volume: $viewModel.volume)
                                }
                            }
                        }
                        .background(DS.Colors.darkBlue)
                        .navigationViewStyle(.stack)
                    }
                }
                Spacer()
            }
            Spacer()
        }
        .background(DS.Colors.darkBlue)
        .task {
            do {
                try await viewModel.fetchAllStations()
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    AllStationsView(volume: 5.0)
}
