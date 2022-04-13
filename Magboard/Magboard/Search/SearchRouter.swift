//
//  SearchRouter.swift
//  Magboard
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
    func addChild(_ viewControllable: ViewControllable)
    func removeChild(_ viewControllable: ViewControllable)
    func push(_ viewControllable: ViewControllable)
    func pop()
    func presentOver(_ viewControllable: ViewControllable)
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
    
    func attachBookmarkDetail(bookmarkEntity: BookmarkEntity) {
        guard bookmarkDetailRouter == nil else { return }
        let router = bookmarkDetail.build(withListener: interactor, bookmarkEntity: bookmarkEntity)
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
    
    func attachEnterBookmark(mode: EnterBookmarkMode) {
        guard enterBookmarkRouter == nil else { return }
        let router = enterBookmark.build(withListener: interactor, mode: mode)
        enterBookmarkRouter = router
        attachChild(router)
        router.viewControllable.uiviewController.presentationController?.delegate = interactor.presentationProxy
        viewController.present(router.viewControllable, modalPresentationStyle: .pageSheet, animated: true)
    }
    
    func detachEnterBookmark(includingView isViewIncluded: Bool) {
        guard let router = enterBookmarkRouter else { return }
        if isViewIncluded { viewController.dismiss(animated: true) }
        detachChild(router)
        enterBookmarkRouter = nil
    }
    
    // MARK: - SelectTags
    
    func attachSelectTags(existingSelectedTags: [Tag]) {
        guard selectTagsRouter == nil else { return }
        let router = selectTags.build(withListener: interactor, existingSelectedTags: existingSelectedTags)
        selectTagsRouter = router
        attachChild(router)
        viewController.presentOver(router.viewControllable)
    }
    
    func detachSelectTags() {
        guard let router = selectTagsRouter else { return }
        viewController.dismissOver()
        detachChild(router)
        selectTagsRouter = nil
    }
    
    // MARK: - SearchTags
    
    func attachSearchTags() {
        guard searchTagsRouter == nil else { return }
        guard let selectTagsRouter = selectTagsRouter else { return }
        let router = searchTags.build(withListener: interactor)
        searchTagsRouter = router
        attachChild(router)
        selectTagsRouter.viewControllable.present(router.viewControllable,
                                                  modalPresentationStyle: .currentContext,
                                                  animated: true)
    }
    
    func detachSearchTags() {
        guard let router = searchTagsRouter else { return }
        router.viewControllable.dismiss(animated: true)
        detachChild(router)
        searchTagsRouter = nil
    }
}
