//
//  PersistentContainer.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/01/05.
//

import CoreData

protocol PersistentContainerType {
    var viewContext: NSManagedObjectContext { get }
    var backgroundContext: NSManagedObjectContext { get }
}

final class PersistentContainer: PersistentContainerType {
    
    static let shared = PersistentContainer()
    
    var viewContext: NSManagedObjectContext { container.viewContext }
    
    private(set) lazy var backgroundContext: NSManagedObjectContext = {
        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return context
    }()
    
    private let dataModelName = "PersistenceModel"
    private let appGroupIdentifier = "group.com.yeojin-yoon.holder"
    private let containerIdentifier = "iCloud.com.yeojin-yoon.holder"
    
    private lazy var container: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: dataModelName)
        let storeDescription = NSPersistentStoreDescription(url: containerURL())
        storeDescription.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: containerIdentifier)
        container.persistentStoreDescriptions = [storeDescription]
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores { _, error in
            guard error == nil else {
                NotificationCenter.post(named: NotificationName.Store.didFailToLoad)
                return
            }
        }
        return container
    }()
    
    private init() {}
    
    private func containerURL() -> URL {
        guard let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupIdentifier) else { return URL(fileURLWithPath: "") }
        return url.appendingPathComponent("\(dataModelName).sqlite")
    }
}
