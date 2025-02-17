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
        ZStack{
            Rectangle()
                .scaledToFit()
                .foregroundStyle(isSelect ? DS.Colors.pinkNeon : Color.clear)
                .clipShape(.rect(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            isSelect ? DS.Colors.pinkNeon : DS.Colors.frame, lineWidth: 2
                        )
                )
            VStack{
                HStack{
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
                    Text("votes \(self.station.votes % 1000)")
                        .font(.custom(DS.Fonts.sfRegular, size: 14))
                        .foregroundStyle(isSelect ? .white : DS.Colors.frame)
                    
                    FavoriteButton(
                        isFavorite: isFavorite,
                        action: { favoriteAction() }
                    )
                    .offset(x: 16)
                }
                .frame(height: 25)
                .padding(.horizontal, 10)
                .padding(.top, 10)
                Spacer()
                Text(self.station.name)
                    .foregroundStyle(isSelect ? .white : DS.Colors.frame)
                    .font(.custom(DS.Fonts.sfRegular, size: 15))
                if isSelect {
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
        .animation(.easeInOut, value: isSelect)
        .overlay {
            Text(getString(tags: self.station.tags)?.uppercased() ?? self.station.countryCode)
                .lineLimit(2)
                .truncationMode(.tail)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .foregroundStyle(isSelect ? .white : DS.Colors.frame)
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
    PopularCellView(
        isSelect: true,
        isFavorite: true,
        isPlayMusic: true,
        station: StationModel.testStation(),
        favoriteAction: {}
    )
}
