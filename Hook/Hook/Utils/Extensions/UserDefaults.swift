//
//  UserDefaults.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/03/16.
//

import UIKit

extension UserDefaults {
    
    static func value<T: Codable>(forType: T.Type) -> T? {
        guard let data = UserDefaults.standard.object(forKey: String(describing: T.self)) as? Data else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    static func set<T: Codable>(_ value: T) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        UserDefaults.standard.set(data, forKey: String(describing: T.self))
    }
}
