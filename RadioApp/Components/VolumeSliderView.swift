//
//  VolumeSliderView.swift
//  RadioApp
//
//  Created by Dmitriy Eliseev on 28.07.2024.
//

import SwiftUI

// MARK: - View
struct VolumeSliderView: View {
    // MARK: - Properties
    @Binding var volume: CGFloat
    
    @State var rotation = false
    
    // MARK: - Body
    var body: some View {
        VStack {
            // MARK: - Volume Percentage Text
            Text("\((Int(volume * 100)).formatted())%")
                .font(.system(size: 12))
                .foregroundStyle(.white)
                .rotationEffect(
                    rotation == true
                    ? -Angle(degrees: (90))
                    : Angle(degrees: 0)
                )
                .offset(CGSize(width: 0, height: rotation == true ? -12.0 : 0.0))
            
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
            Image(systemName: 
                    volume == 0
                  ? "speaker.slash"
                  : "speaker.wave.2"
            )
                .resizable()
                .offset(CGSize(
                    width: rotation == true ? 0 : 5.0,
                    height: rotation == true ? 0 : 5.0)
                )
                .frame(width: 18, height: 18)
                .foregroundStyle(DS.Colors.frame)
                .rotationEffect(rotation == true ? -Angle(degrees: (90)) : Angle(degrees: 0))
        }
        
        // MARK: - Main View Rotation
        .rotationEffect(rotation == true ? Angle(degrees: (90)) : Angle(degrees: 0))
    }
    
}


//MARK: - PREVIEW
#Preview {
    VolumeSliderView(volume: .constant(5.0))
      
}
