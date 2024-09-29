//
//  ShimerPopularView.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 24.09.2024.
//

import SwiftUI

struct ShimerPopularView: View {
    // MARK: - Drawing Constants
    private struct Drawing {
        static let titleFontSize: CGFloat = 30
        static let pickerMaxWidth: CGFloat = 200
        static let pickerHeight: CGFloat = 25
        static let gridItemMinimumWidth: CGFloat = 129
        static let gridSpacing: CGFloat = 16
        static let verticalPadding: CGFloat = 10
        static let cornerRadius: CGFloat = 10
        static let backgroundColor: Color = DS.Colors.darkBlue
    }
    // MARK: - Properties
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    
    // MARK: - Body
    var body: some View {
        VStack {
            // MARK: - Header
            HStack() {
                // MARK: - Header
                RoundedRectangle(cornerRadius: Drawing.cornerRadius)
                    .frame(
                        width: Drawing.pickerMaxWidth,
                        height: Drawing.pickerHeight
                    )
                    .shimmer()
                Spacer()
                // MARK: - Display Order Picker
                RoundedRectangle(cornerRadius: Drawing.cornerRadius)
                    .frame(
                        width: Drawing.pickerMaxWidth,
                        height: Drawing.pickerHeight
                    )
                    .shimmer()
            }
            .padding(.vertical, Drawing.verticalPadding)
            
            // MARK: - Stations Grid
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: Drawing.gridItemMinimumWidth))
                ],
                spacing: Drawing.gridSpacing)
                {
                    ForEach(0..<9, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: Drawing.cornerRadius)
                            .fill(Color.gray.opacity(0.3))
                            .frame(
                                width: Drawing.gridItemMinimumWidth,
                                height: Drawing.gridItemMinimumWidth
                            )
                            .shimmer()
                    }
                }
            }
        }
        .background(Drawing.backgroundColor)
    }
}
#Preview {
    ShimerPopularView()
}
