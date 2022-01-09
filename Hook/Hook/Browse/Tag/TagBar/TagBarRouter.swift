//
//  TagBarRouter.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/07.
//

import RIBs

protocol TagBarInteractable: Interactable {
    var router: TagBarRouting? { get set }
    var listener: TagBarListener? { get set }
}

protocol TagBarViewControllable: ViewControllable {}

final class TagBarRouter: ViewableRouter<TagBarInteractable, TagBarViewControllable>, TagBarRouting {
    
    override init(interactor: TagBarInteractable, viewController: TagBarViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
