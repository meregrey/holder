//
//  BookmarkListCollectionViewManager.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/02/22.
//

import CoreData
import UIKit

final class BookmarkListCollectionViewManager: NSObject {
    
    private let fetchedResultsControllerDelegate: FetchedResultsControllerDelegate

    private var isForAll = false
    private var fetchedResultsControllerForAll: NSFetchedResultsController<BookmarkEntity>?
    private var fetchedResultsControllerForTag: NSFetchedResultsController<BookmarkTagEntity>?

    init(collectionView: UICollectionView, tag: Tag, context: NSManagedObjectContext) {
        self.fetchedResultsControllerDelegate = FetchedResultsControllerDelegate(collectionView: collectionView)
        super.init()
        if tag.name == TagName.all {
            self.isForAll = true
            self.fetchedResultsControllerForAll = fetchedResultsControllerForAll(context: context)
            self.fetchedResultsControllerForAll?.delegate = fetchedResultsControllerDelegate
            try? self.fetchedResultsControllerForAll?.performFetch()
        } else {
            self.fetchedResultsControllerForTag = fetchedResultsControllerForTag(tag: tag, context: context)
            self.fetchedResultsControllerForTag?.delegate = fetchedResultsControllerDelegate
            try? self.fetchedResultsControllerForTag?.performFetch()
        }
    }
    
    private func fetchedResultsControllerForAll(context: NSManagedObjectContext) -> NSFetchedResultsController<BookmarkEntity> {
        let request = BookmarkEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(BookmarkEntity.creationDate), ascending: false)
        request.sortDescriptors = [sortDescriptor]
        return NSFetchedResultsController(fetchRequest: request,
                                          managedObjectContext: context,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }
    
    private func fetchedResultsControllerForTag(tag: Tag, context: NSManagedObjectContext) -> NSFetchedResultsController<BookmarkTagEntity> {
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
}

extension BookmarkListCollectionViewManager: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isForAll {
            guard let fetchedObjects = fetchedResultsControllerForAll?.fetchedObjects else { return 0 }
            return fetchedObjects.count
        } else {
            guard let fetchedObjects = fetchedResultsControllerForTag?.fetchedObjects else { return 0 }
            return fetchedObjects.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BookmarkListCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        guard let bookmarkEntity = isForAll ? fetchedResultsControllerForAll?.object(at: indexPath) : fetchedResultsControllerForTag?.object(at: indexPath).bookmark else { return cell }
        let viewModel = BookmarkViewModel(with: bookmarkEntity)
        cell.configure(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                               withReuseIdentifier: String(describing: UICollectionReusableView.self),
                                                               for: indexPath)
    }
}

extension BookmarkListCollectionViewManager: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
            guard let bookmarkEntity = isForAll ? fetchedResultsControllerForAll?.object(at: $0) : fetchedResultsControllerForTag?.object(at: $0).bookmark else { return }
            guard let url = URL(string: bookmarkEntity.urlString) else { return }
            ThumbnailLoader.shared.loadThumbnail(for: url) { _ in }
        }
    }
}

extension BookmarkListCollectionViewManager: UICollectionViewDelegate {}

extension BookmarkListCollectionViewManager: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let defaultHeight = CGFloat(84)
        let defaultSize = CGSize(width: collectionView.frame.width - 40, height: defaultHeight)
        guard let bookmarkEntity = isForAll ? fetchedResultsControllerForAll?.object(at: indexPath) : fetchedResultsControllerForTag?.object(at: indexPath).bookmark else { return defaultSize }
        let fittingSize = BookmarkListCollectionViewCell.fittingSize(with: bookmarkEntity, width: defaultSize.width)
        return fittingSize.height > defaultHeight ? fittingSize : defaultSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}
