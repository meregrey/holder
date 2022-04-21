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
    
    private let dataModelName = "PersistenceModel"
    
    private lazy var container: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: dataModelName)
        let storeDescription = NSPersistentStoreDescription(url: containerURL())
        container.persistentStoreDescriptions = [storeDescription]
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
    
    private func containerURL() -> URL {
        guard let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.meregrey.holder") else { return URL(fileURLWithPath: "") }
        return url.appendingPathComponent("\(dataModelName).sqlite")
    }
}
