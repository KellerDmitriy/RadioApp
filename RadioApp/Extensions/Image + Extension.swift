//
//  Image + Extension.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 19.08.2024.
//
import SwiftUI

// MARK: - Image Extension
extension Image {
    
    // MARK: - Resizable to Fit
    /// Adjusts the image to fit within its container while maintaining its aspect ratio.
    /// - Returns: A view that scales the image to fit its container.
    func resizableToFit() -> some View {
        resizable()
            .scaledToFit()
    }

    // MARK: - Resizable to Fill
    /// Adjusts the image to fill its container while maintaining its aspect ratio.
    /// - Returns: A view that scales the image to fill its container.
    func resizableToFill() -> some View {
        resizable()
            .scaledToFill()
    }
}
