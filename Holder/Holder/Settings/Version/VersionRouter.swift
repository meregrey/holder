//
//  VersionRouter.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/06/08.
//

import RIBs

protocol VersionInteractable: Interactable {
    var router: VersionRouting? { get set }
    var listener: VersionListener? { get set }
}

protocol VersionViewControllable: ViewControllable {}

final class VersionRouter: ViewableRouter<VersionInteractable, VersionViewControllable>, VersionRouting {
    
    override init(interactor: VersionInteractable, viewController: VersionViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
