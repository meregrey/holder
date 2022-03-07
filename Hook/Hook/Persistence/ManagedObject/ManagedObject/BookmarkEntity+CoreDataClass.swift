//
//  BookmarkEntity+CoreDataClass.swift
//  Hook
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
}
