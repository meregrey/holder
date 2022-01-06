//
//  Convertible.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/26.
//

import Foundation

protocol Convertible {
    static func converted(from data: Data) -> Self?
    func converted() -> Data
}

extension String: Convertible {
    static func converted(from data: Data) -> Self? {
        return String(data: data, encoding: .utf8)
    }
    
    func converted() -> Data {
        return Data(self.utf8)
    }
}
