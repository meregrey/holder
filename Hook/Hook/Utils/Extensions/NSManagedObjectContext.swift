//
//  NSManagedObjectContext.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/02/25.
//

import CoreData

extension NSManagedObjectContext {
    
    func perform(with notificationNameToReportError: NSNotification.Name, block: @escaping () throws -> Void) {
        perform {
            do {
                try block()
            } catch {
                NotificationCenter.default.post(name: notificationNameToReportError, object: nil)
            }
        }
    }
}
