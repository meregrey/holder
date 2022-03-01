//
//  BookmarkInteractor.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/26.
//

import RIBs

protocol BookmarkRouting: Routing {
    func cleanupViews()
    func attachBookmarkBrowser()
    func attachEnterBookmark()
    func detachEnterBookmark(includingView isViewIncluded: Bool)
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
        router?.attachEnterBookmark()
    }
    
    // MARK: - EnterBookmark
    
    func enterBookmarkCloseButtonDidTap() {
        router?.detachEnterBookmark(includingView: true)
    }
    
    func enterBookmarkTagCollectionViewDidTap(existingSelectedTags: [Tag]) {
        listener?.attachSelectTags(existingSelectedTags: existingSelectedTags)
    }
    
    func enterBookmarkSaveButtonDidTap() {
        router?.detachEnterBookmark(includingView: false)
    }
}
