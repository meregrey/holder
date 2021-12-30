//
//  LocalizedString.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/29.
//

import Foundation

enum LocalizedString {
    enum AlertTitle {
        static let keychainErrorOccured = "Keychain Error Occured".localized
    }
    
    enum AlertMessage {
        static let keychainErrorOccuredWhileSaving = "An error occurred while saving your login information to the keychain.".localized
    }
    
    enum AlertActionTitle {
        static let ok = "OK".localized
    }
}
