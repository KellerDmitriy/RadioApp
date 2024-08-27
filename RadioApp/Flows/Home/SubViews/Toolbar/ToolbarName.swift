//
//  ToolbarView.swift
//  RadioApp
//
//  Created by Evgeniy K on 07.08.2024.
//

import SwiftUI

struct ToolbarName: View {
    @State var userName: String
    
    var body: some View {
        
        HStack {
            Image(.toolbarplay)
            Text("Hello")
                .foregroundStyle(.white)
                .font(.custom(DS.Fonts.sfMedium, size: 25))
            
            Text("\(userName)")
                .foregroundStyle(DS.Colors.pinkNeon)
                .font(.custom(DS.Fonts.sfMedium, size: 25))
            
            Spacer()
        }
        .padding(.leading, 10)
        .padding(.vertical, 20)
        
    }
}

