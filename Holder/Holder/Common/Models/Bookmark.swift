//
//  Bookmark.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/01/24.
//

import Foundation

struct Bookmark {
    let url: URL
    let tags: [BookmarkTag]?
    let note: String?
    let title: String?
    
    func updated(tags: [Tag]?, note: String?) -> Self {
        return Bookmark(url: url, tags: tags, note: note, title: title)
    }
    
    func updated(title: String?) -> Self {
        return Bookmark(url: url, tags: tags, note: note, title: title)
    }
}

extension Bookmark {
    init(url: URL, tags: [Tag]?, note: String?, title: String?) {
        let tags = tags?.enumerated().map { BookmarkTag(name: $0.element.name, index: $0.offset) }
        self.init(url: url, tags: tags, note: note, title: title)
    }
}
