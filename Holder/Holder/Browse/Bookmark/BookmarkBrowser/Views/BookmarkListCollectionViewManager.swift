//
//  BookmarkListCollectionViewManager.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/02/22.
//

import CoreData
import UIKit

protocol BookmarkListCollectionViewListener: AnyObject {
    func bookmarkListCollectionViewDidScroll(contentOffset: CGPoint)
    func bookmarkDidTap(bookmark: Bookmark)
    func contextMenuShareDidTap(bookmark: Bookmark)
    func contextMenuCopyLinkDidTap(bookmark: Bookmark)
    func contextMenuFavoriteDidTap(bookmark: Bookmark)
    func contextMenuEditDidTap(bookmark: Bookmark)
    func contextMenuDeleteDidTap(bookmark: Bookmark)
}

final class BookmarkListCollectionViewManager: NSObject {
    
    private let bookmarkRepository = BookmarkRepository.shared
    private let bookmarkListContextMenuProvider: BookmarkListContextMenuProvider
    private let tag: Tag?
    
    private weak var collectionView: BookmarkListCollectionView?
    private weak var listener: BookmarkListCollectionViewListener?
    
    private var fetchedResultsControllerForAll: NSFetchedResultsController<BookmarkEntity>?
    private var fetchedResultsControllerForTag: NSFetchedResultsController<BookmarkTagEntity>?
    
    init(collectionView: BookmarkListCollectionView, listener: BookmarkListCollectionViewListener?, tag: Tag?) {
        self.bookmarkListContextMenuProvider = BookmarkListContextMenuProvider(listener: listener)
        self.tag = tag
        self.collectionView = collectionView
        self.listener = listener
        super.init()
        registerToReceiveNotification()
        configureFetchedResultsController()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func registerToReceiveNotification() {
        NotificationCenter.addObserver(self,
                                       selector: #selector(contextObjectsDidChange),
                                       name: .NSManagedObjectContextObjectsDidChange,
                                       object: PersistentContainer.shared.backgroundContext)
        
        NotificationCenter.addObserver(self,
                                       selector: #selector(sortDidChange),
                                       name: NotificationName.Bookmark.sortDidChange)
        
        NotificationCenter.addObserver(self,
                                       selector: #selector(storeDidClear),
                                       name: NotificationName.Store.didSucceedToClear)
        
        NotificationCenter.addObserver(self,
                                       selector: #selector(lastShareDateDidChange),
                                       name: NotificationName.lastShareDateDidChange)
    }
    
    @objc
    private func contextObjectsDidChange() {
        guard let _ = fetchedResultsControllerForTag else { return }
        configureFetchedResultsController()
        collectionView?.reloadData()
    }
    
    @objc
    private func sortDidChange() {
        configureFetchedResultsController()
        collectionView?.reloadData()
    }
    
    @objc
    private func storeDidClear() {
        configureFetchedResultsController()
        collectionView?.reloadData()
    }
    
    @objc
    private func lastShareDateDidChange() {
        configureFetchedResultsController()
        collectionView?.reloadData()
    }
    
    private func configureFetchedResultsController() {
        if let tag = tag {
            configureFetchedResultsControllerForTag(with: tag)
        } else {
            configureFetchedResultsControllerForAll()
        }
    }
    
    private func configureFetchedResultsControllerForAll() {
        fetchedResultsControllerForAll = bookmarkRepository.fetchedResultsController()
        fetchedResultsControllerForAll?.delegate = self
        try? fetchedResultsControllerForAll?.performFetch()
    }
    
    private func configureFetchedResultsControllerForTag(with tag: Tag) {
        fetchedResultsControllerForTag = bookmarkRepository.fetchedResultsController(for: tag)
        fetchedResultsControllerForTag?.delegate = self
        try? fetchedResultsControllerForTag?.performFetch()
    }
    
    private func bookmarkEntity(at indexPath: IndexPath) -> BookmarkEntity? {
        return tag == nil ? fetchedResultsControllerForAll?.object(at: indexPath) : fetchedResultsControllerForTag?.object(at: indexPath).bookmark
    }
}

// MARK: - Fetched Results Controller Delegate

extension BookmarkListCollectionViewManager: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            DispatchQueue.main.async {
                guard let newIndexPath = newIndexPath else { return }
                self.collectionView?.insertItems(at: [newIndexPath])
            }
        case .update:
            DispatchQueue.main.async {
                guard let indexPath = indexPath else { return }
                self.collectionView?.reloadItems(at: [indexPath])
            }
        case .delete:
            DispatchQueue.main.async {
                guard let indexPath = indexPath else { return }
                self.collectionView?.deleteItems(at: [indexPath])
            }
        default: break
        }
    }
}

// MARK: - Data Source

extension BookmarkListCollectionViewManager: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if tag == nil {
            guard let fetchedObjects = fetchedResultsControllerForAll?.fetchedObjects else { return 0 }
            return fetchedObjects.count
        } else {
            guard let fetchedObjects = fetchedResultsControllerForTag?.fetchedObjects else { return 0 }
            return fetchedObjects.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BookmarkListCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        guard let bookmarkEntity = bookmarkEntity(at: indexPath) else { return cell }
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

// MARK: - Prefetching

extension BookmarkListCollectionViewManager: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
            guard let bookmarkEntity = bookmarkEntity(at: $0) else { return }
            guard let url = URL(string: bookmarkEntity.urlString) else { return }
            ThumbnailLoader.shared.loadThumbnail(for: url) { _ in }
        }
    }
}

// MARK: - Delegate

extension BookmarkListCollectionViewManager: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let bookmarkEntity = bookmarkEntity(at: indexPath) else { return }
        guard let bookmark = bookmarkEntity.converted() else { return }
        listener?.bookmarkDidTap(bookmark: bookmark)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let bookmarkEntity = self.bookmarkEntity(at: indexPath)
            let bookmark = bookmarkEntity?.converted()
            return self.bookmarkListContextMenuProvider.menu(for: bookmark)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        listener?.bookmarkListCollectionViewDidScroll(contentOffset: collectionView.contentOffset)
    }
}

// MARK: - Layout

extension BookmarkListCollectionViewManager: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let defaultHeight = CGFloat(84)
        let defaultSize = CGSize(width: collectionView.frame.width - 40, height: defaultHeight)
        guard let bookmarkEntity = bookmarkEntity(at: indexPath) else { return defaultSize }
        let fittingSize = BookmarkListCollectionViewCell.fittingSize(with: bookmarkEntity, width: defaultSize.width)
        return fittingSize.height > defaultHeight ? fittingSize : defaultSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: Size.tagBarHeight + 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}
