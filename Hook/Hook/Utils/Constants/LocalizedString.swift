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
    
    enum ButtonTitle {
        static let add = "Add".localized
        static let delete = "Delete".localized
        static let save = "Save".localized
    }
    
    enum TagName {
        static let all = "All".localized
    }
    
    enum TextFieldHeader {
        static let tagName = "Tag name".localized
    }
    
    enum ViewTitle {
        static let browse = "Browse".localized
        static let search = "Search".localized
        static let favorites = "Favorites".localized
        static let account = "Account".localized
        static let tagSettings = "Tag Settings".localized
        static let addTag = "Add Tag".localized
        static let editTag = "Edit Tag".localized
        static let editTags = "Edit Tags".localized
        static let addBookmark = "Add Bookmark".localized
    }
}
