//
//  BookmarkEntity+CoreDataProperties.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/23.
//

import CoreData
import Foundation

extension BookmarkEntity {
    
    @NSManaged public var urlString: String
    @NSManaged public var creationDate: Date
    @NSManaged public var isFavorite: Bool
    @NSManaged public var tags: NSSet?
    @NSManaged public var note: String?
    @NSManaged public var title: String?
    @NSManaged public var host: String?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookmarkEntity> {
        return NSFetchRequest<BookmarkEntity>(entityName: "BookmarkEntity")
    }
}

extension BookmarkEntity {
    
    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: BookmarkTagEntity)
    
    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: BookmarkTagEntity)
    
    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)
    
    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)
}

extension BookmarkEntity: Identifiable {}
