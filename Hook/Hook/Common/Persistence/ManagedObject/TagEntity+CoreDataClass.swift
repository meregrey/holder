//
//  TagEntity+CoreDataClass.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/04/07.
//

import CoreData
import Foundation

@objc(TagEntity)
public class TagEntity: NSManagedObject {
    
    func configure(name: String, index: Int) {
        self.name = name
        self.index = Int16(index)
    }
}
