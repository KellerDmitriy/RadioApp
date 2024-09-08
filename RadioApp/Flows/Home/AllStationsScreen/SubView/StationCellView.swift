//
//  StationCellView.swift
//  RadioApp
//
//  Created by Evgeniy K on 02.08.2024.
//

import SwiftUI

struct StationCellView: View {
    
    var isActive: Bool
    var isVote: Bool
    var voteAction: () -> Void
    var station: StationModel
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(isActive ? DS.Colors.pinkNeon : .clear)
            HStack{
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Text(getString(tags: 
                             self.station.tags)?.uppercased()
                             ?? self.station.countryCode
                        )
                            .font(
                                .custom(
                                    DS.Fonts.sfBold,
                                    size: getString(tags: self.station.tags)
                                    != nil ? 20 : 30)
                            )
                            .foregroundStyle(isActive ? .white : DS.Colors.frame)
                        
                        Text(station.name)
                            .font(.custom(.sfRegular, size: 15))
                            .foregroundStyle(isActive ? .white : DS.Colors.frame)
                        
                        // now playing
                        if isActive {
                            Text("Playing now")
                                .font((.custom(.sfBold, size: 14)))
                                .foregroundStyle(DS.Colors.pinkPlaying)
                        }
                        Spacer()
                    }
                    .foregroundStyle(isActive ? .white : DS.Colors.grayNotActive)
                    
                    Spacer()
                    HStack {
                        VStack(alignment: .trailing) {
                            HStack {
                                Text("votes \(self.station.votes % 1000)")
                                    .font(.custom(DS.Fonts.sfRegular, size: 14))
                                    .foregroundStyle(isActive ? .white : DS.Colors.frame)
                                
                                FavoriteButton(
                                    isFavorite: isVote,
                                    action: voteAction
                                )
                                   
                            }
                            Spacer(minLength: 20)
                            if isActive {
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
                }
            }
            .padding()
        }
        .frame(width: 293, height: 120)
        
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(isActive ? DS.Colors.pinkNeon : DS.Colors.frame, lineWidth: 2)
        }
        .padding(.trailing, 20)
        .padding(.vertical, 5)
    }
    
    // MARK: - Functions
    func getString(tags: String) -> String? {
        let tagsArr = tags.components(separatedBy: ",")
        return tagsArr.first(where: { !$0.isEmpty })
    }
}

//MARK: - PREVIEW
#Preview {
    StationCellView(isActive: true, isVote: true, voteAction: {}, station: StationModel.testStation())
}

