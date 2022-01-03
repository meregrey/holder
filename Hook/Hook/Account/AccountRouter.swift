//
//  AccountRouter.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/02.
//

import RIBs

protocol AccountInteractable: Interactable {
    var router: AccountRouting? { get set }
    var listener: AccountListener? { get set }
}

protocol AccountViewControllable: ViewControllable {}

final class AccountRouter: ViewableRouter<AccountInteractable, AccountViewControllable>, AccountRouting {
    
    override init(interactor: AccountInteractable, viewController: AccountViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
