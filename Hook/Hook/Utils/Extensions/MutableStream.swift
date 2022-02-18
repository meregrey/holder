//
//  MutableStream.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/02/17.
//

import Foundation

extension MutableStream where T == [Tag: [Bookmark]] {
    
    func update(with bookmark: Bookmark) {
        var dictionary = value
        var tags: [Tag]
        
        if let bookmarkTags = bookmark.tags {
            tags = [Tag(name: TagName.all)] + bookmarkTags.map({ Tag(name: $0.name) })
        } else {
            tags = [Tag(name: TagName.all)]
        }
        
        tags.forEach {
            if var bookmarks = dictionary[$0] {
                bookmarks.insert(bookmark, at: 0)
                dictionary.updateValue(bookmarks, forKey: $0)
            } else {
                dictionary.updateValue([bookmark], forKey: $0)
            }
        }
        
        update(with: dictionary)
    }
}
