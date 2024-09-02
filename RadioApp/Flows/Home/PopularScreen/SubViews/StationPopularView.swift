//
//  StationPopularView.swift
//  RadioApp
//
//  Created by Dmitriy Eliseev on 29.07.2024.
//

import SwiftUI

struct StationPopularView: View {
    //MARK: - PROPERTIES
    @EnvironmentObject var playerService: PlayerService
    
    @State var isActive: Bool
    @State var station: StationModel
    
    //MARK: - BODY
    var body: some View {
            ZStack{
                Rectangle()
                    .scaledToFit()
                    .foregroundStyle(isActive ? DS.Colors.pinkNeon : Color.clear)
                    .clipShape(.rect(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                isActive ? DS.Colors.pinkNeon : DS.Colors.frame, lineWidth: 2
                            )
                    )
                VStack{
                    HStack{
                        if isActive {
                            Image(systemName: !playerService.isPlayMusic
                                  ? "play.fill"
                                  : "pause.fill"
                            )
                                .resizable()
                                .foregroundStyle(.white)
                                .frame(width: 25)
                           
                        }
                        Spacer()
                        //отобразить последние 100 голосов
                        Text("votes \(self.station.votes % 1000)")
                            .font(.custom(DS.Fonts.sfRegular, size: 14))
                            .foregroundStyle(isActive ? .white : DS.Colors.frame)
                        
                        VoteView(isShow: isActive ? true : false, idStation: station.stationuuid)
                            .frame(
                                width: 14,
                                height: 14
                            )
                    }
                    
                    .frame(height: 25)
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                    Spacer()
                    Text(self.station.name)
                        .foregroundStyle(isActive ? .white : DS.Colors.frame)
                        .font(.custom(DS.Fonts.sfRegular, size: 15))
                    if isActive {
                        SplineView(isActive: true)
                            .frame(height: 20)
                            .padding(.horizontal)
                    } else {
                        SplineView(isActive: false)
                            .frame(height: 20)
                            .padding(.horizontal)
                    }
                }
                .frame(maxWidth: 139, maxHeight: 139)
                .padding(.bottom, 10)
            }
            
            .overlay {
                Text(getString(tags: self.station.tags)?.uppercased() ?? self.station.countrycode)
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(isActive ? .white : DS.Colors.frame)
                    .font(.custom(DS.Fonts.sfBold, size: getString(tags: self.station.tags) != nil ? 20 : 30))
                    .offset(CGSize(width: 0.0, height: -15.0))
            }
    }
    
    // MARK: - Functions
    func getString(tags: String) -> String? {
        let tagsArr = tags.components(separatedBy: ",")
        return tagsArr.first(where: { !$0.isEmpty })
    }
}


//MARK: - PREVIEW
#Preview {
    StationPopularView(
        isActive: true, station: StationModel.testStation())
        .environmentObject(PlayerService())
}
