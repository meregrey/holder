//
//  RootBuilder.swift
//  Magboard
//
//  Created by Yeojin Yoon on 2021/12/23.
//

import RIBs

protocol RootDependency: Dependency {}

final class RootComponent: Component<RootDependency>, BrowseDependency, SearchDependency, FavoritesDependency, SettingsDependency {}

// MARK: - Builder

protocol RootBuildable: Buildable {
    func build(withListener listener: RootListener) -> LaunchRouting
}

final class RootBuilder: Builder<RootDependency>, RootBuildable {
    
    override init(dependency: RootDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: RootListener) -> LaunchRouting {
        let component = RootComponent(dependency: dependency)
        let viewController = RootViewController()
        let interactor = RootInteractor(presenter: viewController)
        interactor.listener = listener
        let browse = BrowseBuilder(dependency: component)
        let search = SearchBuilder(dependency: component)
        let favorites = FavoritesBuilder(dependency: component)
        let settings = SettingsBuilder(dependency: component)
        return RootRouter(interactor: interactor,
                          viewController: viewController,
                          browse: browse,
                          search: search,
                          favorites: favorites,
                          settings: settings)
    }
}
