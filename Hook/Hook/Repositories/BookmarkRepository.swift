//
//  BookmarkRepository.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/03/05.
//

import CoreData

protocol BookmarkRepositoryType {
    func fetchedResultsController() -> NSFetchedResultsController<BookmarkEntity>
    func fetchedResultsController(for tag: Tag) -> NSFetchedResultsController<BookmarkTagEntity>
    func isExisting(_ url: URL) -> Result<Bool, Error>
    func add(_ bookmark: Bookmark) -> Result<Void, Error>
}

final class BookmarkRepository: BookmarkRepositoryType {
    
    static let shared = BookmarkRepository()
    
    private var context: NSManagedObjectContext { PersistentContainer.shared.context }
    
    private init() {}
    
    func fetchedResultsController() -> NSFetchedResultsController<BookmarkEntity> {
        let request = BookmarkEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(BookmarkEntity.creationDate), ascending: false)
        request.sortDescriptors = [sortDescriptor]
        return NSFetchedResultsController(fetchRequest: request,
                                          managedObjectContext: context,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }
    
    func fetchedResultsController(for tag: Tag) -> NSFetchedResultsController<BookmarkTagEntity> {
        let request = BookmarkTagEntity.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(BookmarkTagEntity.name), tag.name)
        let sortDescriptor = NSSortDescriptor(key: #keyPath(BookmarkTagEntity.bookmark.creationDate), ascending: false)
        request.predicate = predicate
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
    
    func add(_ bookmark: Bookmark) -> Result<Void, Error> {
        let bookmarkEntity = BookmarkEntity(context: context)
        bookmarkEntity.configure(with: bookmark)
        do {
            try context.save()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func update(_ bookmark: Bookmark) -> Result<Void, Error> {
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
    
    func delete(_ bookmarkEntity: BookmarkEntity) -> Result<Void, Error> {
        do {
            context.delete(bookmarkEntity)
            try context.save()
            return .success(())
        } catch {
            return .failure(error)
        }
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
