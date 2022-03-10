//
//  BookmarkBrowserInteractor.swift
//  Hook
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
    func displayShareSheet(with metadata: LPLinkMetadata)
    func displayAlert(title: String, message: String?, action: AlertAction?)
}

protocol BookmarkBrowserListener: AnyObject {
    func bookmarkBrowserAddBookmarkButtonDidTap()
    func bookmarkBrowserContextMenuEditDidTap(bookmark: Bookmark)
}

protocol BookmarkBrowserInteractorDependency {
    var tagsStream: ReadOnlyStream<[Tag]> { get }
    var currentTagStream: MutableStream<Tag> { get }
}

final class BookmarkBrowserInteractor: PresentableInteractor<BookmarkBrowserPresentable>, BookmarkBrowserInteractable, BookmarkBrowserPresentableListener, BookmarkListContextMenuListener {
    
    private let bookmarkRepository = BookmarkRepository.shared
    private let dependency: BookmarkBrowserInteractorDependency
    
    private var bookmarkEntityToDelete: BookmarkEntity?
    
    private var tagsStream: ReadOnlyStream<[Tag]> { dependency.tagsStream }
    private var currentTagStream: MutableStream<Tag> { dependency.currentTagStream }
    
    weak var router: BookmarkBrowserRouting?
    weak var listener: BookmarkBrowserListener?
    
    init(presenter: BookmarkBrowserPresentable, dependency: BookmarkBrowserInteractorDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        subscribeTagsStream()
        subscribeCurrentTagStream()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    func indexPathDidChange(indexPath: IndexPath) {
        let currentTag = tagsStream.value[indexPath.item]
        currentTagStream.update(with: currentTag)
    }
    
    func addBookmarkButtonDidTap() {
        listener?.bookmarkBrowserAddBookmarkButtonDidTap()
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
        listener?.bookmarkBrowserContextMenuEditDidTap(bookmark: bookmark)
    }
    
    func contextMenuDeleteDidTap(bookmarkEntity: BookmarkEntity) {
        bookmarkEntityToDelete = bookmarkEntity
        presenter.displayAlert(title: LocalizedString.AlertTitle.deleteBookmark,
                               message: LocalizedString.AlertMessage.deleteBookmark,
                               action: AlertAction(title: LocalizedString.ActionTitle.delete, handler: deleteBookmark))
    }
    
    private func subscribeTagsStream() {
        tagsStream.subscribe(disposedOnDeactivate: self) { [weak self] in
            self?.presenter.update(with: $0)
        }
    }
    
    private func subscribeCurrentTagStream() {
        currentTagStream.subscribe(disposedOnDeactivate: self) { [weak self] in
            guard $0.name.count > 0 else { return }
            self?.presenter.update(with: $0)
        }
    }
    
    @objc
    private func deleteBookmark() {
        guard let bookmarkEntity = bookmarkEntityToDelete else { return }
        let result = bookmarkRepository.delete(bookmarkEntity)
        switch result {
        case .success(()): break
        case .failure(_): NotificationCenter.post(named: NotificationName.Bookmark.didFailToDeleteBookmark)
        }
    }
}
