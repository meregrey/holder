//
//  EnterBookmarkRouter.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/01/27.
//

import RIBs

protocol EnterBookmarkInteractable: Interactable {
    var router: EnterBookmarkRouting? { get set }
    var listener: EnterBookmarkListener? { get set }
}

protocol EnterBookmarkViewControllable: ViewControllable {}

final class EnterBookmarkRouter: ViewableRouter<EnterBookmarkInteractable, EnterBookmarkViewControllable>, EnterBookmarkRouting {
    
    override init(interactor: EnterBookmarkInteractable, viewController: EnterBookmarkViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
