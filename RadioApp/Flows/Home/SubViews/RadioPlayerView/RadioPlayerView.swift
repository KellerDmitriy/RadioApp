//
//  PlayButtonView.swift
//  RadioApp
//
//  Created by Dmitriy Eliseev on 31.07.2024.
//

import SwiftUI

struct RadioPlayerView: View {
    @Binding var isPlay: Bool
    
    var body: some View {
        ZStack {
           DS.Colors.darkBlue
                .ignoresSafeArea()
            HStack {
                Spacer()
                BackButtonView(action: backButtonTap)
                Spacer()
                PlayButtonView(isPlay: $isPlay, action: playButtonTap)
                Spacer()
                ForwardButtonView(action: forwardButtonTap)
                Spacer()
            }
          
        }
    }
    

    func backButtonTap() {
        
    }
    
    func playButtonTap() {
        
    }
    
    func forwardButtonTap() {
        
    }
    
}

#Preview {
    RadioPlayerView(isPlay: .constant(true))
}
