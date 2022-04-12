//
//  BookmarkRepository.swift
//  Magboard
//
//  Created by Yeojin Yoon on 2022/03/05.
//

import CoreData

protocol BookmarkRepositoryType {
    func fetchedResultsController(isFavorite: Bool) -> NSFetchedResultsController<BookmarkEntity>
    func fetchedResultsController(for tag: Tag) -> NSFetchedResultsController<BookmarkTagEntity>
    func fetchedResultsController(for searchTerm: String, isFavorite: Bool) -> NSFetchedResultsController<BookmarkEntity>
    func isExisting(_ url: URL) -> Result<Bool, Error>
    func add(with bookmark: Bookmark) -> Result<Void, Error>
    func update(with bookmark: Bookmark) -> Result<Void, Error>
    func update(_ bookmarkEntity: BookmarkEntity) -> Result<Bool, Error>
    func delete(_ bookmarkEntity: BookmarkEntity) -> Result<Void, Error>
    func deleteTags(for tag: Tag)
    func clear()
}

final class BookmarkRepository: BookmarkRepositoryType {
    
    static let shared = BookmarkRepository()
    
    var context: NSManagedObjectContext { PersistentContainer.shared.context }
    
    var ascending: Bool {
        let sort = UserDefaults.value(forType: Sort.self) ?? .newestToOldest
        return sort == .newestToOldest ? false : true
    }
    
    private init() {}
    
    func fetchedResultsController(isFavorite: Bool = false) -> NSFetchedResultsController<BookmarkEntity> {
        let request = BookmarkEntity.fetchRequest()
        
        if isFavorite {
            let predicate = NSPredicate(format: "%K == YES", #keyPath(BookmarkEntity.isFavorite))
            request.predicate = predicate
        }
        
        let sortDescriptor = NSSortDescriptor(key: #keyPath(BookmarkEntity.creationDate), ascending: ascending)
        request.sortDescriptors = [sortDescriptor]
        return NSFetchedResultsController(fetchRequest: request,
                                          managedObjectContext: context,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }
    
    func fetchedResultsController(for tag: Tag) -> NSFetchedResultsController<BookmarkTagEntity> {
        let request = BookmarkTagEntity.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(BookmarkTagEntity.name), tag.name)
        let sortDescriptor = NSSortDescriptor(key: #keyPath(BookmarkTagEntity.bookmark.creationDate), ascending: ascending)
        request.predicate = predicate
        request.sortDescriptors = [sortDescriptor]
        return NSFetchedResultsController(fetchRequest: request,
                                          managedObjectContext: context,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }
    
    func fetchedResultsController(for searchTerm: String, isFavorite: Bool = false) -> NSFetchedResultsController<BookmarkEntity> {
        let request = BookmarkEntity.fetchRequest()
        let titlePredicate = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(BookmarkEntity.title), searchTerm)
        let urlPredicate = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(BookmarkEntity.urlString), searchTerm)
        let notePredicate = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(BookmarkEntity.note), searchTerm)
        var predicates = NSCompoundPredicate(type: .or, subpredicates: [titlePredicate, urlPredicate, notePredicate])
        
        if isFavorite {
            let isFavoritePredicate = NSPredicate(format: "%K == YES", #keyPath(BookmarkEntity.isFavorite))
            predicates = NSCompoundPredicate(type: .and, subpredicates: [predicates, isFavoritePredicate])
        }
        
        let sortDescriptor = NSSortDescriptor(key: #keyPath(BookmarkEntity.creationDate), ascending: ascending)
        request.predicate = predicates
        request.sortDescriptors = [sortDescriptor]
        return NSFetchedResultsController(fetchRequest: request,
                                          managedObjectContext: context,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }
    
    func isExisting(_ url: URL) -> Result<Bool, Error> {
        let request = BookmarkEntity.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(BookmarkEntity.urlString), url.absoluteString)
        request.predicate = predicate
        do {
            let count = try context.count(for: request)
            return .success(count > 0)
        } catch {
            return .failure(error)
        }
    }
    
    func add(with bookmark: Bookmark) -> Result<Void, Error> {
        let bookmarkEntity = BookmarkEntity(context: context)
        bookmarkEntity.configure(with: bookmark)
        do {
            try context.save()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func update(with bookmark: Bookmark) -> Result<Void, Error> {
        let request = BookmarkEntity.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(BookmarkEntity.urlString), bookmark.url.absoluteString)
        request.predicate = predicate
        do {
            guard let bookmarkEntity = try context.fetch(request).first else { return .success(()) }
            try deleteTags(of: bookmarkEntity)
            bookmarkEntity.update(with: bookmark)
            try context.save()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func update(_ bookmarkEntity: BookmarkEntity) -> Result<Bool, Error> {
        do {
            bookmarkEntity.isFavorite.toggle()
            try context.save()
            return .success(bookmarkEntity.isFavorite)
        } catch {
            return .failure(error)
        }
    }
    
    func delete(_ bookmarkEntity: BookmarkEntity) -> Result<Void, Error> {
        do {
            context.delete(bookmarkEntity)
            try context.save()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func deleteTags(for tag: Tag) {
        let request = BookmarkTagEntity.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(BookmarkTagEntity.name), tag.name)
        request.predicate = predicate
        request.includesPropertyValues = false
        do {
            let bookmarkTagEntities = try context.fetch(request)
            bookmarkTagEntities.forEach { context.delete($0) }
            try context.save()
        } catch {
            return
        }
    }
    
    func clear() {
        clearEntities(with: BookmarkEntity.fetchRequest())
        clearEntities(with: BookmarkTagEntity.fetchRequest())
    }
    
    private func deleteTags(of bookmarkEntity: BookmarkEntity) throws {
        let request = BookmarkTagEntity.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(BookmarkTagEntity.bookmark), bookmarkEntity)
        request.predicate = predicate
        request.includesPropertyValues = false
        let bookmarkTagEntities = try context.fetch(request)
        bookmarkTagEntities.forEach { context.delete($0) }
        try context.save()
    }
    
    private func clearEntities(with fetchRequest: NSFetchRequest<NSFetchRequestResult>) {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs
        let deleteResult = try? context.execute(deleteRequest) as? NSBatchDeleteResult
        guard let objectIDs = deleteResult?.result as? [NSManagedObjectID] else { return }
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: objectIDs], into: [context])
    }
}