//
//  FavoritesBuilder.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/02.
//

import RIBs

protocol FavoritesDependency: Dependency {}

final class FavoritesComponent: Component<FavoritesDependency> {}

// MARK: - Builder

protocol FavoritesBuildable: Buildable {
    func build(withListener listener: FavoritesListener) -> FavoritesRouting
}

final class FavoritesBuilder: Builder<FavoritesDependency>, FavoritesBuildable {

    override init(dependency: FavoritesDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: FavoritesListener) -> FavoritesRouting {
        let viewController = FavoritesViewController()
        let interactor = FavoritesInteractor(presenter: viewController)
        interactor.listener = listener
        return FavoritesRouter(interactor: interactor, viewController: viewController)
    }
}
