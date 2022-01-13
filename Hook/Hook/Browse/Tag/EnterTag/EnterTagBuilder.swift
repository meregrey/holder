//
//  EnterTagBuilder.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/12.
//

import RIBs

protocol EnterTagDependency: Dependency {}

final class EnterTagComponent: Component<EnterTagDependency> {}

// MARK: - Builder

protocol EnterTagBuildable: Buildable {
    func build(withListener listener: EnterTagListener) -> EnterTagRouting
}

final class EnterTagBuilder: Builder<EnterTagDependency>, EnterTagBuildable {
    
    override init(dependency: EnterTagDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: EnterTagListener) -> EnterTagRouting {
        let viewController = EnterTagViewController()
        let interactor = EnterTagInteractor(presenter: viewController)
        interactor.listener = listener
        return EnterTagRouter(interactor: interactor, viewController: viewController)
    }
}
