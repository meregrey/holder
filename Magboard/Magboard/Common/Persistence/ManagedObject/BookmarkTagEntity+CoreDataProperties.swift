//
//  BookmarkTagEntity+CoreDataProperties.swift
//  Magboard
//
//  Created by Yeojin Yoon on 2022/01/23.
//

import CoreData
import Foundation

extension BookmarkTagEntity {
    
    @NSManaged public var bookmark: BookmarkEntity
    @NSManaged public var name: String
    @NSManaged public var index: Int16
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookmarkTagEntity> {
        return NSFetchRequest<BookmarkTagEntity>(entityName: "BookmarkTagEntity")
    }
}

extension BookmarkTagEntity: Identifiable {}
