//
//  PlayButtonView.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 27.08.2024.
//

import SwiftUI

struct PlayButtonView: View {
    @Binding var isPlay: Bool
    var action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: !isPlay ? "play.fill" : "pause.fill")
                .resizable()
                .foregroundStyle(.white)
                .frame(width: 37, height: 37)
        }
        .frame(width: 70, height: 70)
        .background {
            PlayButtonShape()
                .fill(DS.Colors.pinkNeon)
        }
        .background {
            PlayButtonShape()
                .fill(DS.Colors.darkBlue)
                .frame(width: 75, height: 75)
        }
        .background {
            PlayButtonShape()
                .fill(DS.Colors.blueNeon)
                .frame(width: 83, height: 83)
        }
        .background {
            PlayButtonShape()
                .fill(DS.Colors.darkBlue)
                .frame(width: 90, height: 90)
        }
        .background {
            PlayButtonShape()
                .fill(DS.Colors.pinkNeon)
                .frame(width: 100, height: 100)
        }
        .overlay(PlayButtonAnimation(animation: $isPlay))
    }
}

struct PlayButtonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.36666*width, y: 0.0376*height))
        path.addCurve(to: CGPoint(x: 0.62307*width, y: 0.0376*height), control1: CGPoint(x: 0.44599*width, y: -0.00493*height), control2: CGPoint(x: 0.54374*width, y: -0.00493*height))
        path.addLine(to: CGPoint(x: 0.86074*width, y: 0.16502*height))
        path.addCurve(to: CGPoint(x: 0.98894*width, y: 0.37121*height), control1: CGPoint(x: 0.94007*width, y: 0.20755*height), control2: CGPoint(x: 0.98894*width, y: 0.28615*height))
        path.addLine(to: CGPoint(x: 0.98894*width, y: 0.62605*height))
        path.addCurve(to: CGPoint(x: 0.86074*width, y: 0.83224*height), control1: CGPoint(x: 0.98894*width, y: 0.71111*height), control2: CGPoint(x: 0.94007*width, y: 0.78971*height))
        path.addLine(to: CGPoint(x: 0.62307*width, y: 0.95966*height))
        path.addCurve(to: CGPoint(x: 0.36666*width, y: 0.95966*height), control1: CGPoint(x: 0.54374*width, y: 1.00219*height), control2: CGPoint(x: 0.44599*width, y: 1.00219*height))
        path.addLine(to: CGPoint(x: 0.12899*width, y: 0.83224*height))
        path.addCurve(to: CGPoint(x: 0.00079*width, y: 0.62605*height), control1: CGPoint(x: 0.04966*width, y: 0.78971*height), control2: CGPoint(x: 0.00079*width, y: 0.71111*height))
        path.addLine(to: CGPoint(x: 0.00079*width, y: 0.37121*height))
        path.addCurve(to: CGPoint(x: 0.12899*width, y: 0.16502*height), control1: CGPoint(x: 0.00079*width, y: 0.28615*height), control2: CGPoint(x: 0.04966*width, y: 0.20755*height))
        path.addLine(to: CGPoint(x: 0.36666*width, y: 0.0376*height))
        path.closeSubpath()
        return path
    }
}
