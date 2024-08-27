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
    
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language

    
    init(
        volume: CGFloat,
        networkService: NetworkService = .shared,
        playerService: PlayerService = .shared
    ) {
        self._viewModel = StateObject(
            wrappedValue: FavoritesViewModel(
                volume: volume, networkService: networkService,
                playerService: playerService
            )
        )
    }
    
    var body: some View {
        VStack{
            HStack {
                Text(Resources.Text.favorites.localized(language))
                    .font(.custom(DS.Fonts.sfRegular, size: 30))
                    .foregroundStyle(.white)
                Spacer()
                //deleteRecords()
                //Button("DeleteData"){
                //deleteRecords()
                //}
            }
            .padding(.leading, 60)
            .padding(.top, 100)
            .background(DS.Colors.darkBlue)
            HStack{
                VolumeView(rotation: false, 
                           volume: $viewModel.volume
                )
                    .frame(width: 33 ,height: 250)
                    .padding(.leading, 15)
                VStack {
                    ScrollView(.vertical, showsIndicators: false){
                        LazyVStack {
                            ForEach(viewModel.stations, id: \.stationuuid) {item in
                                FavoritesComponentView(
                                    selectedStationID: $viewModel.selectedStation,
                                    volume: $viewModel.volume, station: item
                                )
                            }
                        }
                    }
                }
                Spacer()
            }
            Spacer()
        }
        .background(DS.Colors.darkBlue)
        .onAppear{
//                if appManager.setStations(stationData: Array(stationData)) {
//                    DispatchQueue.main.asyncAfter(deadline: .now()+1) {
//                        appManager.playFirstStation()
//                    }
//                    print(appManager.stations)
//                }

        }
    }
    
    // delete all records
//    func deleteRecords() {
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "StationData")
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
//        do {
//            try moc.persistentStoreCoordinator?.execute(deleteRequest, with: moc)
//            print("данные удалены")
//        } catch let error as NSError {
//            print("Fetch failed. \(error.localizedDescription)")
//        }
//        try? moc.save()
//        _ = appManager.setStations(stationData: Array(stationData))
//    }
}


// MARK: - Preview
#Preview {
    FavoritesView(volume: 5.0)
}
