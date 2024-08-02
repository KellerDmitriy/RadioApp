//
//  VolumeView.swift
//  RadioApp
//
//  Created by Dmitriy Eliseev on 28.07.2024.
//

import SwiftUI
import AVFAudio


struct VolumeView: View {
    @EnvironmentObject var appManager: ViewModel
    @Binding var voulmeValue: CGFloat
    var body: some View {
        VStack{
            Text("\((Int(voulmeValue*100)).formatted())%")
                .font(.system(size: 12))
                .foregroundStyle(.white)
            GeometryReader { screen in
                ZStack{
                    ZStack(alignment: .bottom){
                        RoundedRectangle(cornerRadius: .infinity)
                            .foregroundStyle(DS.Colors.frame)
                        RoundedRectangle(cornerRadius: .infinity)
                            .foregroundStyle(DS.Colors.blueNeon)
                            .frame(height: (screen.size.height * CGFloat(self.voulmeValue)))
                    }
                    .frame(width: 4)
                    Circle()
                        .foregroundStyle(DS.Colors.blueNeon)
                        .position(CGPoint(x: 5.0, y: screen.size.height - (screen.size.height * CGFloat(self.voulmeValue)) ))
                        .frame(width: 10)
                        .gesture(
                            DragGesture()
                                .onChanged({ value in
                                    withAnimation(.linear(duration: 2)){
                                        if voulmeValue >= 0 && voulmeValue <= 1 {
                                            voulmeValue -= (value.translation.height/screen.size.height/80)
                                           
                                        }
                                    }
                                })
                                .onEnded({ _ in
                                    if voulmeValue >= 1 {
                                        voulmeValue = 1
                                    } else if voulmeValue <= 0 {
                                        voulmeValue = 0
                                    }
                               
                                })
                                
                                
                        )
                        .onReceive(AVAudioSession.sharedInstance().publisher(for: \.outputVolume), perform: { value in
                            appManager.volume = Double(value)
                               })
                }
            }
            .frame(width: 10)
            Image(systemName: voulmeValue == 0 ? "speaker.slash" : "speaker.wave.2")
                .resizable()
                .offset(CGSize(width: 5.0, height: 5.0))
                .frame(width: 18, height: 18)
                .foregroundStyle(DS.Colors.frame)
        }
    }
}

//MARK: - PREVIEW
struct VolumeView_Previews: PreviewProvider {
    static let previewAppManager = ViewModel()
    static var previews: some View {
        VolumeView(voulmeValue: .constant(0.5))
            .environmentObject(previewAppManager)
    }
}
