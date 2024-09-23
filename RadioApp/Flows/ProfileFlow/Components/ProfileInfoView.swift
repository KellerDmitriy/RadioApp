//
//  ProfileInfoView.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 30.07.2024.
//

import SwiftUI

// MARK: - ProfileInfoView
struct ProfileInfoView: View {
    // MARK: - Properties
    var userName: String
    var userEmail: String
    var profileImageURL: URL?
    
    // MARK: - Drawing Constants
    private struct Drawing {
        static let avatarSize: CGFloat = 54
        static let textSpacing: CGFloat = 8
        static let textLeadingPadding: CGFloat = 8
        static let cornerRadius: CGFloat = 16
        static let strokeWidth: CGFloat = 1.0
        static let strokeOpacity: CGFloat = 0.2
        static let padding: CGFloat = 16
    }
    
    // MARK: - Body
    var body: some View {
        HStack {
            AsyncImageView(profileImageURL?.absoluteString) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                 
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    .shadow(radius: 5)
            }
            .clipShape(Circle())
            .frame(
                width: Drawing.avatarSize,
                height: Drawing.avatarSize
            )
            VStack(
                alignment: .leading,
                spacing: Drawing.textSpacing
            ) {
                Text(userName)
                    .font(Font.custom(.sfMedium, size: 16))
                    .foregroundColor(.white)
                
                Text(userEmail)
                    .font(Font.custom(.sfMedium, size: 14))
                    .foregroundColor(Color.gray)
            }
            
            .padding(.leading, Drawing.textLeadingPadding)
            
            Spacer()
            
            NavigationLink(destination: ProfileEditView()
            )
               {
                    Image(Resources.Image.edit)
                        .foregroundColor(DS.Colors.blueNeon)
                        .padding(.trailing, Drawing.padding)
                }
        }
        
        .padding()
        .background(.clear)
        .cornerRadius(Drawing.cornerRadius)
        .overlay {
            RoundedRectangle(cornerRadius: Drawing.cornerRadius)
                .stroke(
                    Color.gray,
                    lineWidth: Drawing.strokeWidth
                )
                .opacity(Drawing.strokeOpacity)
        }
    }
}

// MARK: - Preview
#Preview {
    ProfileInfoView(
        userName: "Stephen",
        userEmail: "stephen@ds",
        profileImageURL: URL(string: "")
    )
}
