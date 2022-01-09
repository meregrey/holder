//
//  TagStorageTransformer.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/08.
//

import Foundation

final class TagStorageTransformer: NSSecureUnarchiveFromDataTransformer {
    
    override class var allowedTopLevelClasses: [AnyClass] {
        return [NSArray.self, TagEntity.self]
    }
    
    static func register() {
        let className = String(describing: TagStorageTransformer.self)
        let transformerName = NSValueTransformerName(className)
        let transformer = TagStorageTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: transformerName)
    }
}
