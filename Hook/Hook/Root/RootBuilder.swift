//
//  RootBuilder.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/23.
//

import RIBs

protocol RootDependency: Dependency {
    var loginStateStream: ReadOnlyStream<LoginState> { get }
}

final class RootComponent: Component<RootDependency>, RootInteractorDependency, LoggedOutDependency, LoggedInDependency {
    
    var loginStateStream: ReadOnlyStream<LoginState> { dependency.loginStateStream }
    
    override init(dependency: RootDependency) {
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol RootBuildable: Buildable {
    func build(withListener listener: RootListener) -> LaunchRouting
}

final class RootBuilder: Builder<RootDependency>, RootBuildable {

    override init(dependency: RootDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RootListener) -> LaunchRouting {
        let viewController = RootViewController()
        let component = RootComponent(dependency: dependency)
        let interactor = RootInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        let loggedOut = LoggedOutBuilder(dependency: component)
        let loggedIn = LoggedInBuilder(dependency: component)
        return RootRouter(interactor: interactor,
                          viewController: viewController,
                          loggedOut: loggedOut,
                          loggedIn: loggedIn)
    }
}
