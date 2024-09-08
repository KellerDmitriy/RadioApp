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
        userId: String,
        networkService: NetworkService = .shared
    ) {
        self._viewModel = StateObject(
            wrappedValue: AllStationViewModel(
                userId: userId,
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
                        ForEach(viewModel.stations, id: \.id) { station in
                            NavigationLink {
                                DetailsView(viewModel.userId,
                                            station: station)
                                    .environmentObject(playerService)
                            } label: {
                                StationCellView(
                                    isActive: true,
                                    isVote: viewModel.checkFavorite(),
                                    voteAction: { viewModel.checkFavorite() },
                                    station: station
                                )
                                    
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
    AllStationsView(userId: "")
}
