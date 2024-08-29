//
//  StationView.swift
//  RadioApp
//
//  Created by Evgeniy K on 02.08.2024.
//

import SwiftUI

struct StationView: View {

    @State private var isActive = false
    var station: StationModel
    @Binding var selectedStationID: String
    @Binding var volume: CGFloat

    
    var body: some View {

        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(selectedStationID == station.stationuuid ? DS.Colors.pinkNeon : .clear)
//            Button {
//                // on tap
//                selectedStationID = station.stationuuid
//                appManager.playAudio(url: station.url)
//            } label: {
                // code, name, playing now
                HStack{
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            
                            Text(getString(tags: self.station.tags)?.uppercased() ?? self.station.countrycode)
                                .font(.custom(DS.Fonts.sfBold, size: getString(tags: self.station.tags) != nil ? 20 : 30))
                                .foregroundStyle(selectedStationID == station.stationuuid ? .white : DS.Colors.frame)
                            
                            Text(station.name)
                                .font(.custom(.sfRegular, size: 15))
                                .foregroundStyle(selectedStationID == station.stationuuid ? .white : DS.Colors.frame)
                            
                            // now playing
                            if selectedStationID == station.stationuuid {
                                Text("Playing now")
                                    .font((.custom(.sfBold, size: 14)))
                                    .foregroundStyle(DS.Colors.pinkPlaying)
                            }
                            
                            Spacer()
                        }
                        .foregroundStyle(selectedStationID == station.stationuuid ? .white : DS.Colors.grayNotActive)
                        
                        Spacer()
                        HStack {
                            VStack(alignment: .trailing) {
                                HStack {
                                    Text("votes \(self.station.votes % 1000)")
                                        .font(.custom(DS.Fonts.sfRegular, size: 14))
                                        .foregroundStyle(selectedStationID == station.stationuuid ? .white : DS.Colors.frame)
                                    
                                    VoteView(isShow: selectedStationID == station.stationuuid ? true : false, idStation: station.stationuuid)
                                        .frame(width: 14, height: 14)
                                }
                                Spacer(minLength: 20)
                                if selectedStationID == station.stationuuid {
                                    SplineView(isActive: true)
                                        .frame(height: 20)
                                        .padding(.horizontal)
                                } else {
                                    SplineView(isActive: false)
                                        .frame(height: 20)
                                        .padding(.horizontal)
                                }
                                Spacer()
                            }
                        }
                        //.frame(width: 120,height: 120)
                    }
                }
                .padding()
                
          //  }

        }
        .frame(width: 293, height: 120)
        .background(NavigationLink(
            destination: StationDetailsView(
                station: station,
                volume: $volume
            ),
                        isActive: $isActive) {
                        EmptyView()
                    })
//        .onTapGesture {
//            selectedStationID = station.stationuuid
//            appManager.playAudio(url: station.url)
//        }
//        .onLongPressGesture() {
//            if selectedStationID == station.stationuuid {
//                print("long tap")
//                isActive.toggle()
//                appManager.isActiveDetailView = true
//            }
//        }
//        .clipShape(.rect(cornerRadius: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(selectedStationID == station.stationuuid ? DS.Colors.pinkNeon : DS.Colors.frame, lineWidth: 2)
        }
        .padding(.trailing, 20)
        .padding(.vertical, 5)
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

//MARK: - PREVIEW
#Preview {
    StationView(station: StationModel.testStation(), selectedStationID: .constant(""), volume: .constant(5.0))
}

