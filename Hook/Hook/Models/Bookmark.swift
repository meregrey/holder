//
//  Bookmark.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/24.
//

import Foundation

struct Bookmark {
    let url: URL
    let tags: [BookmarkTag]?
    let note: String?
    let title: String?
    
    init(url: URL, tags: [Tag]?, note: String?, title: String?) {
        self.url = url
        self.tags = tags?.enumerated().map { BookmarkTag(name: $0.element.name, index: $0.offset) }
        self.note = note
        self.title = title
    }
}
