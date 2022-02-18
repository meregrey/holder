//
//  PersistentContainer.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/05.
//

import CoreData
import Foundation

protocol PersistentContainerType {
    func performBackgroundTask(with notificationNameToReportError: NSNotification.Name,
                               block: @escaping (NSManagedObjectContext) throws -> Void)
}

final class PersistentContainer: PersistentContainerType {
    
    private let container: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "PersistenceModel")
        container.loadPersistentStores { _, error in
            if let _ = error {
                NotificationCenter.default.post(name: NotificationName.Persistence.didFailToLoadPersistentStore, object: nil)
            }
        }
        return container
    }()
    
    func performBackgroundTask(with notificationNameToReportError: NSNotification.Name,
                               block: @escaping (NSManagedObjectContext) throws -> Void) {
        container.performBackgroundTask { context in
            do {
                try block(context)
            } catch {
                NotificationCenter.default.post(name: notificationNameToReportError, object: nil)
            }
        }
    }
}
