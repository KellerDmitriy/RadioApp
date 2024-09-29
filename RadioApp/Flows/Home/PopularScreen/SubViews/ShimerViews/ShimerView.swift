//
//  ShimerView.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 24.09.2024.
//

import SwiftUI

struct ShimmerView: View {
    @State private var moveToRight = false
    
    var body: some View {
        ZStack {
            DS.Colors.pinkNeon.opacity(0.2)
            
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.white.opacity(0.3), Color.white.opacity(0.7), Color.white.opacity(0.3)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .rotationEffect(Angle(degrees: 30))
                .offset(x: moveToRight ? 300 : -300)
                .onAppear {
                    withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                        moveToRight.toggle()
                    }
                }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

extension View {
    func shimmer() -> some View {
        self.overlay(
            ShimmerView()
                .mask(self)
        )
    }
}

#Preview {
    ShimmerView()
}
