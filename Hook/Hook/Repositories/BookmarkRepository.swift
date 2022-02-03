//
//  BookmarkRepository.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/23.
//

import Foundation

protocol BookmarkRepositoryType {
    var bookmarksStream: ReadOnlyStream<[Tag: [Bookmark]]> { get }
    func add(bookmark: Bookmark)
}

final class BookmarkRepository: BookmarkRepositoryType {
    
    private let mutableBookmarksStream = MutableStream<[Tag: [Bookmark]]>(initialValue: [:])
    private let persistentContainer: PersistentContainerType
    
    var bookmarksStream: ReadOnlyStream<[Tag : [Bookmark]]> { mutableBookmarksStream }
    
    init(persistentContainer: PersistentContainerType = PersistentContainer()) {
        self.persistentContainer = persistentContainer
    }
    
    func add(bookmark: Bookmark) {
        if isExisting(bookmark) {
            postNotification(ofName: NotificationName.Bookmark.existingBookmark)
            return
        }
        persistentContainer.performBackgroundTask(with: NotificationName.Bookmark.didFailToAddBookmark) { [weak self] context in
            let bookmarkEntity = BookmarkEntity(context: context)
            bookmarkEntity.configure(with: bookmark)
            try context.save()
            self?.mutableBookmarksStream.update(with: bookmark)
            self?.postNotification(ofName: NotificationName.Bookmark.didSucceedToAddBookmark)
        }
    }
    
    private func isExisting(_ bookmark: Bookmark) -> Bool {
        guard let bookmarks = bookmarksStream.value[Tag(name: TagName.all)] else { return false }
        return bookmarks.contains(bookmark)
    }
    
    private func postNotification(ofName name: NSNotification.Name, object: Any? = nil) {
        NotificationCenter.default.post(name: name, object: object)
    }
}
