//
//  CacheImage.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 22.09.2024.
//

import Foundation
import CoreImage

// MARK: - ICacheImage Protocol
/// Protocol defining methods for image caching
protocol ICacheImage {
    /// Saves an image to the cache for a given URL
    /// - Parameters:
    ///   - image: The image to save
    ///   - url: The URL associated with the image
    /// - Returns: The saved CGImage
    @discardableResult
    func save(_ image: CGImage, for url: URL) -> CGImage
    
    /// Retrieves an image from the cache for a given URL
    /// - Parameter url: The URL associated with the image
    /// - Returns: The cached CGImage, or nil if not found
    func getImage(for url: URL) -> CGImage?
}

// MARK: - CacheImageImpl Class
/// Implementation of ICacheImage for caching CGImages
final class CacheImageImpl: ICacheImage {
    
    static let shared = CacheImageImpl()
    
    // MARK: - Properties
    /// NSCache for storing images
    private let cache = NSCache<NSURL, CGImage>()
 
    // MARK: - Init
    private init() {}
    
    // MARK: - Methods
    /// Saves an image to the cache for a given URL
    /// - Parameters:
    ///   - image: The image to save
    ///   - url: The URL associated with the image
    /// - Returns: The saved CGImage
    @discardableResult
    func save(_ image: CGImage, for url: URL) -> CGImage {
        NSURL(string: url.absoluteString)
            .map { (image, $0) } // Create tuple of image and NSURL
            .map(cache.setObject) // Save the image in cache
        return image
    }
    
    /// Retrieves an image from the cache for a given URL
    /// - Parameter url: The URL associated with the image
    /// - Returns: The cached CGImage, or nil if not found
    func getImage(for url: URL) -> CGImage? {
        NSURL(string: url.absoluteString)
            .flatMap(cache.object) // Get the image from cache
    }
}
