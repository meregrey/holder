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
    func attachEnterBookmark(mode: EnterBookmarkMode, forNavigation isForNavigation: Bool)
    func detachEnterBookmark(includingView isViewIncluded: Bool, forNavigation isForNavigation: Bool)
    func attachBookmarkDetail(bookmark: Bookmark)
    func detachBookmarkDetail(includingView isViewIncluded: Bool)
}

protocol BookmarkListener: AnyObject {
    func attachSelectTags(existingSelectedTags: [Tag], forNavigation isForNavigation: Bool)
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
        router?.detachEnterBookmark(includingView: false, forNavigation: false)
    }
    
    // MARK: - BookmarkBrowser
    
    func bookmarkBrowserAddBookmarkButtonDidTap() {
        router?.attachEnterBookmark(mode: .add, forNavigation: false)
    }
    
    func bookmarkBrowserBookmarkDidTap(bookmark: Bookmark) {
        router?.attachBookmarkDetail(bookmark: bookmark)
    }
    
    func bookmarkBrowserContextMenuEditDidTap(bookmark: Bookmark) {
        router?.attachEnterBookmark(mode: .edit(bookmark), forNavigation: false)
    }
    
    // MARK: - EnterBookmark
    
    func enterBookmarkCancelButtonDidTap() {
        router?.detachEnterBookmark(includingView: true, forNavigation: false)
    }
    
    func enterBookmarkBackButtonDidTap() {
        router?.detachEnterBookmark(includingView: true, forNavigation: true)
    }
    
    func enterBookmarkTagCollectionViewDidTap(existingSelectedTags: [Tag], forNavigation isForNavigation: Bool) {
        listener?.attachSelectTags(existingSelectedTags: existingSelectedTags, forNavigation: isForNavigation)
    }
    
    func enterBookmarkSaveButtonDidTap() {
        router?.detachEnterBookmark(includingView: false, forNavigation: false)
    }
    
    func enterBookmarkDidRemove() {
        router?.detachEnterBookmark(includingView: false, forNavigation: true)
    }
    
    // MARK: - BookmarkDetail
    
    func bookmarkDetailBackwardButtonDidTap() {
        router?.detachBookmarkDetail(includingView: true)
    }
    
    func bookmarkDetailEditActionDidTap(bookmark: Bookmark) {
        router?.attachEnterBookmark(mode: .edit(bookmark), forNavigation: true)
    }
    
    func bookmarkDetailDidRequestToDetach() {
        router?.detachBookmarkDetail(includingView: true)
    }
    
    func bookmarkDetailDidRemove() {
        router?.detachBookmarkDetail(includingView: false)
    }
}
