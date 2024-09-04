//
//  VoteView.swift
//  RadioApp
//
//  Created by Dmitriy Eliseev on 29.07.2024.
//

import SwiftUI

struct VoteView: View {
    //MARK: - PROPERTIES
    
    @State var isVote: Bool
    
    //MARK: - BODY
    var body: some View {
        Image(systemName: isVote ? "heart.fill" : "heart")
            .resizable()
            .scaledToFit()
            .foregroundStyle(.white)
    }
    init(_ isVote: Bool) {
        self.isVote = isVote
    }
}

//MARK: - PREVIEW
#Preview {
    VoteView(true)
}

