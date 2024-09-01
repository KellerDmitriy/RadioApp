//
//  EqualizerView.swift
//  RadioApp
//
//  Created by Evgeniy K on 08.08.2024.
//

import SwiftUI

struct EqualizerView: View {
    
    // MARK: - Drawing Constants
    private struct Drawing {
        static let minAmplitudeModifier: CGFloat = 0.25
        static let maxCircleCount: Int = 40
        static let columnSpacing: CGFloat = 10
        static let maxEqualizerWidth: CGFloat = 300
        static let equalizerHeightRatio: CGFloat = 1/8
        static let minYOffsetMultiplier: CGFloat = 0.5
        static let maxYOffsetMultiplier: CGFloat = 1.5
        static let phaseShiftStep: Double = 0.02
        static let animationDuration: Double = 0.5
        static let finalAnimationProgress: Double = 1.0
    }
    
    // MARK: - Properties
    let amplitude: CGFloat
    
    @State private var phaseShift = 0.0
    @State private var animationProgress = 0.0
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: Drawing.columnSpacing) {
                ForEach(1 ..< 33, id: \.self) { column in
                    let randomFactor = CGFloat.random(in: Drawing.minYOffsetMultiplier...Drawing.maxYOffsetMultiplier)
                    let amplitudeModifier = amplitude * randomFactor * CGFloat(column) * 0.5
                    let circleCount = max(1, min(40, Int(amplitudeModifier)))
                    
                    let xPosition = Double(column) / 6.0
                    let yOffset = sin(xPosition + phaseShift + amplitudeModifier / 5) * geometry.size.height * Drawing.equalizerHeightRatio
                    
                    VStack {
                        ForEach(0 ..< circleCount, id: \.self) { _ in
                            Circle()
                                .foregroundStyle(DS.Colors.pinkNeon)
                                .frame(width: 4, height: 4)
                                .animation(.easeInOut(duration: Drawing.animationDuration), value: animationProgress)
                        }
                    }
                    .offset(y: yOffset)
                }
            }
            .frame(maxWidth: Drawing.maxEqualizerWidth, maxHeight: Drawing.maxEqualizerWidth)
            .onAppear {
                withAnimation(.easeInOut(duration: Drawing.animationDuration)) {
                    animationProgress = Drawing.finalAnimationProgress
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    func updatePhase() {
        withAnimation(.easeInOut(duration: Drawing.animationDuration)) {
            phaseShift += Drawing.phaseShiftStep
            animationProgress = fmod(phaseShift, 2.0)
        }
    }
    
    // MARK: - Initializer
    init(_ amplitude: CGFloat) {
        self.amplitude = amplitude
    }
}

// MARK: - Preview
#Preview {
    EqualizerView(0.3)
}
