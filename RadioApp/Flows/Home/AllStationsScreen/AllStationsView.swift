//
//  AllStationsView.swift
//  RadioApp
//
//  Created by Evgeniy K on 01.08.2024.
//

import SwiftUI

struct AllStationsView: View {
    @StateObject var viewModel: AllStationViewModel
    @EnvironmentObject var playerService: PlayerService
    
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    
    @State private var isSearching: Bool = false
    
    init(
        networkService: NetworkService = .shared
    ) {
        self._viewModel = StateObject(
            wrappedValue: AllStationViewModel(
                 networkService: networkService
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
            .padding(.leading)
            .padding(.top, 100)
            // search view
            SearchBarView(
                searchText: $viewModel.searchText,
                isSearching: $isSearching
            )
            .frame(height: 56)
            Spacer()
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(pinnedViews: .sectionHeaders) {
                        ForEach(viewModel.stations, id: \.stationuuid) { station in
                            NavigationLink {
                                StationDetailsView()
                                    .environmentObject(playerService)
                            } label: {
                                StationView(isActive: true, station: station)
                                    
                            }
                        }
                    }
                    .background(DS.Colors.darkBlue)
                    .navigationViewStyle(.stack)
                }
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
    AllStationsView()
}
