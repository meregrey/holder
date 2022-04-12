//
//  AppearanceBuilder.swift
//  Magboard
//
//  Created by Yeojin Yoon on 2022/04/04.
//

import RIBs

protocol AppearanceDependency: Dependency {}

final class AppearanceComponent: Component<AppearanceDependency> {}

// MARK: - Builder

protocol AppearanceBuildable: Buildable {
    func build(withListener listener: AppearanceListener) -> AppearanceRouting
}

final class AppearanceBuilder: Builder<AppearanceDependency>, AppearanceBuildable {
    
    override init(dependency: AppearanceDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: AppearanceListener) -> AppearanceRouting {
        let viewController = AppearanceViewController()
        let interactor = AppearanceInteractor(presenter: viewController)
        interactor.listener = listener
        return AppearanceRouter(interactor: interactor, viewController: viewController)
    }
}
