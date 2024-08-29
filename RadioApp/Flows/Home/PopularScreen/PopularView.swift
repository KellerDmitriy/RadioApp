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

    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    
    init(
        isPlayMusic: Bool,
        volume: CGFloat,
        networkService: NetworkService = .shared,
        playerService: PlayerService = .shared
    ) {
        self._viewModel = StateObject(
            wrappedValue: PopularViewModel(
                isPlayMusic: isPlayMusic,
                volume: volume,
                networkService: networkService,
                playerService: playerService
            )
        )
    }
    
    //MARK: - BODY
    var body: some View {
        VStack{
            HStack {
                Text(Resources.Text.popular.localized(language))
                    .font(.custom(DS.Fonts.sfRegular, size: 30))
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding(.leading, 60)
            .padding(.top, 100)
            .background(DS.Colors.darkBlue)
            HStack {
                VolumeView(rotation: false, volume: $viewModel.volume)
                    .frame(width: 33 ,height: 250)
                    .padding(.leading, 15)
                VStack {
                    ScrollView(.vertical, showsIndicators: false){
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 139))], spacing: 15) {
                            
                            ForEach(viewModel.stations, id: \.stationuuid) { item in
                                ZStack {
                                    StationPopularView(
                                    selectedStationID: $viewModel.selectedStation,
                                    volume: $viewModel.volume,
                                    isPlay: $viewModel.isPlayMusic,
                                    station: item
                                    )
                                        .frame(width: 139, height: 139)
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
        
            Spacer()
        }
        .background(DS.Colors.darkBlue)
        .task {
            Task {
                try await viewModel.fetchTopStations()
                print(viewModel.isPlayMusic)
            }
//            viewModel.playFirstStation()
        }
    }
}


// MARK: - Preview
#Preview {
    PopularView(isPlayMusic: true, volume: 5.0)
}




