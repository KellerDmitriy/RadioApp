//
//  AsyncImageView.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 22.09.2024.
//

import SwiftUI
import CryptoKit

struct AsyncImageView<C: View>: View {
    @Environment(\.displayScale) private var displayScale
    
    private let cache: ICacheImage
    private let url: URL?
    private let configureImage: (Image) -> C
    @State private var image: Image?
    @State private var loadedFromCache = false
    
    //MARK: - init(_:)
    init(
        _ urlString: String?,
        cache: ICacheImage = CacheImageImpl.shared,
        configureImage: @escaping (Image) -> C = { $0 }
    ) {
        self.url = urlString.flatMap(URL.init)
        self.cache = cache
        self.configureImage = configureImage
    }
    
    //MARK: - Body
    var body: some View {
        Group {
            switch self.image {
            case .some(let image):
                configureImage(image)
                
            case .none:
                Image(systemName: "square.fill")
                    .resizable()
                    .shimmer()
            }
        }
        .task {
            if let cachedImage = await getCachedImage() {
                self.image = Image(decorative: cachedImage, scale: displayScale)
                self.loadedFromCache = true
                print("Image loaded from cache.")
            } else {
                if let downloadedImage = await getUIImageFromNetwork() {
                    self.image = Image(decorative: downloadedImage, scale:  displayScale)
                    self.loadedFromCache = false
                    print("Image downloaded from network.")
                }
            }
        }
    }
    
    // MARK: - Get Cached Image
    private func getCachedImage() async -> CGImage? {
        guard let url = url else { return nil }
        return cache.getImage(for: url)
    }
    
    // MARK: - Get UIImage From Network
    private func getUIImageFromNetwork() async -> CGImage? {
        guard let url = url else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let uiImage = UIImage(data: data)?.cgImage else { return nil }
            
            if let cachedImage = cache.getImage(for: url),
               isSameImage(cachedImage, data: data) {
                print("Image not changed, no need to update cache.")
                return cachedImage
            }
            cache.save(uiImage, for: url)
            return uiImage
        } catch {
            print("Error downloading image from network: \(error)")
            return nil
        }
    }
    
    // MARK: - Compare Images Using Hash
    private func isSameImage(_ cachedImage: CGImage, data: Data) -> Bool {
        let cachedImageData = UIImage(cgImage: cachedImage).pngData()
        let cachedImageHash = cachedImageData.map { sha256($0) }
        let newImageHash = sha256(data)
        
        return cachedImageHash == newImageHash
    }
    
    // MARK: - Compute SHA256 Hash
    private func sha256(_ data: Data) -> String {
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
}

#Preview {
    AsyncImageView("https://buffer.com/library/content/images/size/w1200/2023/09/instagram-image-size.jpg")
}


