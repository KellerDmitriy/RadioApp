//
//  FavoriteButton.swift
//  RadioApp
//
//  Created by Dmitriy Eliseev on 29.07.2024.
//

import SwiftUI

struct FavoriteButton: View {
    //MARK: - PROPERTIES
    var isFavorite: Bool
    var action: () -> Void
    
    //MARK: - BODY
    var body: some View {
        
        Button(action: action) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundStyle(.white)
        }
    }
}

//MARK: - PREVIEW
#Preview {
    FavoriteButton(isFavorite: true, action: {})
}

