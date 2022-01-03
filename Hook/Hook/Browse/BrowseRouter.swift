//
//  BrowseRouter.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/02.
//

import RIBs

protocol BrowseInteractable: Interactable {
    var router: BrowseRouting? { get set }
    var listener: BrowseListener? { get set }
}

protocol BrowseViewControllable: ViewControllable {}

final class BrowseRouter: ViewableRouter<BrowseInteractable, BrowseViewControllable>, BrowseRouting {
    
    override init(interactor: BrowseInteractable, viewController: BrowseViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
