//
//  RootRouter.swift
//  Holder
//
//  Created by Yeojin Yoon on 2021/12/23.
//

import RIBs

protocol RootInteractable: Interactable, BrowseListener, SearchListener, FavoritesListener, SettingsListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    func setViewControllers(_ viewControllers: [ViewControllable])
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {
    
    private let browse: BrowseBuildable
    private let search: SearchBuildable
    private let favorites: FavoritesBuildable
    private let settings: SettingsBuildable
    
    init(interactor: RootInteractable,
         viewController: RootViewControllable,
         browse: BrowseBuildable,
         search: SearchBuildable,
         favorites: FavoritesBuildable,
         settings: SettingsBuildable) {
        self.browse = browse
        self.search = search
        self.favorites = favorites
        self.settings = settings
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachTabs() {
        let browseRouter = browse.build(withListener: interactor)
        let searchRouter = search.build(withListener: interactor)
        let favoritesRouter = favorites.build(withListener: interactor)
        let settingsRouter = settings.build(withListener: interactor)
        
        attachChild(browseRouter)
        attachChild(searchRouter)
        attachChild(favoritesRouter)
        attachChild(settingsRouter)
        
        let viewControllers = [NavigationController(root: browseRouter.viewControllable),
                               NavigationController(root: searchRouter.viewControllable),
                               NavigationController(root: favoritesRouter.viewControllable),
                               NavigationController(root: settingsRouter.viewControllable)]
        
        viewController.setViewControllers(viewControllers)
    }
}
