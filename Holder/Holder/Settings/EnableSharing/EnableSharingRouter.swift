//
//  EnableSharingRouter.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/06/09.
//

import RIBs

protocol EnableSharingInteractable: Interactable {
    var router: EnableSharingRouting? { get set }
    var listener: EnableSharingListener? { get set }
}

protocol EnableSharingViewControllable: ViewControllable {}

final class EnableSharingRouter: ViewableRouter<EnableSharingInteractable, EnableSharingViewControllable>, EnableSharingRouting {
    
    override init(interactor: EnableSharingInteractable, viewController: EnableSharingViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
