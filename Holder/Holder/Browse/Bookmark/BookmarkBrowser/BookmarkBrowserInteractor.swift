//
//  BookmarkBrowserInteractor.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/01/27.
//

import LinkPresentation
import RIBs

protocol BookmarkBrowserRouting: ViewableRouting {}

protocol BookmarkBrowserPresentable: Presentable {
    var listener: BookmarkBrowserPresentableListener? { get set }
    func update(with tags: [Tag])
    func update(with currentTag: Tag)
    func displayBlurView(for contentOffset: CGPoint)
    func displayShareSheet(with metadata: LPLinkMetadata)
    func displayAlert(title: String, message: String?, action: Action?)
}

protocol BookmarkBrowserListener: AnyObject {
    func bookmarkBrowserAddBookmarkButtonDidTap()
    func bookmarkBrowserBookmarkDidTap(bookmarkEntity: BookmarkEntity)
    func bookmarkBrowserContextMenuEditDidTap(bookmark: Bookmark)
}

protocol BookmarkBrowserInteractorDependency {
    var currentTagStream: MutableStream<Tag> { get }
}

final class BookmarkBrowserInteractor: PresentableInteractor<BookmarkBrowserPresentable>, BookmarkBrowserInteractable, BookmarkBrowserPresentableListener, BookmarkListCollectionViewListener {
    
    private let bookmarkRepository = BookmarkRepository.shared
    private let dependency: BookmarkBrowserInteractorDependency
    
    private var currentTagStream: MutableStream<Tag> { dependency.currentTagStream }
    private var bookmarkEntityToDelete: BookmarkEntity?
    
    weak var router: BookmarkBrowserRouting?
    weak var listener: BookmarkBrowserListener?
    
    init(presenter: BookmarkBrowserPresentable, dependency: BookmarkBrowserInteractorDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        performFetch()
        subscribeCurrentTagStream()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    func indexPathDidChange(pendingTag: Tag?) {
        let currentTag = pendingTag ?? Tag(name: TagName.all)
        currentTagStream.update(with: currentTag)
    }
    
    func addBookmarkButtonDidTap() {
        listener?.bookmarkBrowserAddBookmarkButtonDidTap()
    }
    
    func bookmarkListCollectionViewDidScroll(contentOffset: CGPoint) {
        presenter.displayBlurView(for: contentOffset)
    }
    
    func bookmarkDidTap(bookmarkEntity: BookmarkEntity) {
        listener?.bookmarkBrowserBookmarkDidTap(bookmarkEntity: bookmarkEntity)
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
        case .failure(_): NotificationCenter.post(named: NotificationName.Bookmark.didFailToUpdateBookmark)
        }
    }
    
    func contextMenuEditDidTap(bookmarkEntity: BookmarkEntity) {
        guard let bookmark = bookmarkEntity.converted() else { return }
        listener?.bookmarkBrowserContextMenuEditDidTap(bookmark: bookmark)
    }
    
    func contextMenuDeleteDidTap(bookmarkEntity: BookmarkEntity) {
        bookmarkEntityToDelete = bookmarkEntity
        presenter.displayAlert(title: LocalizedString.AlertTitle.deleteBookmark,
                               message: LocalizedString.AlertMessage.deleteBookmark,
                               action: Action(title: LocalizedString.ActionTitle.delete, handler: deleteBookmark))
    }
    
    private func performFetch() {
        let fetchedResultsController = TagRepository.shared.fetchedResultsController()
        try? fetchedResultsController.performFetch()
        guard let tagEntities = fetchedResultsController.fetchedObjects else { return }
        let tags = tagEntities.map { Tag(name: $0.name) }
        presenter.update(with: tags)
    }
    
    private func subscribeCurrentTagStream() {
        currentTagStream.subscribe(disposedOnDeactivate: self) { [weak self] in
            guard $0.name.count > 0 else { return }
            self?.presenter.update(with: $0)
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
