//
//  TagEntity.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/04.
//

import Foundation

public final class TagEntity: NSObject, NSSecureCoding {
    
    public static var supportsSecureCoding: Bool = true
    
    public var name: String
    
    public init(name: String) {
        self.name = name
        super.init()
    }
    
    public convenience init?(coder: NSCoder) {
        guard let name = coder.decodeObject(of: NSString.self, forKey: Key.name) as String? else { return nil }
        self.init(name: name)
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(name, forKey: Key.name)
    }
}

extension TagEntity {
    
    private enum Key {
        static let name = "name"
    }
    
    func converted() -> Tag {
        return Tag(name: name)
    }
}
