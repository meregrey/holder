//
//  FavoritesRouter.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/02.
//

import RIBs

protocol FavoritesInteractable: Interactable, SearchBarListener, BookmarkListListener {
    var router: FavoritesRouting? { get set }
    var listener: FavoritesListener? { get set }
}

protocol FavoritesViewControllable: ViewControllable {
    func addChild(_ viewControllable: ViewControllable)
}

final class FavoritesRouter: ViewableRouter<FavoritesInteractable, FavoritesViewControllable>, FavoritesRouting {
    
    private let searchBar: SearchBarBuildable
    private let bookmarkList: BookmarkListBuildable
    
    private var searchBarRouter: SearchBarRouting?
    private var bookmarkListRouter: BookmarkListRouting?
    
    init(interactor: FavoritesInteractable,
         viewController: FavoritesViewControllable,
         searchBar: SearchBarBuildable,
         bookmarkList: BookmarkListBuildable) {
        self.searchBar = searchBar
        self.bookmarkList = bookmarkList
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachSearchBar() {
        guard searchBarRouter == nil else { return }
        let router = searchBar.build(withListener: interactor)
        searchBarRouter = router
        attachChild(router)
        viewController.addChild(router.viewControllable)
    }
    
    func attachBookmarkList() {
        guard bookmarkListRouter == nil else { return }
        let router = bookmarkList.build(withListener: interactor, forFavorites: true)
        bookmarkListRouter = router
        attachChild(router)
        viewController.addChild(router.viewControllable)
    }
}
