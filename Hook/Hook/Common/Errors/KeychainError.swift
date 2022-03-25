//
//  KeychainError.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/21.
//

import Foundation

enum KeychainError: Error {
    case failedToConvert
    case invalidData
    case unhandledError(status: OSStatus)
}
