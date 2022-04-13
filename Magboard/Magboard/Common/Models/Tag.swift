//
//  Tag.swift
//  Magboard
//
//  Created by Yeojin Yoon on 2022/01/05.
//

import Foundation

struct Tag: Hashable {
    let name: String
    
    static func == (lhs: Tag, rhs: Tag) -> Bool {
        return lhs.name == rhs.name
    }
}
