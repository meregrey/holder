//
//  BookmarkEntity+CoreDataClass.swift
//  Magboard
//
//  Created by Yeojin Yoon on 2022/01/23.
//

import CoreData
import Foundation

@objc(BookmarkEntity)
public class BookmarkEntity: NSManagedObject {
    
    func configure(with bookmark: Bookmark) {
        self.urlString = bookmark.url.absoluteString
        self.creationDate = Date()
        self.isFavorite = false
        self.note = bookmark.note
        self.title = bookmark.title
        self.host = bookmark.url.host
        
        guard let tags = bookmark.tags else { return }
        guard let context = managedObjectContext else { return }
        
        tags.forEach {
            let bookmarkTagEntity = BookmarkTagEntity(context: context)
            bookmarkTagEntity.configure(with: $0, bookmarkEntity: self)
            addToTags(bookmarkTagEntity)
        }
    }
    
    func converted() -> Bookmark? {
        guard let url = URL(string: self.urlString) else { return nil }
        let bookmarkTagEntities = self.tags?.allObjects as? [BookmarkTagEntity]
        let bookmarkTags = bookmarkTagEntities?.map { BookmarkTag(name: $0.name, index: Int($0.index)) }
        return Bookmark(url: url, tags: bookmarkTags, note: self.note, title: self.title)
    }
    
    func update(with bookmark: Bookmark) {
        self.note = bookmark.note
        
        guard let tags = bookmark.tags else { return }
        guard let context = managedObjectContext else { return }
        
        tags.forEach {
            let bookmarkTagEntity = BookmarkTagEntity(context: context)
            bookmarkTagEntity.configure(with: $0, bookmarkEntity: self)
            addToTags(bookmarkTagEntity)
        }
    }
}
