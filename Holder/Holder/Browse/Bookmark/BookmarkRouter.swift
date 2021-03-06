//
//  BookmarkRouter.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/01/26.
//

import RIBs

protocol BookmarkInteractable: Interactable, BookmarkBrowserListener, EnterBookmarkListener, BookmarkDetailListener {
    var router: BookmarkRouting? { get set }
    var listener: BookmarkListener? { get set }
    var presentationProxy: AdaptivePresentationControllerDelegateProxy { get }
}

final class BookmarkRouter: Router<BookmarkInteractable>, BookmarkRouting {
    
    private let baseViewController: BrowseViewControllable
    private let bookmarkBrowser: BookmarkBrowserBuildable
    private let enterBookmark: EnterBookmarkBuildable
    private let bookmarkDetail: BookmarkDetailBuildable
    
    private var bookmarkBrowserRouter: BookmarkBrowserRouting?
    private var enterBookmarkRouter: EnterBookmarkRouting?
    private var bookmarkDetailRouter: BookmarkDetailRouting?
    
    init(interactor: BookmarkInteractable,
         baseViewController: BrowseViewControllable,
         bookmarkBrowser: BookmarkBrowserBuildable,
         enterBookmark: EnterBookmarkBuildable,
         bookmarkDetail: BookmarkDetailBuildable) {
        self.baseViewController = baseViewController
        self.bookmarkBrowser = bookmarkBrowser
        self.enterBookmark = enterBookmark
        self.bookmarkDetail = bookmarkDetail
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
    
    func attachEnterBookmark(mode: EnterBookmarkMode, forNavigation isForNavigation: Bool) {
        guard enterBookmarkRouter == nil else { return }
        let router = enterBookmark.build(withListener: interactor, mode: mode, forNavigation: isForNavigation)
        let viewController = router.viewControllable
        enterBookmarkRouter = router
        attachChild(router)
        if isForNavigation {
            baseViewController.push(viewController)
        } else {
            viewController.uiviewController.presentationController?.delegate = interactor.presentationProxy
            baseViewController.present(viewController, modalPresentationStyle: .pageSheet, animated: true)
        }
    }
    
    func detachEnterBookmark(includingView isViewIncluded: Bool, forNavigation isForNavigation: Bool) {
        guard let router = enterBookmarkRouter else { return }
        if isViewIncluded {
            isForNavigation ? baseViewController.pop() : baseViewController.dismiss(animated: true)
        }
        detachChild(router)
        enterBookmarkRouter = nil
    }
    
    // MARK: - BookmarkDetail
    
    func attachBookmarkDetail(bookmark: Bookmark) {
        guard bookmarkDetailRouter == nil else { return }
        let router = bookmarkDetail.build(withListener: interactor, bookmark: bookmark)
        bookmarkDetailRouter = router
        attachChild(router)
        baseViewController.push(router.viewControllable)
    }
    
    func detachBookmarkDetail(includingView isViewIncluded: Bool) {
        guard let router = bookmarkDetailRouter else { return }
        if isViewIncluded { baseViewController.pop() }
        detachChild(router)
        bookmarkDetailRouter = nil
    }
}
