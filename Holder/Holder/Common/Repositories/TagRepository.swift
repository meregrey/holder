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
    
    private var context: NSManagedObjectContext { PersistentContainer.shared.context }
    
    private init() {}
    
    func fetchedResultsController() -> NSFetchedResultsController<TagEntity> {
        let request = TagEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(TagEntity.index), ascending: true)
        request.sortDescriptors = [sortDescriptor]
        return NSFetchedResultsController(fetchRequest: request,
                                          managedObjectContext: context,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }
    
    func isExisting(_ name: String) -> Result<Bool, Error> {
        let request = TagEntity.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(TagEntity.name), name)
        request.predicate = predicate
        do {
            let count = try context.count(for: request)
            return .success(count > 0)
        } catch {
            return .failure(error)
        }
    }
    
    func add(_ tag: Tag) -> Result<Void, Error> {
        let request = TagEntity.fetchRequest()
        do {
            let index = try context.count(for: request)
            let tagEntity = TagEntity(context: context)
            tagEntity.configure(name: tag.name, index: index)
            try context.save()
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
            guard let tagEntity = try context.fetch(request).first else { return .success(()) }
            tagEntity.name = newTag.name
            try context.save()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func update(_ tags: [Tag]) -> Result<Void, Error> {
        let request = TagEntity.fetchRequest()
        do {
            let tagEntities = try context.fetch(request)
            tagEntities.forEach {
                guard let index = tags.firstIndex(of: Tag(name: $0.name)) else { return }
                $0.index = Int16(index)
            }
            try context.save()
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
                guard let tagEntity = try context.fetch(request).first else { return }
                context.delete(tagEntity)
                try context.save()
            }
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func clear() {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: TagEntity.fetchRequest())
        deleteRequest.resultType = .resultTypeObjectIDs
        let deleteResult = try? context.execute(deleteRequest) as? NSBatchDeleteResult
        guard let objectIDs = deleteResult?.result as? [NSManagedObjectID] else { return }
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: objectIDs], into: [context])
    }
}
