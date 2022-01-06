//
//  NotificationName.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/29.
//

import Foundation

enum NotificationName {
    static let didFailToAddTag = NSNotification.Name("didFailToAddTag")
    static let didFailToFetchTags = NSNotification.Name("didFailToFetchTags")
    static let didFailToLoadPersistentStore = NSNotification.Name("didFailToLoadPersistentStore")
    static let didFailToSaveCredential = NSNotification.Name("didFailToSaveCredential")
    static let didFailToSetUpDefaultTag = NSNotification.Name("didFailToSetUpDefaultTag")
    static let didFailToUpdateTag = NSNotification.Name("didFailToUpdateTag")
    static let didFailToUpdateTags = NSNotification.Name("didFailToUpdateTags")
    static let existingTag = NSNotification.Name("existingTag")
}
