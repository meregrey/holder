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
        static let tagAlreadySelected = "Tag Already Selected".localized
        static let enterTheURL = "Enter the URL.".localized
    }
    
    enum AlertMessage {
        static let keychainErrorOccured = "An error occurred while saving your login information to the keychain.".localized
        static let tagAlreadySelected = "Check out the tag in the list.".localized
    }
    
    enum AlertActionTitle {
        static let ok = "OK".localized
    }
    
    enum ButtonTitle {
        static let add = "Add".localized
        static let cancel = "Cancel".localized
        static let delete = "Delete".localized
        static let done = "Done".localized
        static let save = "Save".localized
    }
    
    enum LabelTitle {
        static let tagName = "Tag name".localized
        static let tags = "Tags".localized
        static let note = "Note".localized
    }
    
    enum Placeholder {
        static let searchAndAdd = "Search & Add".localized
    }
    
    enum TagName {
        static let all = "All".localized
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
        static let selectTags = "Select Tags".localized
        static let addBookmark = "Add Bookmark".localized
    }
}
