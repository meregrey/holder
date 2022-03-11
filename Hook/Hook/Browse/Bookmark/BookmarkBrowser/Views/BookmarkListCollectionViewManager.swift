//
//  BookmarkListCollectionViewManager.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/02/22.
//

import CoreData
import UIKit

protocol BookmarkListCollectionViewListener: AnyObject {
    func bookmarkDidTap(bookmarkEntity: BookmarkEntity)
    func contextMenuShareDidTap(bookmarkEntity: BookmarkEntity)
    func contextMenuCopyURLDidTap(bookmarkEntity: BookmarkEntity)
    func contextMenuFavoriteDidTap(bookmarkEntity: BookmarkEntity)
    func contextMenuEditDidTap(bookmarkEntity: BookmarkEntity)
    func contextMenuDeleteDidTap(bookmarkEntity: BookmarkEntity)
}

final class BookmarkListCollectionViewManager: NSObject {
    
    private let bookmarkRepository = BookmarkRepository.shared
    private let fetchedResultsControllerDelegate: FetchedResultsControllerDelegate
    private let bookmarkListContextMenuProvider: BookmarkListContextMenuProvider
    
    private weak var listener: BookmarkListCollectionViewListener?
    private var isForAll = false
    private var fetchedResultsControllerForAll: NSFetchedResultsController<BookmarkEntity>?
    private var fetchedResultsControllerForTag: NSFetchedResultsController<BookmarkTagEntity>?
    
    init(collectionView: UICollectionView, listener: BookmarkListCollectionViewListener?, tag: Tag) {
        self.fetchedResultsControllerDelegate = FetchedResultsControllerDelegate(collectionView: collectionView)
        self.bookmarkListContextMenuProvider = BookmarkListContextMenuProvider(listener: listener)
        self.listener = listener
        super.init()
        if tag.name == TagName.all {
            self.isForAll = true
            self.fetchedResultsControllerForAll = bookmarkRepository.fetchedResultsController()
            self.fetchedResultsControllerForAll?.delegate = fetchedResultsControllerDelegate
            try? self.fetchedResultsControllerForAll?.performFetch()
        } else {
            self.fetchedResultsControllerForTag = bookmarkRepository.fetchedResultsController(for: tag)
            self.fetchedResultsControllerForTag?.delegate = fetchedResultsControllerDelegate
            try? self.fetchedResultsControllerForTag?.performFetch()
        }
    }
    
    private func bookmarkEntity(at indexPath: IndexPath) -> BookmarkEntity? {
        return isForAll ? fetchedResultsControllerForAll?.object(at: indexPath) : fetchedResultsControllerForTag?.object(at: indexPath).bookmark
    }
}

// MARK: - Data Source

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
        listener?.bookmarkDidTap(bookmarkEntity: bookmarkEntity)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let bookmarkEntity = self.bookmarkEntity(at: indexPath)
            return self.bookmarkListContextMenuProvider.menu(for: bookmarkEntity)
        }
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}
