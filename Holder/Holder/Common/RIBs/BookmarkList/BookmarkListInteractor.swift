//
//  BookmarkListInteractor.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/03/23.
//

import CoreData
import LinkPresentation
import RIBs

protocol BookmarkListRouting: ViewableRouting {}

protocol BookmarkListPresentable: Presentable {
    var listener: BookmarkListPresentableListener? { get set }
    func update(fetchedResultsController: NSFetchedResultsController<BookmarkEntity>?, searchTerm: String)
    func displayShareSheet(with metadata: LPLinkMetadata)
    func displayAlert(title: String, message: String?, action: Action?)
}

protocol BookmarkListListener: AnyObject {
    func bookmarkListBookmarkDidTap(bookmarkEntity: BookmarkEntity)
    func bookmarkListContextMenuEditDidTap(bookmark: Bookmark)
}

protocol BookmarkListInteractorDependency {
    var searchTermStream: ReadOnlyStream<String> { get }
    var isForFavorites: Bool { get }
}

final class BookmarkListInteractor: PresentableInteractor<BookmarkListPresentable>, BookmarkListInteractable, BookmarkListPresentableListener, BookmarkListCollectionViewListener {
    
    weak var router: BookmarkListRouting?
    weak var listener: BookmarkListListener?
    
    private let bookmarkRepository = BookmarkRepository.shared
    private let dependency: BookmarkListInteractorDependency
    
    private var searchTermStream: ReadOnlyStream<String> { dependency.searchTermStream }
    private var isForFavorites: Bool { dependency.isForFavorites }
    private var fetchedResultsController: NSFetchedResultsController<BookmarkEntity>?
    private var bookmarkEntityToDelete: BookmarkEntity?
    
    init(presenter: BookmarkListPresentable, dependency: BookmarkListInteractorDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        registerToReceiveNotification()
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
    
    func contextMenuCopyLinkDidTap(bookmarkEntity: BookmarkEntity) {
        UIPasteboard.general.string = bookmarkEntity.urlString
    }
    
    func contextMenuFavoriteDidTap(bookmarkEntity: BookmarkEntity) {
        let result = bookmarkRepository.update(bookmarkEntity)
        switch result {
        case .success(_): break
        case .failure(_): NotificationCenter.post(named: NotificationName.didFailToProcessData)
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
    
    private func registerToReceiveNotification() {
        NotificationCenter.addObserver(self,
                                       selector: #selector(contextObjectsDidChange),
                                       name: .NSManagedObjectContextObjectsDidChange,
                                       object: BookmarkRepository.shared.context)
        
        NotificationCenter.addObserver(self,
                                       selector: #selector(sortDidChange),
                                       name: NotificationName.Bookmark.sortDidChange)
    }
    
    @objc
    private func contextObjectsDidChange() {
        fetch(for: searchTermStream.value)
    }
    
    @objc
    private func sortDidChange() {
        fetch(for: searchTermStream.value)
    }
    
    private func subscribeSearchTermStream() {
        searchTermStream.subscribe(disposedOnDeactivate: self) { [weak self] in
            self?.fetch(for: $0)
        }
    }
    
    private func fetch(for searchTerm: String) {
        fetchedResultsController = searchTerm.count > 0 ? fetchedResultsController(for: searchTerm) : fetchedResultsControllerForFavorites()
        try? fetchedResultsController?.performFetch()
        if let fetchedObjects = fetchedResultsController?.fetchedObjects, fetchedObjects.count == 0 {
            NotificationCenter.post(named: NotificationName.Bookmark.noSearchResults,
                                    userInfo: [NotificationCenter.UserInfoKey.searchTerm: searchTerm])
        }
        presenter.update(fetchedResultsController: fetchedResultsController, searchTerm: searchTerm)
    }
    
    private func fetchedResultsController(for searchTerm: String) -> NSFetchedResultsController<BookmarkEntity> {
        return bookmarkRepository.fetchedResultsController(for: searchTerm, isFavorite: isForFavorites)
    }
    
    private func fetchedResultsControllerForFavorites() -> NSFetchedResultsController<BookmarkEntity> {
        return bookmarkRepository.fetchedResultsController(isFavorite: true)
    }
    
    private func deleteBookmark() {
        guard let bookmarkEntity = bookmarkEntityToDelete else { return }
        let result = bookmarkRepository.delete(bookmarkEntity)
        switch result {
        case .success(()): break
        case .failure(_): NotificationCenter.post(named: NotificationName.didFailToProcessData)
        }
    }
}
