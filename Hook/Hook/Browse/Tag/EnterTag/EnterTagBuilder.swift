//
//  EnterTagBuilder.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/12.
//

import RIBs

protocol EnterTagDependency: Dependency {}

final class EnterTagComponent: Component<EnterTagDependency>, EnterTagInteractorDependency {
    
    let mode: EnterTagMode
    
    init(dependency: EnterTagDependency, mode: EnterTagMode) {
        self.mode = mode
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol EnterTagBuildable: Buildable {
    func build(withListener listener: EnterTagListener, mode: EnterTagMode) -> EnterTagRouting
}

final class EnterTagBuilder: Builder<EnterTagDependency>, EnterTagBuildable {
    
    override init(dependency: EnterTagDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: EnterTagListener, mode: EnterTagMode) -> EnterTagRouting {
        let component = EnterTagComponent(dependency: dependency, mode: mode)
        let viewController = EnterTagViewController(mode: mode)
        let interactor = EnterTagInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return EnterTagRouter(interactor: interactor, viewController: viewController)
    }
}
