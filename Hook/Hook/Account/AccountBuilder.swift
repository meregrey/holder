//
//  AccountBuilder.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/02.
//

import RIBs

protocol AccountDependency: Dependency {}

final class AccountComponent: Component<AccountDependency> {}

// MARK: - Builder

protocol AccountBuildable: Buildable {
    func build(withListener listener: AccountListener) -> AccountRouting
}

final class AccountBuilder: Builder<AccountDependency>, AccountBuildable {

    override init(dependency: AccountDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AccountListener) -> AccountRouting {
        let viewController = AccountViewController()
        let interactor = AccountInteractor(presenter: viewController)
        interactor.listener = listener
        return AccountRouter(interactor: interactor, viewController: viewController)
    }
}
