//
//  BookmarkDetailInteractor.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/03/11.
//

import LinkPresentation
import RIBs

protocol BookmarkDetailRouting: ViewableRouting {}

protocol BookmarkDetailPresentable: Presentable {
    var listener: BookmarkDetailPresentableListener? { get set }
    func load(from url: URL)
    func updateToolbar(for isFavorite: Bool)
    func displayShareSheet(with metadata: LPLinkMetadata)
}

protocol BookmarkDetailListener: AnyObject {
    func bookmarkDetailBackwardButtonDidTap()
    func bookmarkDetailEditActionDidTap(bookmark: Bookmark)
    func bookmarkDetailDidRequestToDetach()
    func bookmarkDetailDidRemove()
}

protocol BookmarkDetailInteractorDependency {
    var bookmark: Bookmark { get }
}

final class BookmarkDetailInteractor: PresentableInteractor<BookmarkDetailPresentable>, BookmarkDetailInteractable, BookmarkDetailPresentableListener {
    
    weak var router: BookmarkDetailRouting?
    weak var listener: BookmarkDetailListener?
    
    private let bookmarkRepository = BookmarkRepository.shared
    private let dependency: BookmarkDetailInteractorDependency
    
    private lazy var bookmark = dependency.bookmark
    
    init(presenter: BookmarkDetailPresentable, dependency: BookmarkDetailInteractorDependency) {
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
        loadView()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    func backwardButtonDidTap() {
        listener?.bookmarkDetailBackwardButtonDidTap()
    }
    
    func shareButtonDidTap() {
        LPMetadataProvider().startFetchingMetadata(for: bookmark.url) { metadata, _ in
            guard let metadata = metadata else { return }
            self.presenter.displayShareSheet(with: metadata)
        }
    }
    
    func favoriteButtonDidTap() {
        let result = bookmarkRepository.updateFavorites(for: bookmark.url)
        switch result {
        case .success(let isFavorite): presenter.updateToolbar(for: isFavorite)
        case .failure(_): NotificationCenter.post(named: NotificationName.didFailToProcessData)
        }
    }
    
    func openInSafariActionDidTap() {
        UIApplication.shared.open(bookmark.url)
    }
    
    func editActionDidTap() {
        listener?.bookmarkDetailEditActionDidTap(bookmark: bookmark)
    }
    
    func deleteActionDidTap() {
        let result = bookmarkRepository.delete(for: bookmark.url)
        switch result {
        case .success(_): listener?.bookmarkDetailDidRequestToDetach()
        case .failure(_): NotificationCenter.post(named: NotificationName.didFailToProcessData)
        }
    }
    
    func didRemove() {
        listener?.bookmarkDetailDidRemove()
    }
    
    private func registerToReceiveNotification() {
        NotificationCenter.addObserver(self,
                                       selector: #selector(bookmarkDidUpdate(_:)),
                                       name: NotificationName.Bookmark.didSucceedToUpdate)
    }
    
    @objc
    private func bookmarkDidUpdate(_ notification: Notification) {
        guard let bookmark = notification.userInfo?[Notification.UserInfoKey.bookmark] as? Bookmark else { return }
        self.bookmark = bookmark
    }
    
    private func loadView() {
        presenter.load(from: bookmark.url)
        presenter.updateToolbar(for: bookmark.isFavorite)
    }
}
