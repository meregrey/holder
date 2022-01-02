//
//  BrowseBuilder.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/02.
//

import RIBs

protocol BrowseDependency: Dependency {}

final class BrowseComponent: Component<BrowseDependency> {}

// MARK: - Builder

protocol BrowseBuildable: Buildable {
    func build(withListener listener: BrowseListener) -> BrowseRouting
}

final class BrowseBuilder: Builder<BrowseDependency>, BrowseBuildable {

    override init(dependency: BrowseDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: BrowseListener) -> BrowseRouting {
        let viewController = BrowseViewController()
        let interactor = BrowseInteractor(presenter: viewController)
        interactor.listener = listener
        return BrowseRouter(interactor: interactor, viewController: viewController)
    }
}
