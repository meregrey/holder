//
//  KeychainItem.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/21.
//

import Foundation

struct KeychainItem<T: Decodable> {
    let value: T
    let account: String?
}
