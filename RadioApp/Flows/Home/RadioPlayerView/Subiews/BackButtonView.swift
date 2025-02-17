//
//  BackButtonView.swift
//  RadioApp
//
//  Created by Dmitriy Eliseev on 31.07.2024.
//

import SwiftUI

struct BackButtonView: View {
   
    var action:() -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(.play)
                .resizable()
                .frame(width: 17, height: 17)
                .rotationEffect(Angle(degrees: 180))
        }
        .frame(width: 48, height: 48)
        .background {
            PlayButtonShape()
                .fill(DS.Colors.turquoise)
        }
    }
}

#Preview {
    BackButtonView(action: {})
}
