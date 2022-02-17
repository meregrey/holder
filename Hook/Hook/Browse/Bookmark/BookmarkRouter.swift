//
//  BookmarkRouter.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/26.
//

import RIBs

protocol BookmarkInteractable: Interactable, BookmarkBrowserListener, EnterBookmarkListener {
    var router: BookmarkRouting? { get set }
    var listener: BookmarkListener? { get set }
}

final class BookmarkRouter: Router<BookmarkInteractable>, BookmarkRouting {
    
    private let baseViewController: BrowseViewControllable
    private let bookmarkBrowser: BookmarkBrowserBuildable
    private let enterBookmark: EnterBookmarkBuildable
    
    private var bookmarkBrowserRouter: BookmarkBrowserRouting?
    private var enterBookmarkRouter: EnterBookmarkRouting?
    
    init(interactor: BookmarkInteractable,
         baseViewController: BrowseViewControllable,
         bookmarkBrowser: BookmarkBrowserBuildable,
         enterBookmark: EnterBookmarkBuildable) {
        self.baseViewController = baseViewController
        self.bookmarkBrowser = bookmarkBrowser
        self.enterBookmark = enterBookmark
        super.init(interactor: interactor)
        interactor.router = self
    }
    
    func cleanupViews() {}
    
    // MARK: - BookmarkBrowser
    
    func attachBookmarkBrowser() {
        guard bookmarkBrowserRouter == nil else { return }
        let router = bookmarkBrowser.build(withListener: interactor)
        bookmarkBrowserRouter = router
        attachChild(router)
        baseViewController.addChild(router.viewControllable)
    }
    
    // MARK: - EnterBookmark
    
    func attachEnterBookmark() {
        guard enterBookmarkRouter == nil else { return }
        let router = enterBookmark.build(withListener: interactor)
        enterBookmarkRouter = router
        attachChild(router)
        baseViewController.present(router.viewControllable, modalPresentationStyle: .pageSheet, animated: true)
    }
    
    func detachEnterBookmark() {
        guard let router = self.enterBookmarkRouter else { return }
        baseViewController.dismiss(animated: true)
        detachChild(router)
        enterBookmarkRouter = nil
    }
}
