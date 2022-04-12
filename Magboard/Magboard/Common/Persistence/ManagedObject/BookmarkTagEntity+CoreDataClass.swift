//
//  BookmarkTagEntity+CoreDataClass.swift
//  Magboard
//
//  Created by Yeojin Yoon on 2022/01/23.
//

import CoreData
import Foundation

@objc(BookmarkTagEntity)
public class BookmarkTagEntity: NSManagedObject {
    
    func configure(with bookmarkTag: BookmarkTag, bookmarkEntity: BookmarkEntity) {
        bookmark = bookmarkEntity
        name = bookmarkTag.name
        index = Int16(bookmarkTag.index)
    }
}
