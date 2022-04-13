//
//  ClearDataBuilder.swift
//  Magboard
//
//  Created by Yeojin Yoon on 2022/04/06.
//

import RIBs

protocol ClearDataDependency: Dependency {}

final class ClearDataComponent: Component<ClearDataDependency> {}

// MARK: - Builder

protocol ClearDataBuildable: Buildable {
    func build(withListener listener: ClearDataListener) -> ClearDataRouting
}

final class ClearDataBuilder: Builder<ClearDataDependency>, ClearDataBuildable {
    
    override init(dependency: ClearDataDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: ClearDataListener) -> ClearDataRouting {
        let viewController = ClearDataViewController()
        let interactor = ClearDataInteractor(presenter: viewController)
        interactor.listener = listener
        return ClearDataRouter(interactor: interactor, viewController: viewController)
    }
}
