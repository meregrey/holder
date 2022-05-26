//
//  NotificationName.swift
//  Holder
//
//  Created by Yeojin Yoon on 2021/12/29.
//

import Foundation

enum NotificationName {
    enum Store {
        static let didFailToCheck = NSNotification.Name("didFailToCheck")
        static let didFailToLoad = NSNotification.Name("didFailToLoad")
        static let didFailToSave = NSNotification.Name("didFailToSave")
        static let didSucceedToClear = NSNotification.Name("didSucceedToClear")
    }
    
    enum Bookmark {
        static let didSucceedToUpdate = NSNotification.Name("didSucceedToUpdate")
        static let noSearchResults = NSNotification.Name("noSearchResults")
        static let sortDidChange = NSNotification.Name("sortDidChange")
    }
    
    enum Tag {
        static let didChange = NSNotification.Name("didChange")
        static let didSucceedToAdd = NSNotification.Name("didSucceedToAdd")
        static let didSucceedToClearTags = NSNotification.Name("didSucceedToClearTags")
    }
    
    static let didFailToProcessData = NSNotification.Name("didFailToProcessData")
    static let lastShareDateDidChange = NSNotification.Name("lastShareDateDidChange")
}
