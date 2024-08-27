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
        volume: CGFloat,
        networkService: NetworkService = .shared,
        playerService: PlayerService = .shared
    ) {
        self._viewModel = StateObject(
            wrappedValue: PopularViewModel(
                volume: volume, networkService: networkService,
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
            HStack{
                VolumeView(rotation: false, volume: $viewModel.volume)
                    .frame(width: 33 ,height: 150)
                    .padding(.leading, 15)
                VStack {
                    ScrollView(.vertical, showsIndicators: false){
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 139))], spacing: 15) {
                            
                            ForEach(viewModel.stations, id: \.stationuuid) { item in
                                ZStack {
                                    StationPopularView(
                                    selectedStationID: $viewModel.selectedStation,
                                    volume: $viewModel.volume,
                                    isPlay: $viewModel.isPlay,
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
            do {
                try await viewModel.fetchTopStations()
            } catch let err {
                // handle error
                print(err.localizedDescription)
            }
            viewModel.playFirstStation()
        }
    }
}


// MARK: - Preview
#Preview {
    PopularView(volume: 5.0)
}




