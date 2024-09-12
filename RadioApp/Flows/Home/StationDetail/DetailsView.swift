//
//  DetailsView.swift
//  RadioApp
//
//  Created by Evgeniy K on 09.08.2024.
//

import SwiftUI

struct DetailsView: View {
    // MARK: - Drawing Constants
    private struct Drawing {
        static let faviconSize: CGFloat = 40
        static let faviconFrameSize: CGSize = CGSize(width: 60, height: 60)
        static let topPadding: CGFloat = 30
        static let horizontalPadding: CGFloat = 20
        static let equalizerHeight: CGFloat = 350
        static let radioPlayerHeight: CGFloat = 110
        static let volumeSliderHeight: CGFloat = 100
        static let fontSizeLarge: CGFloat = 30
        static let fontSizeSmall: CGFloat = 20
    }
    
    // MARK: - Properties
    @StateObject var viewModel: DetailViewModel
    
    @EnvironmentObject var playerService: PlayerService
    @State private var textOffset: CGFloat = 200
    
    
    // MARK: - Initializer
    init(_
        userId: String,
        station: StationModel,
        userService: UserService = .shared
    ) {
        self._viewModel = StateObject(
            wrappedValue: DetailViewModel(
                userId: userId, 
                station: station,
                userService: userService
            )
        )
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            // MARK: - Header Section
            Spacer()
          
            // MARK: - Favicon
            AsyncImage(url: URL(string: viewModel.station.favicon )) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: Drawing.faviconSize, maxHeight: Drawing.faviconSize)
            } placeholder: {
                Color.pink
            }
            .clipShape(Rectangle())
            .frame(
                maxWidth: Drawing.faviconFrameSize.width,
                maxHeight: Drawing.faviconFrameSize.height
            )
            
            // MARK: - Station Information
            VStack {
                Text(getString(tags: viewModel.station.tags)?.uppercased() ?? viewModel.station.countryCode
                )
                .font(.custom(DS.Fonts.sfBold,
                              size: getString(tags: viewModel.station.tags) != nil
                              ? Drawing.fontSizeSmall
                              : Drawing.fontSizeLarge)
                )
                .foregroundStyle(.white)
                .lineLimit(1)
                .offset(x: textOffset)
                .onAppear {
                    withAnimation(.easeInOut(duration: 8).repeatForever()) {
                        textOffset = -200
                    }
                }
            }
            .frame(width: 900, height: 20)
            .padding(.top, Drawing.topPadding)
            
            
            // MARK: - Equalizer
            EqualizerView(playerService.amplitude)
                .padding(.top, Drawing.topPadding)
                .frame(height: Drawing.equalizerHeight)
            
            // MARK: - Vote
            FavoriteButton(
                isFavorite: viewModel.checkFavorite(),
                action: { viewModel.addUserFavorite()
                }
            )

            // MARK: - Radio Player
            RadioPlayerView(playerService: playerService)
                .environmentObject(playerService)
                .padding(.bottom, Drawing.radioPlayerHeight)
                .frame(height: Drawing.radioPlayerHeight)
            
            // MARK: - Volume Slider
            VolumeSliderView(volume: $playerService.volume, rotation: true)
                .padding(.top, Drawing.topPadding)
                .frame(height: Drawing.volumeSliderHeight)
        }
        
        // MARK: - View Configuration
        .background(DS.Colors.darkBlue)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Resources.Text.playingNow)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackBarButton()
            }
        }
    }
    
    // MARK: - Functions
    func getString(tags: String) -> String? {
        let tagsArr = tags.components(separatedBy: ",")
        return tagsArr.first(where: { !$0.isEmpty })
    }
}

// MARK: - Preview
#Preview {
    DetailsView("", station: StationModel.testStation())
        .environmentObject(PlayerService())
}
