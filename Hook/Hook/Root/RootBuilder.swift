//
//  RootBuilder.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/23.
//

import RIBs

protocol RootDependency: Dependency {}

final class RootComponent: Component<RootDependency>, RootInteractorDependency {
    
    var credentialRepository: CredentialRepositoryType
    var loginStateStream: MutableLoginStateStreamType
    
    override init(dependency: RootDependency) {
        self.credentialRepository = CredentialRepository(keychainManager: KeychainManager())
        self.loginStateStream = LoginStateStream()
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol RootBuildable: Buildable {
    func build() -> LaunchRouting
}

final class RootBuilder: Builder<RootDependency>, RootBuildable {

    override init(dependency: RootDependency) {
        super.init(dependency: dependency)
    }

    func build() -> LaunchRouting {
        let component = RootComponent(dependency: dependency)
        let viewController = RootViewController()
        let interactor = RootInteractor(presenter: viewController, dependency: component)
        return RootRouter(interactor: interactor, viewController: viewController)
    }
}
