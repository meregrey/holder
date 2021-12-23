//
//  RootBuilder.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/23.
//

import RIBs

protocol RootDependency: Dependency {}

final class RootComponent: Component<RootDependency>, RootInteractorDependency, LoggedOutDependency, LoggedInDependency {
    
    var credentialRepository: CredentialRepositoryType
    var loginStateStream: MutableLoginStateStreamType
    var loggedInViewController: LoggedInViewControllable
    
    init(dependency: RootDependency, loggedInViewController: LoggedInViewControllable) {
        self.credentialRepository = CredentialRepository(keychainManager: KeychainManager())
        self.loginStateStream = LoginStateStream()
        self.loggedInViewController = loggedInViewController
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
        let viewController = RootViewController()
        let component = RootComponent(dependency: dependency, loggedInViewController: viewController)
        let interactor = RootInteractor(presenter: viewController, dependency: component)
        let loggedOut = LoggedOutBuilder(dependency: component)
        let loggedIn = LoggedInBuilder(dependency: component)
        return RootRouter(interactor: interactor,
                          viewController: viewController,
                          loggedOut: loggedOut,
                          loggedIn: loggedIn)
    }
}
