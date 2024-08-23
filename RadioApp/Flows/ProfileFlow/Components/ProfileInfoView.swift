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
    private struct DrawingConstants {
        static let avatarSize: CGFloat = 54
        static let avatarLeadingPadding: CGFloat = 16
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
                AsyncImage(url: profileImageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(
                            width: DrawingConstants.avatarSize,
                            height: DrawingConstants.avatarSize
                        )
                } placeholder: {
                    Image(systemName: Resources.Image.photoIcon)
                        .frame(
                            width: DrawingConstants.avatarSize,
                            height: DrawingConstants.avatarSize
                        )
                }
                .padding(.leading, DrawingConstants.avatarLeadingPadding)
            
            VStack(
                alignment: .leading,
                spacing: DrawingConstants.textSpacing
            ) {
                Text(userName)
                    .font(Font.custom(.sfMedium, size: 16))
                    .foregroundColor(.white)
                
                Text(userEmail)
                    .font(Font.custom(.sfMedium, size: 14))
                    .foregroundColor(Color.gray)
            }
            
            .padding(.leading, DrawingConstants.textLeadingPadding)
            
            Spacer()
            
            NavigationLink(destination: ProfileEditView()
            )
               {
                    Image(Resources.Image.edit)
                        .foregroundColor(DS.Colors.blueNeon)
                        .padding(.trailing, DrawingConstants.padding)
                }
        }
        
        .padding()
        .background(.clear)
        .cornerRadius(DrawingConstants.cornerRadius)
        .overlay {
            RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                .stroke(
                    Color.gray,
                    lineWidth: DrawingConstants.strokeWidth
                )
                .opacity(DrawingConstants.strokeOpacity)
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
