//
//  NotificationCenter.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/03/05.
//

import Foundation

extension NotificationCenter {
    
    static func post(named name: NSNotification.Name) {
        self.default.post(name: name, object: nil)
    }
}
