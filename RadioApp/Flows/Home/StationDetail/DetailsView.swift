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
        static let faviconSize: CGFloat = 60
        static let faviconFrameSize: CGSize = CGSize(width: 60, height: 60)
        static let bottomPadding: CGFloat = 30
        static let horizontalPadding: CGFloat = 20
        static let equalizerHeight: CGFloat = 350
        static let radioPlayerHeight: CGFloat = 110
        static let volumeSliderWidth: CGFloat = 300
        static let volumeSliderHeight: CGFloat = 33
        static let volumeSliderHorizontalOffset: CGFloat = 120
        static let volumeSliderVerticalOffset: CGFloat = -70
        
        static let textOffsetInitial: CGFloat = -50
        static let textOffsetFinal: CGFloat = 50
        static let textFrameWidth: CGFloat = 200
        static let textFrameHeight: CGFloat = 20
        static let animationDuration: Double = 8
        
        static let cornerRadius: CGFloat = 8.0
        
        static let fontSizeLarge: CGFloat = 30
        static let fontSizeSmall: CGFloat = 20
    }
    
    // MARK: - Properties
    @StateObject var viewModel: DetailViewModel
    
    @EnvironmentObject var playerService: PlayerService
    @State private var textOffset: CGFloat = Drawing.textOffsetInitial
    
    // MARK: - Initializer
    init(_ userId: String, station: StationModel) {
        self._viewModel = StateObject(
            wrappedValue: DetailViewModel(
                userId: userId,
                station: station
            )
        )
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            // MARK: - Header Section
            Spacer()
            
            // MARK: - Favicon
            AsyncImageView(playerService.currentStation?.favicon,
                           configureImage: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Rectangle())
            })
            .cornerRadius(Drawing.cornerRadius)
            .frame(
                width: Drawing.faviconFrameSize.width,
                height: Drawing.faviconFrameSize.height
            )
            
            // MARK: - Station Information
            VStack {
                Text(getString(tags: playerService.currentStation?.tags ?? "")?.uppercased() ?? viewModel.station.countryCode
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
                    withAnimation(.easeInOut(duration: Drawing.animationDuration)
                        .repeatForever()) {
                            textOffset = Drawing.textOffsetFinal
                        }
                }
            }
            .frame(width: Drawing.textFrameWidth, height: Drawing.textFrameHeight)
            .padding(.top, Drawing.bottomPadding)
            
            // MARK: - Equalizer
            EqualizerView(playerService.amplitude)
                .padding(.top, Drawing.bottomPadding)
                .frame(height: Drawing.equalizerHeight)
            
            // MARK: - Vote and Radio Player
            VStack {
                ZStack {
                    FavoriteButton(
                        isFavorite: viewModel.isFavorite,
                        action: { viewModel.checkFavorite() }
                    )
                    .offset(x: Drawing.volumeSliderHorizontalOffset, y: Drawing.volumeSliderVerticalOffset)
                    
                    // MARK: - Radio Player
                    RadioPlayerView(playerService: playerService)
                        .environmentObject(playerService)
                        .frame(height: Drawing.radioPlayerHeight)
                }
                
                // MARK: - Volume Slider
                VolumeSliderView(
                    volume: $playerService.volume,
                    horizontal: true
                )
                .environmentObject(playerService)
                .frame(width: Drawing.volumeSliderWidth, height: Drawing.volumeSliderHeight)
            }
            .padding(.bottom, Drawing.bottomPadding)
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
        .environmentObject(PlayerService.shared)
}
