//
//  TagEntity+CoreDataProperties.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/04/07.
//

import CoreData
import Foundation

extension TagEntity {
    
    @NSManaged public var name: String
    @NSManaged public var index: Int16
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TagEntity> {
        return NSFetchRequest<TagEntity>(entityName: "TagEntity")
    }
}

extension TagEntity: Identifiable {}
