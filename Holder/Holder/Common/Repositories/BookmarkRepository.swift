//
//  BookmarkRepository.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/03/05.
//

import CoreData

protocol BookmarkRepositoryType {
    func fetchedResultsController(isFavorite: Bool) -> NSFetchedResultsController<BookmarkEntity>
    func fetchedResultsController(for tag: Tag) -> NSFetchedResultsController<BookmarkTagEntity>
    func fetchedResultsController(for searchTerm: String, isFavorite: Bool) -> NSFetchedResultsController<BookmarkEntity>
    func isExisting(_ url: URL) -> Result<Bool, Error>
    func add(bookmark: Bookmark) -> Result<Void, Error>
    func update(bookmark: Bookmark) -> Result<Void, Error>
    func updateFavorites(for url: URL) -> Result<Bool, Error>
    func updateTags(_ tag: Tag, to newTag: Tag) -> Result<Void, Error>
    func delete(for url: URL) -> Result<Void, Error>
    func deleteTags(for tag: Tag)
    func clear()
}

final class BookmarkRepository: BookmarkRepositoryType {
    
    static let shared = BookmarkRepository()
    
    private var context: NSManagedObjectContext { PersistentContainer.shared.context }
    
    private var ascending: Bool {
        let sort = UserDefaults.value(forType: Sort.self) ?? .newestToOldest
        return sort == .newestToOldest ? false : true
    }
    
    private init() {}
    
    func fetchedResultsController(isFavorite: Bool = false) -> NSFetchedResultsController<BookmarkEntity> {
        let request = BookmarkEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(BookmarkEntity.creationDate), ascending: ascending)
        request.sortDescriptors = [sortDescriptor]
        
        if isFavorite {
            let predicate = NSPredicate(format: "%K == YES", #keyPath(BookmarkEntity.isFavorite))
            request.predicate = predicate
        }
        
        return NSFetchedResultsController(fetchRequest: request,
                                          managedObjectContext: context,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }
    
    func fetchedResultsController(for tag: Tag) -> NSFetchedResultsController<BookmarkTagEntity> {
        let request = BookmarkTagEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(BookmarkTagEntity.bookmark.creationDate), ascending: ascending)
        let predicate = NSPredicate(format: "%K == %@", #keyPath(BookmarkTagEntity.name), tag.name)
        request.sortDescriptors = [sortDescriptor]
        request.predicate = predicate
        return NSFetchedResultsController(fetchRequest: request,
                                          managedObjectContext: context,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }
    
    func fetchedResultsController(for searchTerm: String, isFavorite: Bool = false) -> NSFetchedResultsController<BookmarkEntity> {
        let request = BookmarkEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(BookmarkEntity.creationDate), ascending: ascending)
        let titlePredicate = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(BookmarkEntity.title), searchTerm)
        let urlPredicate = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(BookmarkEntity.urlString), searchTerm)
        let notePredicate = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(BookmarkEntity.note), searchTerm)
        var predicates = NSCompoundPredicate(type: .or, subpredicates: [titlePredicate, urlPredicate, notePredicate])
        
        if isFavorite {
            let isFavoritePredicate = NSPredicate(format: "%K == YES", #keyPath(BookmarkEntity.isFavorite))
            predicates = NSCompoundPredicate(type: .and, subpredicates: [predicates, isFavoritePredicate])
        }
        
        request.sortDescriptors = [sortDescriptor]
        request.predicate = predicates
        
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
    
    func add(bookmark: Bookmark) -> Result<Void, Error> {
        let bookmarkEntity = BookmarkEntity(context: context)
        bookmarkEntity.configure(with: bookmark)
        do {
            try context.save()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func update(bookmark: Bookmark) -> Result<Void, Error> {
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
    
    func updateFavorites(for url: URL) -> Result<Bool, Error> {
        let request = BookmarkEntity.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(BookmarkEntity.urlString), url.absoluteString)
        request.predicate = predicate
        do {
            guard let bookmarkEntity = try context.fetch(request).first else { return .success(false) }
            bookmarkEntity.isFavorite.toggle()
            try context.save()
            return .success(bookmarkEntity.isFavorite)
        } catch {
            return .failure(error)
        }
    }
    
    func updateTags(_ tag: Tag, to newTag: Tag) -> Result<Void, Error> {
        let request = BookmarkTagEntity.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(BookmarkTagEntity.name), tag.name)
        request.predicate = predicate
        do {
            let bookmarkTagEntities = try context.fetch(request)
            if bookmarkTagEntities.count == 0 { return .success(()) }
            bookmarkTagEntities.forEach { $0.name = newTag.name }
            try context.save()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func delete(for url: URL) -> Result<Void, Error> {
        let request = BookmarkEntity.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(BookmarkEntity.urlString), url.absoluteString)
        request.predicate = predicate
        request.includesPropertyValues = false
        do {
            guard let bookmarkEntity = try context.fetch(request).first else { return .success(()) }
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
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = BookmarkEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        guard let _ = try? context.execute(deleteRequest) else {
            NotificationCenter.post(named: NotificationName.didFailToProcessData)
            return
        }
        NotificationCenter.post(named: NotificationName.Store.didSucceedToClear)
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
}
