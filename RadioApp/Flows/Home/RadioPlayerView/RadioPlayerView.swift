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
            LinearGradient(
                  gradient: Gradient(colors: [DS.Colors.darkBlue, Color.black.opacity(0)]),
                  startPoint: .bottom,
                  endPoint: .top
              )
             
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
