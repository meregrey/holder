//
//  SearchRouter.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/01/02.
//

import RIBs

protocol SearchInteractable: Interactable, SearchBarListener, RecentSearchesListener, BookmarkListListener, BookmarkDetailListener, EnterBookmarkListener, SelectTagsListener, SearchTagsListener {
    var router: SearchRouting? { get set }
    var listener: SearchListener? { get set }
    var presentationProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol SearchViewControllable: ViewControllable {
    func addChild(_ viewController: ViewControllable)
    func removeChild(_ viewController: ViewControllable)
    func push(_ viewController: ViewControllable)
    func pop()
    func presentOver(_ viewController: ViewControllable)
    func dismissOver()
}

final class SearchRouter: ViewableRouter<SearchInteractable, SearchViewControllable>, SearchRouting {
    
    private let searchBar: SearchBarBuildable
    private let recentSearches: RecentSearchesBuildable
    private let bookmarkList: BookmarkListBuildable
    private let bookmarkDetail: BookmarkDetailBuildable
    private let enterBookmark: EnterBookmarkBuildable
    private let selectTags: SelectTagsBuildable
    private let searchTags: SearchTagsBuildable
    
    private var searchBarRouter: SearchBarRouting?
    private var recentSearchesRouter: RecentSearchesRouting?
    private var bookmarkListRouter: BookmarkListRouting?
    private var bookmarkDetailRouter: BookmarkDetailRouting?
    private var enterBookmarkRouter: EnterBookmarkRouting?
    private var selectTagsRouter: SelectTagsRouting?
    private var searchTagsRouter: SearchTagsRouting?
    
    init(interactor: SearchInteractable,
         viewController: SearchViewControllable,
         searchBar: SearchBarBuildable,
         recentSearches: RecentSearchesBuildable,
         bookmarkList: BookmarkListBuildable,
         bookmarkDetail: BookmarkDetailBuildable,
         enterBookmark: EnterBookmarkBuildable,
         selectTags: SelectTagsBuildable,
         searchTags: SearchTagsBuildable) {
        self.searchBar = searchBar
        self.recentSearches = recentSearches
        self.bookmarkList = bookmarkList
        self.bookmarkDetail = bookmarkDetail
        self.enterBookmark = enterBookmark
        self.selectTags = selectTags
        self.searchTags = searchTags
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    // MARK: - SearchBar
    
    func attachSearchBar() {
        guard searchBarRouter == nil else { return }
        let router = searchBar.build(withListener: interactor)
        searchBarRouter = router
        attachChild(router)
        viewController.addChild(router.viewControllable)
    }
    
    // MARK: - RecentSearches
    
    func attachRecentSearches() {
        guard recentSearchesRouter == nil else { return }
        let router = recentSearches.build(withListener: interactor)
        recentSearchesRouter = router
        attachChild(router)
        viewController.addChild(router.viewControllable)
    }
    
    func attachRecentSearchesView() {
        guard let router = recentSearchesRouter else { return }
        viewController.addChild(router.viewControllable)
    }
    
    func detachRecentSearchesView() {
        guard let router = recentSearchesRouter else { return }
        viewController.removeChild(router.viewControllable)
    }
    
    // MARK: - BookmarkList
    
    func attachBookmarkList() {
        guard bookmarkListRouter == nil else { return }
        let router = bookmarkList.build(withListener: interactor, forFavorites: false)
        bookmarkListRouter = router
        attachChild(router)
        viewController.addChild(router.viewControllable)
    }
    
    func detachBookmarkList() {
        guard let router = bookmarkListRouter else { return }
        viewController.removeChild(router.viewControllable)
        detachChild(router)
        bookmarkListRouter = nil
    }
    
    // MARK: - BookmarkDetail
    
    func attachBookmarkDetail(bookmark: Bookmark) {
        guard bookmarkDetailRouter == nil else { return }
        let router = bookmarkDetail.build(withListener: interactor, bookmark: bookmark)
        bookmarkDetailRouter = router
        attachChild(router)
        viewController.push(router.viewControllable)
    }
    
    func detachBookmarkDetail(includingView isViewIncluded: Bool) {
        guard let router = bookmarkDetailRouter else { return }
        if isViewIncluded { viewController.pop() }
        detachChild(router)
        bookmarkDetailRouter = nil
    }
    
    // MARK: - EnterBookmark
    
    func attachEnterBookmark(mode: EnterBookmarkMode, forNavigation isForNavigation: Bool) {
        guard enterBookmarkRouter == nil else { return }
        let router = enterBookmark.build(withListener: interactor, mode: mode, forNavigation: isForNavigation)
        enterBookmarkRouter = router
        attachChild(router)
        if isForNavigation {
            viewController.push(router.viewControllable)
        } else {
            router.viewControllable.uiviewController.presentationController?.delegate = interactor.presentationProxy
            viewController.present(router.viewControllable, modalPresentationStyle: .pageSheet, animated: true)
        }
    }
    
    func detachEnterBookmark(includingView isViewIncluded: Bool, forNavigation isForNavigation: Bool) {
        guard let router = enterBookmarkRouter else { return }
        if isViewIncluded {
            isForNavigation ? viewController.pop() : viewController.dismiss(animated: true)
        }
        detachChild(router)
        enterBookmarkRouter = nil
    }
    
    // MARK: - SelectTags
    
    func attachSelectTags(existingSelectedTags: [Tag], forNavigation isForNavigation: Bool) {
        guard selectTagsRouter == nil else { return }
        let router = selectTags.build(withListener: interactor,
                                      existingSelectedTags: existingSelectedTags,
                                      topBarStyle: .sheetHeader,
                                      forNavigation: isForNavigation)
        selectTagsRouter = router
        attachChild(router)
        if isForNavigation {
            viewController.push(router.viewControllable)
        } else {
            viewController.presentOver(router.viewControllable)
        }
    }
    
    func detachSelectTags(includingView isViewIncluded: Bool, forNavigation isForNavigation: Bool) {
        guard let router = selectTagsRouter else { return }
        if isViewIncluded {
            isForNavigation ? viewController.pop() : viewController.dismissOver()
        }
        detachChild(router)
        selectTagsRouter = nil
    }
    
    // MARK: - SearchTags
    
    func attachSearchTags(forNavigation isForNavigation: Bool) {
        guard searchTagsRouter == nil else { return }
        guard let selectTagsRouter = selectTagsRouter else { return }
        let router = searchTags.build(withListener: interactor, forNavigation: isForNavigation)
        searchTagsRouter = router
        attachChild(router)
        if isForNavigation {
            viewController.push(router.viewControllable)
        } else {
            selectTagsRouter.viewControllable.present(router.viewControllable,
                                                      modalPresentationStyle: .currentContext,
                                                      animated: true)
        }
    }
    
    func detachSearchTags(includingView isViewIncluded: Bool, forNavigation isForNavigation: Bool) {
        guard let router = searchTagsRouter else { return }
        if isViewIncluded {
            isForNavigation ? viewController.pop() : router.viewControllable.dismiss(animated: true)
        }
        detachChild(router)
        searchTagsRouter = nil
    }
}
