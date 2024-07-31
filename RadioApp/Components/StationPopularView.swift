//
//  StationPopularView.swift
//  RadioApp
//
//  Created by Dmitriy Eliseev on 29.07.2024.
//

import SwiftUI

struct StationPopularView: View {
    //@Binding var voteCount: Int?
    @Binding var isShow: Bool
    @EnvironmentObject var appManager: ViewModel
    var station: Station
    var body: some View {
        Button{
            isShow.toggle()
        } label: {
            ZStack{
                Rectangle()
                    .scaledToFit()
                    .foregroundStyle(isShow ? DS.Colors.pinkNeon : Color.clear)
                
                    .clipShape(.rect(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                isShow ? DS.Colors.pinkNeon : DS.Colors.frame, lineWidth: 2
                            )
                    )
                VStack{
                    HStack{
                        if isShow {
                            Image(.play)
                                .resizable()
                                .frame(
                                    width: 25,
                                    height: 25
                                )
                        }
                        Spacer()
                        //отобразить последние 100 голосов
                        Text("votes \(self.station.votes/1000)")
                            .font(.custom(DS.Fonts.sfRegular, size: 15))
                            .foregroundStyle(isShow ? .white : DS.Colors.frame)
                        VoteView(model: appManager, isShow: $isShow)
                            .frame(
                                width: 14,
                                height: 14
                            )
                    }
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                    Spacer()
                    Text(self.station.name)
                        .foregroundStyle(isShow ? .white : DS.Colors.frame)
                        .font(.custom(DS.Fonts.sfRegular, size: 15))
                    SplineView(active: $isShow)
                        .frame(height: 20)
                        .padding(.horizontal)
                }
                .frame(maxWidth: 139, maxHeight: 139)
                .padding(.bottom, 10)
            }
            .frame(maxWidth: 139, maxHeight: 139)
            .overlay {
                Text(self.station.countrycode)
                    .foregroundStyle(isShow ? .white : DS.Colors.frame)
                    .font(.custom(DS.Fonts.sfBold, size: 40))
                    .offset(CGSize(width: 0.0, height: -15.0))
            }
            
        }
            
    }
}



struct StationPopularView_Previews: PreviewProvider {
    static let previewAppManager = ViewModel()

    static var previews: some View {
        StationPopularView(isShow: .constant(false), station: Station.testStation())
            .environmentObject(previewAppManager)
    }
}
