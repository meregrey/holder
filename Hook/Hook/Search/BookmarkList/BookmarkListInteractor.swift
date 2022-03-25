//
//  BookmarkListInteractor.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/03/23.
//

import CoreData
import LinkPresentation
import RIBs

protocol BookmarkListRouting: ViewableRouting {}

protocol BookmarkListPresentable: Presentable {
    var listener: BookmarkListPresentableListener? { get set }
    func update(with fetchedResultsController: NSFetchedResultsController<BookmarkEntity>?)
    func displayShareSheet(with metadata: LPLinkMetadata)
    func displayAlert(title: String, message: String?, action: Action?)
}

protocol BookmarkListListener: AnyObject {
    func bookmarkListBookmarkDidTap(bookmarkEntity: BookmarkEntity)
    func bookmarkListContextMenuEditDidTap(bookmark: Bookmark)
}

protocol BookmarkListInteractorDependency {
    var searchTermStream: ReadOnlyStream<String> { get }
}

final class BookmarkListInteractor: PresentableInteractor<BookmarkListPresentable>, BookmarkListInteractable, BookmarkListPresentableListener, BookmarkListCollectionViewListener {
    
    private let bookmarkRepository = BookmarkRepository.shared
    private let dependency: BookmarkListInteractorDependency
    
    private var searchTermStream: ReadOnlyStream<String> { dependency.searchTermStream }
    private var fetchedResultsController: NSFetchedResultsController<BookmarkEntity>?
    private var bookmarkEntityToDelete: BookmarkEntity?
    
    weak var router: BookmarkListRouting?
    weak var listener: BookmarkListListener?
    
    init(presenter: BookmarkListPresentable, dependency: BookmarkListInteractorDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        subscribeSearchTermStream()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    func bookmarkListCollectionViewDidScroll(contentOffset: CGPoint) {}
    
    func bookmarkDidTap(bookmarkEntity: BookmarkEntity) {
        listener?.bookmarkListBookmarkDidTap(bookmarkEntity: bookmarkEntity)
    }
    
    func contextMenuShareDidTap(bookmarkEntity: BookmarkEntity) {
        guard let url = URL(string: bookmarkEntity.urlString) else { return }
        LPMetadataProvider().startFetchingMetadata(for: url) { metadata, _ in
            guard let metadata = metadata else { return }
            self.presenter.displayShareSheet(with: metadata)
        }
    }
    
    func contextMenuCopyURLDidTap(bookmarkEntity: BookmarkEntity) {
        UIPasteboard.general.string = bookmarkEntity.urlString
    }
    
    func contextMenuFavoriteDidTap(bookmarkEntity: BookmarkEntity) {
        let result = bookmarkRepository.update(bookmarkEntity)
        switch result {
        case .success(_): break
        case .failure(_): NotificationCenter.post(named: NotificationName.Bookmark.didFailToUpdateBookmark)
        }
    }
    
    func contextMenuEditDidTap(bookmarkEntity: BookmarkEntity) {
        guard let bookmark = bookmarkEntity.converted() else { return }
        listener?.bookmarkListContextMenuEditDidTap(bookmark: bookmark)
    }
    
    func contextMenuDeleteDidTap(bookmarkEntity: BookmarkEntity) {
        bookmarkEntityToDelete = bookmarkEntity
        presenter.displayAlert(title: LocalizedString.AlertTitle.deleteBookmark,
                               message: LocalizedString.AlertMessage.deleteBookmark,
                               action: Action(title: LocalizedString.ActionTitle.delete, handler: deleteBookmark))
    }
    
    private func subscribeSearchTermStream() {
        searchTermStream.subscribe(disposedOnDeactivate: self) { [weak self] in
            guard $0.count > 0 else { return }
            self?.fetchedResultsController = BookmarkRepository.shared.fetchedResultsController(for: $0)
            try? self?.fetchedResultsController?.performFetch()
            if let fetchedObjects = self?.fetchedResultsController?.fetchedObjects, fetchedObjects.count == 0 {
                NotificationCenter.post(named: NotificationName.Bookmark.noSearchResultsForBookmarks,
                                        userInfo: [NotificationCenter.UserInfoKey.noSearchResultsForBookmarks: $0])
            }
            self?.presenter.update(with: self?.fetchedResultsController)
        }
    }
    
    private func deleteBookmark() {
        guard let bookmarkEntity = bookmarkEntityToDelete else { return }
        let result = bookmarkRepository.delete(bookmarkEntity)
        switch result {
        case .success(()): break
        case .failure(_): NotificationCenter.post(named: NotificationName.Bookmark.didFailToDeleteBookmark)
        }
    }
}
