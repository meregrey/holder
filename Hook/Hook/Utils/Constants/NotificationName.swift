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
        static let didFailToFetchBookmarks = NSNotification.Name("didFailToFetchBookmarks")
        static let didSucceedToAddBookmark = NSNotification.Name("didSucceedToAddBookmark")
        static let existingBookmark = NSNotification.Name("existingBookmark")
    }
    
    enum Credential {
        static let didFailToSave = NSNotification.Name("didFailToSave")
    }
    
    enum Metadata {
        static let didFailToFetch = NSNotification.Name("didFailToFetch")
    }
    
    enum Store {
        static let didFailToCheck = NSNotification.Name("didFailToCheck")
        static let didFailToLoad = NSNotification.Name("didFailToLoad")
        static let didFailToSave = NSNotification.Name("didFailToSave")
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
