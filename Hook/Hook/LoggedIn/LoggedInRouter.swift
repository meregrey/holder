//
//  LoggedInRouter.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/24.
//

import RIBs

protocol LoggedInInteractable: Interactable, BrowseListener, SearchListener, FavoritesListener, AccountListener {
    var router: LoggedInRouting? { get set }
    var listener: LoggedInListener? { get set }
}

protocol LoggedInViewControllable: ViewControllable {
    func setViewControllers(_ viewControllers: [ViewControllable])
}

final class LoggedInRouter: ViewableRouter<LoggedInInteractable, LoggedInViewControllable>, LoggedInRouting {
    
    private let browse: BrowseBuildable
    private let search: SearchBuildable
    private let favorites: FavoritesBuildable
    private let account: AccountBuildable
    
    init(interactor: LoggedInInteractable,
         viewController: LoggedInViewControllable,
         browse: BrowseBuildable,
         search: SearchBuildable,
         favorites: FavoritesBuildable,
         account: AccountBuildable) {
        self.browse = browse
        self.search = search
        self.favorites = favorites
        self.account = account
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachTabs() {
        let browseRouter = browse.build(withListener: interactor)
        let searchRouter = search.build(withListener: interactor)
        let favoritesRouter = favorites.build(withListener: interactor)
        let accountRouter = account.build(withListener: interactor)
        
        attachChild(browseRouter)
        attachChild(searchRouter)
        attachChild(favoritesRouter)
        attachChild(accountRouter)
        
        let viewControllers = [browseRouter.viewControllable,
                               NavigationController(root: searchRouter.viewControllable),
                               NavigationController(root: favoritesRouter.viewControllable),
                               NavigationController(root: accountRouter.viewControllable)]
        
        viewController.setViewControllers(viewControllers)
    }
}
