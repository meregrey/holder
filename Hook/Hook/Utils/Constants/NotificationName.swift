//
//  NotificationName.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/29.
//

import Foundation

enum NotificationName {
    enum Bookmark {
        static let didFailToAddBookmark = NSNotification.Name("didFailToAddBookmark")
        static let didSucceedToAddBookmark = NSNotification.Name("didSucceedToAddBookmark")
        static let existingBookmark = NSNotification.Name("existingBookmark")
    }
    
    enum Credential {
        static let didFailToSaveCredential = NSNotification.Name("didFailToSaveCredential")
    }
    
    enum Persistence {
        static let didFailToLoadPersistentStore = NSNotification.Name("didFailToLoadPersistentStore")
    }
    
    enum Tag {
        static let didFailToAddTag = NSNotification.Name("didFailToAddTag")
        static let didFailToFetchTags = NSNotification.Name("didFailToFetchTags")
        static let didFailToSetUpDefaultTag = NSNotification.Name("didFailToSetUpDefaultTag")
        static let didFailToUpdateTag = NSNotification.Name("didFailToUpdateTag")
        static let didFailToUpdateTags = NSNotification.Name("didFailToUpdateTags")
        static let didSucceedToAddTag = NSNotification.Name("didSucceedToAddTag")
        static let existingTag = NSNotification.Name("existingTag")
    }
}
