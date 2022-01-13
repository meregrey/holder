//
//  EnterTagRouter.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/12.
//

import RIBs

protocol EnterTagInteractable: Interactable {
    var router: EnterTagRouting? { get set }
    var listener: EnterTagListener? { get set }
}

protocol EnterTagViewControllable: ViewControllable {}

final class EnterTagRouter: ViewableRouter<EnterTagInteractable, EnterTagViewControllable>, EnterTagRouting {
    
    override init(interactor: EnterTagInteractable, viewController: EnterTagViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
