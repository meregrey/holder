//
//  LoggedInBuilder.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/24.
//

import RIBs

protocol LoggedInDependency: Dependency {
    var loggedInViewController: LoggedInViewControllable { get }
}

final class LoggedInComponent: Component<LoggedInDependency> {
    
    fileprivate var loggedInViewController: LoggedInViewControllable {
        return dependency.loggedInViewController
    }
    
    let credential: Credential
    
    init(dependency: LoggedInDependency, credential: Credential) {
        self.credential = credential
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol LoggedInBuildable: Buildable {
    func build(withListener listener: LoggedInListener, credential: Credential) -> LoggedInRouting
}

final class LoggedInBuilder: Builder<LoggedInDependency>, LoggedInBuildable {

    override init(dependency: LoggedInDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: LoggedInListener, credential: Credential) -> LoggedInRouting {
        let component = LoggedInComponent(dependency: dependency, credential: credential)
        let interactor = LoggedInInteractor()
        interactor.listener = listener
        return LoggedInRouter(interactor: interactor, viewController: component.loggedInViewController)
    }
}
