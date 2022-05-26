//
//  TagRepository.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/01/05.
//

import CoreData

protocol TagRepositoryType {
    func fetchedResultsController() -> NSFetchedResultsController<TagEntity>
    func isExisting(_ name: String) -> Result<Bool, Error>
    func add(_ tag: Tag) -> Result<Void, Error>
    func update(_ tag: Tag, to newTag: Tag) -> Result<Void, Error>
    func update(_ tags: [Tag]) -> Result<Void, Error>
    func delete(_ tags: [Tag]) -> Result<Void, Error>
    func clear()
}

final class TagRepository: TagRepositoryType {
    
    static let shared = TagRepository()
    
    private let persistentContainer = PersistentContainer.shared
    
    private var viewContext: NSManagedObjectContext { persistentContainer.viewContext }
    private var backgroundContext: NSManagedObjectContext { persistentContainer.backgroundContext }
    
    private init() {}
    
    func fetchedResultsController() -> NSFetchedResultsController<TagEntity> {
        let request = TagEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(TagEntity.index), ascending: true)
        request.sortDescriptors = [sortDescriptor]
        return NSFetchedResultsController(fetchRequest: request,
                                          managedObjectContext: viewContext,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }
    
    func isExisting(_ name: String) -> Result<Bool, Error> {
        let request = TagEntity.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(TagEntity.name), name)
        request.predicate = predicate
        do {
            let count = try backgroundContext.count(for: request)
            return .success(count > 0)
        } catch {
            return .failure(error)
        }
    }
    
    func add(_ tag: Tag) -> Result<Void, Error> {
        let request = TagEntity.fetchRequest()
        do {
            let index = try backgroundContext.count(for: request)
            let tagEntity = TagEntity(context: backgroundContext)
            tagEntity.configure(name: tag.name, index: index)
            try backgroundContext.save()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func update(_ tag: Tag, to newTag: Tag) -> Result<Void, Error> {
        if tag.name == newTag.name { return .success(()) }
        let request = TagEntity.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(TagEntity.name), tag.name)
        request.predicate = predicate
        do {
            guard let tagEntity = try backgroundContext.fetch(request).first else { return .success(()) }
            tagEntity.name = newTag.name
            try backgroundContext.save()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func update(_ tags: [Tag]) -> Result<Void, Error> {
        let request = TagEntity.fetchRequest()
        do {
            let tagEntities = try backgroundContext.fetch(request)
            tagEntities.forEach {
                guard let index = tags.firstIndex(of: Tag(name: $0.name)) else { return }
                $0.index = Int16(index)
            }
            try backgroundContext.save()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func delete(_ tags: [Tag]) -> Result<Void, Error> {
        let request = TagEntity.fetchRequest()
        request.includesPropertyValues = false
        do {
            try tags.forEach {
                let predicate = NSPredicate(format: "%K == %@", #keyPath(TagEntity.name), $0.name)
                request.predicate = predicate
                guard let tagEntity = try backgroundContext.fetch(request).first else { return }
                backgroundContext.delete(tagEntity)
                try backgroundContext.save()
            }
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func clear() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TagEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        guard let _ = try? backgroundContext.execute(deleteRequest) else {
            NotificationCenter.post(named: NotificationName.didFailToProcessData)
            return
        }
        NotificationCenter.post(named: NotificationName.Tag.didSucceedToClearTags)
    }
}
