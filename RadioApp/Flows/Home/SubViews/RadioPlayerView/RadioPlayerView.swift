//
//  PlayButtonView.swift
//  RadioApp
//
//  Created by Dmitriy Eliseev on 31.07.2024.
//

import SwiftUI

struct RadioPlayerView: View {
    @ObservedObject var playerService: PlayerService
    
    var body: some View {
        ZStack {
            DS.Colors.darkBlue
                .ignoresSafeArea()
            HStack {
                Spacer()
                BackButtonView(action: backButtonTap)
                Spacer()
                PlayButtonView(isPlay: $playerService.isPlayMusic, action: playButtonTap)
                 
                Spacer()
                NextButtonView(action: nextButtonTap)
                Spacer()
            }
            
        }
    }
    
    
    func backButtonTap() {
//        playerService.backTrackAudioStream(isPlay: isPlay)
    }
    
    func playButtonTap() {
        if playerService.isPlayMusic {
            playerService.pauseAudioStream()
        } else {
            playerService.playAudioStream()
        }
    }
    
    func nextButtonTap() {
//        playerService.nextTrackAudioStream(isPlay: isPlay)
    }
    
}

#Preview {
    RadioPlayerView(playerService: PlayerService())
        .environmentObject(PlayerService())
}
