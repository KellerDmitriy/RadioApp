//
//  PopularCellView.swift
//  RadioApp
//
//  Created by Dmitriy Eliseev on 29.07.2024.
//

import SwiftUI

struct PopularCellView: View {
    //MARK: - PROPERTIES
    let isSelect: Bool
    let isFavorite: Bool
    let isPlayMusic: Bool
    let station: StationModel
    let favoriteAction: () -> Void
    
    //MARK: - BODY
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill (
                    isSelect
                    ? DS.Colors.pinkNeon
                    : DS.Colors.frame
                )
                
            VStack {
                HStack {
                    Spacer()
                    if isSelect {
                        Image(systemName: !isPlayMusic
                              ? "play.fill"
                              : "pause.fill"
                        )
                        .resizable()
                        .foregroundStyle(.white)
                        .frame(width: 25)
                        
                    }
                    Spacer()
                    Text("votes: \(self.station.votes % 1000)")
                        .font(.custom(DS.Fonts.sfRegular, size: 10))
                        .foregroundStyle(isSelect ? .white : DS.Colors.frame)
                    Spacer()
                    FavoriteButton(
                        isFavorite: isFavorite,
                        action: { favoriteAction() }
                    )
                    Spacer()
                }
                .frame(height: 25)
                .padding(.top, 10)
               
                
                Text(getString(tags: self.station.tags)?.uppercased() ?? self.station.countryCode)
                    .foregroundStyle(isSelect 
                                     ? .white
                                     : DS.Colors.frame
                    )
                    .font(
                        .custom(DS.Fonts.sfBold,
                                  size: getString(tags: self.station.tags) != nil 
                                ? 20
                                : 30)
                    )
                
                Text(self.station.name)
                    .foregroundStyle(isSelect ? .white : DS.Colors.frame)
                    .font(.custom(DS.Fonts.sfRegular, size: 15))
                
                SplineView(isActive: isSelect)
                    .frame(height: 20)
                    .padding(.horizontal)
            }
            .padding(.bottom, 10)
        }
        .animation(.easeInOut, value: isSelect)
        
    }
    
    // MARK: - Functions
    func getString(tags: String) -> String? {
        let tagsArr = tags.components(separatedBy: ",")
        return tagsArr.first(where: { !$0.isEmpty })
    }
}


//MARK: - PREVIEW
#Preview {
    PopularCellView(
        isSelect: true,
        isFavorite: true,
        isPlayMusic: true,
        station: StationModel.testStation(),
        favoriteAction: {}
    )
}
