//
//  VersionBuilder.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/06/08.
//

import RIBs

protocol VersionDependency: Dependency {}

final class VersionComponent: Component<VersionDependency> {}

// MARK: - Builder

protocol VersionBuildable: Buildable {
    func build(withListener listener: VersionListener, isLatestVersion: Bool, currentVersion: String) -> VersionRouting
}

final class VersionBuilder: Builder<VersionDependency>, VersionBuildable {
    
    override init(dependency: VersionDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: VersionListener, isLatestVersion: Bool, currentVersion: String) -> VersionRouting {
        let viewController = VersionViewController(isLatestVersion: isLatestVersion, currentVersion: currentVersion)
        let interactor = VersionInteractor(presenter: viewController)
        interactor.listener = listener
        return VersionRouter(interactor: interactor, viewController: viewController)
    }
}
