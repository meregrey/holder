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
    
    func configure(url: URL, tags: [Tag]?, note: String?, title: String?, host: String?) {
        self.urlString = url.absoluteString
        self.creationDate = Date()
        self.isFavorite = false
        self.note = note
        self.title = title
        self.host = host
        
        guard let tags = tags else { return }
        guard let context = managedObjectContext else { return }
        
        tags.enumerated().forEach {
            let bookmarkTagEntity = BookmarkTagEntity(context: context)
            bookmarkTagEntity.configure(with: BookmarkTag(name: $1.name, index: $0), bookmarkEntity: self)
            addToTags(bookmarkTagEntity)
        }
    }
}
