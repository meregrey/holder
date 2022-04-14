//
//  ThumbnailLoader.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/03/02.
//

import LinkPresentation
import UIKit

final class ThumbnailLoader {
    
    static let shared = ThumbnailLoader()
    
    private let cache = Cache<URL, UIImage>()
    
    private init() {}
    
    func loadThumbnail(for url: URL, completion: @escaping (UIImage) -> Void) {
        if let cachedImage = cache[url] {
            completion(cachedImage)
            return
        }
        fetchImage(for: url) { image in
            let scaledImage = image.scaled(to: Size.thumbnail)
            self.cache[url] = scaledImage
            completion(scaledImage)
        }
    }
    
    private func fetchImage(for url: URL, block: @escaping (UIImage) -> Void) {
        LPMetadataProvider().startFetchingMetadata(for: url) { metadata, _ in
            guard let imageProvider = metadata?.imageProvider else { return }
            imageProvider.loadObject(ofClass: UIImage.self) { object, _ in
                guard let image = object as? UIImage else { return }
                block(image)
            }
        }
    }
}
