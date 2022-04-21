//
//  BookmarkInteractor.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/01/26.
//

import RIBs

protocol BookmarkRouting: Routing {
    func cleanupViews()
    func attachBookmarkBrowser()
    func attachEnterBookmark(mode: EnterBookmarkMode)
    func detachEnterBookmark(includingView isViewIncluded: Bool)
    func attachBookmarkDetail(bookmarkEntity: BookmarkEntity)
    func detachBookmarkDetail(includingView isViewIncluded: Bool)
}

protocol BookmarkListener: AnyObject {
    func attachSelectTags(existingSelectedTags: [Tag])
}

final class BookmarkInteractor: Interactor, BookmarkInteractable, AdaptivePresentationControllerDelegate {
    
    let presentationProxy = AdaptivePresentationControllerDelegateProxy()
    
    weak var router: BookmarkRouting?
    weak var listener: BookmarkListener?
    
    override init() {
        super.init()
        self.presentationProxy.delegate = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        router?.attachBookmarkBrowser()
    }
    
    override func willResignActive() {
        super.willResignActive()
        router?.cleanupViews()
    }
    
    func presentationControllerDidDismiss() {
        router?.detachEnterBookmark(includingView: false)
    }
    
    // MARK: - BookmarkBrowser
    
    func bookmarkBrowserAddBookmarkButtonDidTap() {
        router?.attachEnterBookmark(mode: .add)
    }
    
    func bookmarkBrowserBookmarkDidTap(bookmarkEntity: BookmarkEntity) {
        router?.attachBookmarkDetail(bookmarkEntity: bookmarkEntity)
    }
    
    func bookmarkBrowserContextMenuEditDidTap(bookmark: Bookmark) {
        router?.attachEnterBookmark(mode: .edit(bookmark: bookmark))
    }
    
    // MARK: - EnterBookmark
    
    func enterBookmarkCancelButtonDidTap() {
        router?.detachEnterBookmark(includingView: true)
    }
    
    func enterBookmarkTagCollectionViewDidTap(existingSelectedTags: [Tag]) {
        listener?.attachSelectTags(existingSelectedTags: existingSelectedTags)
    }
    
    func enterBookmarkSaveButtonDidTap() {
        router?.detachEnterBookmark(includingView: false)
    }
    
    // MARK: - BookmarkDetail
    
    func bookmarkDetailDidRemove() {
        router?.detachBookmarkDetail(includingView: false)
    }
    
    func bookmarkDetailBackwardButtonDidTap() {
        router?.detachBookmarkDetail(includingView: true)
    }
    
    func bookmarkDetailEditActionDidTap(bookmark: Bookmark) {
        router?.attachEnterBookmark(mode: .edit(bookmark: bookmark))
    }
    
    func bookmarkDetailDidRequestToDetach() {
        router?.detachBookmarkDetail(includingView: true)
    }
}