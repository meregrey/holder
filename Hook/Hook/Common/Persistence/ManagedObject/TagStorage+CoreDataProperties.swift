//
//  TagStorage+CoreDataProperties.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/04.
//

import CoreData
import Foundation

extension TagStorage {
    
    @NSManaged public var tags: [TagEntity]?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TagStorage> {
        return NSFetchRequest<TagStorage>(entityName: "TagStorage")
    }
}

extension TagStorage: Identifiable {}
