//
//  VolumeView.swift
//  RadioApp
//
//  Created by Dmitriy Eliseev on 28.07.2024.
//

import SwiftUI

// MARK: - View
struct VolumeView: View {
    // MARK: - Properties
    var rotation: Bool
    @Binding var volume: CGFloat
    
    // MARK: - Body
    var body: some View {
        VStack {
            // MARK: - Volume Percentage Text
            Text("\((Int(volume * 100)).formatted())%")
                .font(.system(size: 12))
                .foregroundStyle(.white)
                .rotationEffect(rotation ? -Angle(degrees: (90)) : Angle(degrees: 0))
                .offset(CGSize(width: 0, height: rotation ? -12.0 : 0.0))
            
            GeometryReader { screen in
                // MARK: - Volume Indicator Stack
                ZStack(alignment: .bottom) {
                    // MARK: - Background Rectangles
                    ZStack(alignment: .bottom) {
                        RoundedRectangle(cornerRadius: .infinity)
                            .foregroundStyle(DS.Colors.frame)
                        
                        RoundedRectangle(cornerRadius: .infinity)
                            .foregroundStyle(DS.Colors.blueNeon)
                            .frame(height: (screen.size.height * CGFloat(self.volume)))
                    }
                    .frame(width: 4)
                    
                    // MARK: - Volume Pointer Circle
                    Circle()
                        .foregroundStyle(DS.Colors.blueNeon)
                        .position(CGPoint(x: 5.0, y: screen.size.height - (screen.size.height * CGFloat(self.volume))))
                        .frame(width: 10)
                }
            }
            .frame(width: 10)
        
            // MARK: - Speaker Icon
            Image(systemName: volume == 0 ? "speaker.slash" : "speaker.wave.2")
                .resizable()
                .offset(CGSize(width: rotation ? 0 : 5.0, height: rotation ? 0 : 5.0))
                .frame(width: 18, height: 18)
                .foregroundStyle(DS.Colors.frame)
                .rotationEffect(rotation ? -Angle(degrees: (90)) : Angle(degrees: 0))
        }
        
        // MARK: - Main View Rotation
        .rotationEffect(rotation ? Angle(degrees: (90)) : Angle(degrees: 0))
        .background(DS.Colors.darkBlue)
    }
}

//MARK: - PREVIEW
#Preview {
    VolumeView(rotation: false, volume: .constant(10.0))
}
