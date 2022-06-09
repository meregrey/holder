//
//  EnableSharingBuilder.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/06/09.
//

import RIBs

protocol EnableSharingDependency: Dependency {}

final class EnableSharingComponent: Component<EnableSharingDependency> {}

// MARK: - Builder

protocol EnableSharingBuildable: Buildable {
    func build(withListener listener: EnableSharingListener) -> EnableSharingRouting
}

final class EnableSharingBuilder: Builder<EnableSharingDependency>, EnableSharingBuildable {
    
    override init(dependency: EnableSharingDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: EnableSharingListener) -> EnableSharingRouting {
        let viewController = EnableSharingViewController()
        let interactor = EnableSharingInteractor(presenter: viewController)
        interactor.listener = listener
        return EnableSharingRouter(interactor: interactor, viewController: viewController)
    }
}
