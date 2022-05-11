//
//  BookmarkViewModel.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/03/02.
//

import UIKit

final class BookmarkViewModel {
    
    let isFavorite: Bool
    let title: String?
    let host: String?
    let note: String?
    
    private let url: URL?
    
    private var handler: ((UIImage?) -> Void)?
    private var thumbnail: UIImage? { didSet { handler?(thumbnail) } }
    
    init(with bookmarkEntity: BookmarkEntity) {
        self.isFavorite = bookmarkEntity.isFavorite
        self.title = bookmarkEntity.title
        self.host = bookmarkEntity.host
        self.note = bookmarkEntity.note
        self.url = URL(string: bookmarkEntity.urlString)
    }
    
    func bind(_ handler: @escaping (UIImage?) -> Void) {
        self.handler = handler
    }
    
    func loadThumbnail() {
        guard let url = url else { return }
        ThumbnailLoader.shared.loadThumbnail(for: url) { [weak self] thumbnail in
            self?.thumbnail = thumbnail
        }
    }
}
