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
    
    static let shared = PersistentContainer()
    
    private lazy var container: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "PersistenceModel")
        container.loadPersistentStores { _, error in
            guard error == nil else {
                NotificationCenter.post(named: NotificationName.Store.didFailToLoad)
                return
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var context: NSManagedObjectContext { container.viewContext }
    
    private init() {}
}
