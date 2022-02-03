//
//  Bookmark.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/24.
//

import Foundation

struct Bookmark: Equatable {
    let url: URL
    var isFavorite: Bool
    var tags: [BookmarkTag]?
    var note: String?
    var title: String?
    var host: String?
    
    static func == (lhs: Bookmark, rhs: Bookmark) -> Bool {
        return lhs.url == rhs.url
    }
}
