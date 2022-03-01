//
//  PersistentContainer.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/05.
//

import CoreData

protocol PersistentContainerType {
    var context: NSManagedObjectContext { get }
}

final class PersistentContainer: PersistentContainerType {
    
    private let container: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "PersistenceModel")
        container.loadPersistentStores { _, error in
            if let _ = error {
                NotificationCenter.default.post(name: NotificationName.Store.didFailToLoad, object: nil)
            }
        }
        return container
    }()
    
    private(set) lazy var context = container.newBackgroundContext()
}
