//
//  Notification.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/22.
//

import Foundation

enum NotificationName {
    static let credentialErrorDidOccur = NSNotification.Name("credentialErrorDidOccur")
}

enum NotificationUserInfoKey {
    static let error = "error"
}
