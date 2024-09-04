//
//  FaviritesComponentView.swift
//  RadioApp
//
//  Created by Dmitriy Eliseev on 08.08.2024.
//

import SwiftUI

struct FavoritesComponentView: View {
    //MARK: - PROPERTIES
    @EnvironmentObject var playerService: PlayerService
    
    @State var isActive: Bool
    
    var station: StationModel
    
    //MARK: - BODY
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(isActive ? DS.Colors.pinkNeon : .clear)
            HStack{
                VStack(alignment: .leading, spacing: 10) {
                    Text(getString(tags: self.station.tags)?.uppercased() ?? self.station.countryCode)
                        .font(.custom(DS.Fonts.sfBold, size: getString(tags: self.station.tags) != nil ? 20 : 30))
                        .foregroundStyle(isActive ? .blue : DS.Colors.frame)
                    HStack() {
                        Spacer()
                        Text(station.name)
                            .lineLimit(2)
                            .truncationMode(.tail)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.center)
                            .font(.custom(.sfRegular, size: 10))
                            .foregroundStyle(isActive ? .white : DS.Colors.frame)
                        Spacer()
                    }
                    if isActive {
                        SplineView(isActive: true)
                            .frame(height: 20)
                    } else {
                        SplineView(isActive: false)
                            .frame(height: 20)
                    }
                }
                .frame(width: 120, height: 120)
                .foregroundStyle(isActive ? .white : DS.Colors.grayNotActive)
                Spacer(minLength: 80)
                Button {
//                    deleteItem()
                } label: {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .frame(width: 62, height: 54)
                        .foregroundStyle(DS.Colors.blueNeon)
                }
            }
            .padding()
            
        }
    
        .frame(width: 293, height: 120)
        
        .clipShape(.rect(cornerRadius: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(isActive ? DS.Colors.pinkNeon : DS.Colors.frame, lineWidth: 2)
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
    FavoritesComponentView(isActive: true, station: StationModel.testStation())
}


