//
//  StationDetailsView.swift
//  RadioApp
//
//  Created by Evgeniy K on 09.08.2024.
//

import SwiftUI

struct StationDetailsView: View {
    @EnvironmentObject var playerService: PlayerService
    
    var station: StationModel
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VoteView(isShow: true, idStation: station.stationuuid)
                    .frame(width: 14, height: 14)
                    .padding(.top, 30)
            }
            .padding(.horizontal, 30)
            VStack {
                AsyncImage(url: URL(string: station.favicon)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 40, maxHeight: 40)
                    
                } placeholder: {
                    Color.gray
                }
                .clipShape(Rectangle())
                .frame(maxWidth: 60, maxHeight: 60)
                
                Text(getString(tags: self.station.tags)?.uppercased() ?? self.station.countrycode)
                    .font(.custom(DS.Fonts.sfBold, size: getString(tags: self.station.tags) != nil ? 20 : 30))
                    .foregroundStyle(.white)
                
            
                EqualizerView(playerService.amplitude)
                    .padding(.top, 20)
                    .frame(height: 350)
              
                Spacer()
                RadioPlayerView(playerService: playerService)
                    .environmentObject(playerService)
                    .frame(height: 110)
          
                VolumeSliderView(volume: $playerService.volume, rotation: true)
                    .padding(.top, 20)
                    .frame(height: 300)

            }
        }
        
        .background(DS.Colors.darkBlue)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Playing now")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackBarButton()
            }
        }
    }
    
    //get Tag in String with ","
    func getString(tags: String) -> String? {
        let tagsArr = tags.components(separatedBy: ",")
        if tagsArr.count > 0 {
            if tagsArr[0] == "" {
                return nil
            } else {
                return tagsArr[0]
            }
        } else {
            return nil
        }
    }
}

#Preview {
    StationDetailsView(station: StationModel.testStation())
        .environmentObject(PlayerService())
}
