//
//  LoggedInRouter.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/24.
//

import RIBs

protocol LoggedInInteractable: Interactable {
    var router: LoggedInRouting? { get set }
    var listener: LoggedInListener? { get set }
}

protocol LoggedInViewControllable: ViewControllable {}

final class LoggedInRouter: Router<LoggedInInteractable>, LoggedInRouting {
    
    private let viewController: LoggedInViewControllable
    
    init(interactor: LoggedInInteractable, viewController: LoggedInViewControllable) {
        self.viewController = viewController
        super.init(interactor: interactor)
        interactor.router = self
    }

    func cleanupViews() {}
}
