//
//  ToolbarView.swift
//  RadioApp
//
//  Created by Evgeniy K on 07.08.2024.
//

import SwiftUI

struct ToolbarName: View {
    let userName: String
    
    var body: some View {
        
        HStack {
            Image(.toolbarplay)
            
            Text("Hello")
                .foregroundStyle(.white)
            Text(" \(userName)")
                .foregroundStyle(DS.Colors.pinkNeon)
            Spacer()
        }
        .font(.custom(DS.Fonts.sfMedium, size: 25))
        .padding(.leading, 10)
        .padding(.vertical, 20)
        
    }
}

