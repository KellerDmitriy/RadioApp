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
        playerService.backTrackAudioStream()
    }
    
    func playButtonTap() {
        if playerService.isPlayMusic {
            playerService.pauseAudioStream()
        } else {
            playerService.playAudio()
        }
    }
    
    func nextButtonTap() {
        playerService.nextStationStream()
    }
    
}

#Preview {
    RadioPlayerView(playerService: PlayerService())
}
