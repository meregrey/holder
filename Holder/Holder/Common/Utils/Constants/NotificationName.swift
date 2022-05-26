//
//  NotificationName.swift
//  Holder
//
//  Created by Yeojin Yoon on 2021/12/29.
//

import Foundation

enum NotificationName {
    enum Store {
        static let didFailToCheckStore = NSNotification.Name("didFailToCheckStore")
        static let didFailToLoadStore = NSNotification.Name("didFailToLoadStore")
        static let didFailToSaveStore = NSNotification.Name("didFailToSaveStore")
    }
    
    enum Bookmark {
        static let didSucceedToClearBookmarks = NSNotification.Name("didSucceedToClearBookmarks")
        static let didSucceedToUpdateBookmark = NSNotification.Name("didSucceedToUpdateBookmark")
        static let noSearchResults = NSNotification.Name("noSearchResults")
        static let sortDidChange = NSNotification.Name("sortDidChange")
    }
    
    enum Tag {
        static let didSucceedToAddTag = NSNotification.Name("didSucceedToAddTag")
        static let didSucceedToClearTags = NSNotification.Name("didSucceedToClearTags")
        static let tagsDidChange = NSNotification.Name("tagsDidChange")
    }
    
    static let didFailToProcessData = NSNotification.Name("didFailToProcessData")
    static let lastShareDateDidChange = NSNotification.Name("lastShareDateDidChange")
}
