//
//  TagStorage+CoreDataClass.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/04.
//

import CoreData
import Foundation

@objc(TagStorage)
public class TagStorage: NSManagedObject {
    
    func extractTags() -> [Tag] {
        let tags = tags ?? []
        return tags.map { $0.converted() }
    }
}
