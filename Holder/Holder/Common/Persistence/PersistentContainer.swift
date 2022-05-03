//
//  PersistentContainer.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/01/05.
//

import CoreData

protocol PersistentContainerType {
    var context: NSManagedObjectContext { get }
}

final class PersistentContainer: PersistentContainerType {
    
    static let shared = PersistentContainer()
    
    var context: NSManagedObjectContext { container.viewContext }
    
    private let dataModelName = "PersistenceModel"
    private let appGroupIdentifier = "group.com.meregrey.holder"
    
    private lazy var container: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: dataModelName)
        let storeDescription = NSPersistentStoreDescription(url: containerURL())
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
