//
//  Tag.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/05.
//

import Foundation

struct Tag: Equatable {
    let name: String
    
    static func == (lhs: Tag, rhs: Tag) -> Bool {
        return lhs.name == rhs.name
    }
}

extension Tag {
    func converted() -> TagEntity {
        return TagEntity(name: name)
    }
}
