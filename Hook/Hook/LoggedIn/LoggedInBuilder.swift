//
//  LoggedInBuilder.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/24.
//

import RIBs

protocol LoggedInDependency: Dependency {}

final class LoggedInComponent: Component<LoggedInDependency> {
    
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
        let viewController = LoggedInViewController()
        let interactor = LoggedInInteractor(presenter: viewController)
        interactor.listener = listener
        return LoggedInRouter(interactor: interactor, viewController: viewController)
    }
}
