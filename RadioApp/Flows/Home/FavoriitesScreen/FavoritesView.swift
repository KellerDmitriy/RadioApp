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
    @EnvironmentObject var playerService: PlayerService
    
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    
    init(
        networkService: NetworkService = .shared
    ) {
        self._viewModel = StateObject(
            wrappedValue: FavoritesViewModel(
                networkService: networkService
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
            }
            .padding(.leading)
            .padding(.top, 100)
            .background(DS.Colors.darkBlue)
            
            VStack {
                ScrollView(.vertical, showsIndicators: false){
                    LazyVStack {
                        ForEach(viewModel.stations, id: \.stationuuid) {item in
                            FavoritesComponentView(
                                selectedStationID: $viewModel.selectedStation,
                                station: item
                            )
                        }
                    }
                }
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
    FavoritesView()
}
