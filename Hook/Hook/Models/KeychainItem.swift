//
//  KeychainItem.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/21.
//

import Foundation

struct KeychainItem<T: Convertible> {
    let value: T
    let account: String?
}
