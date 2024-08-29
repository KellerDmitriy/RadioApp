//
//  PlayButtonAnimation.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 29.08.2024.
//

import SwiftUI

struct PlayButtonAnimation: View {
    @Binding var animation: Bool

    var body: some View {
        ZStack {
            PlayButtonShape()
                .stroke(lineWidth: animation ? 0 : 4)
                .foregroundStyle(DS.Colors.pinkNeon)
                .offset(x: 0.6, y: -2.2)
                .scaleEffect(animation ? 2 : 0.9)
                .opacity(animation ? 0 : 0.8)
            PlayButtonShape()
                .stroke(lineWidth: animation ? 0 : 4)
                .foregroundStyle(DS.Colors.blueNeon)
                .offset(x: 0.6, y: -2.2)
                .scaleEffect(animation ? 2 : 0.9)
                .opacity(animation ? 0 : 0.8)
        }
        .frame(width: 115, height: 115)
        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: false), value: animation)
    }
}

#Preview {
    PlayButtonAnimation(animation: .constant(true))
}

