//
//  ProfileHeaderView.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 02.08.2024.
//

import SwiftUI

struct ProfileHeaderView: View {
    // MARK: - Properties
    @Binding var userName: String
    @Binding var userEmail: String
    @Binding var profileImageURL: URL?
    
    @Binding var showChangedPhotoView: Bool
    
    // MARK: - Drawing Constants
    private struct Drawing {
        static let avatarSize: CGFloat = 100
        static let editIconSize: CGFloat = 32
        static let spacing: CGFloat = 16
        static let topPadding: CGFloat = 50
        static let fieldTopPadding: CGFloat = 40
        static let iconOffset: CGFloat = 35
        static let textFontSize: CGFloat = 14
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            // MARK: - Avatar Section
            Button {
                showChangedPhotoView.toggle()
            } label: {
                ZStack {
                    AsyncImage(url: profileImageURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(
                                width: Drawing.avatarSize,
                                height: Drawing.avatarSize
                            )
                    } placeholder: {
                        Image(systemName: Resources.Image.photoIcon)
                            .frame(
                                width: Drawing.avatarSize,
                                height: Drawing.avatarSize
                            )
                    }
                    Image(Resources.Image.editProfileAvatar)
                        .offset(x: Drawing.iconOffset, y: Drawing.iconOffset)
                        .frame(width: Drawing.editIconSize, height: Drawing.editIconSize)
                }
            }
            
            // MARK: - User Info Section
            Text(userName)
                .foregroundStyle(.white)
                .font(.custom(.sfSemibold, size: Drawing.textFontSize))
            
            Text(verbatim: userEmail)
                .foregroundStyle(.gray)
                .font(.custom(.sfSemibold, size: Drawing.textFontSize))
                .padding(.top, -8)
        }
        .padding()
    }
}

// MARK: - Preview
struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView(
            userName: .constant("Stephen"),
            userEmail: .constant("stephen@ds"),
            profileImageURL: .constant(URL(string: "")),
            showChangedPhotoView: .constant(false)
        )
    }
}
