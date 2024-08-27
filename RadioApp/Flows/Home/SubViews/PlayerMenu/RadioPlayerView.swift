//
//  PlayButtonView.swift
//  RadioApp
//
//  Created by Dmitriy Eliseev on 31.07.2024.
//

import SwiftUI

struct RadioPlayerView: View {
    @EnvironmentObject var appManager: HomeViewModel
    @State var isPlay = false
    
    var body: some View {
        HStack {
            BackButtonView(action: backButtonTap)
            PlayButtonView(isPlay: isPlay, action: playButtonTap)
            ForwardButtonView(action: forwardButtonTap)
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
    RadioPlayerView()
}
