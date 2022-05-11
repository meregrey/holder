//
//  NotificationCenter.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/03/05.
//

import Foundation

extension NotificationCenter {
    
    static func post(named name: NSNotification.Name, userInfo: [AnyHashable: Any]? = nil) {
        self.default.post(name: name, object: nil, userInfo: userInfo)
    }
    
    static func addObserver(_ observer: Any, selector: Selector, name: NSNotification.Name, object: Any? = nil) {
        self.default.addObserver(observer, selector: selector, name: name, object: object)
    }
}
