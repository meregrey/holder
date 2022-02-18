//
//  SelectTagsRouter.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/02/04.
//

import RIBs

protocol SelectTagsInteractable: Interactable {
    var router: SelectTagsRouting? { get set }
    var listener: SelectTagsListener? { get set }
}

protocol SelectTagsViewControllable: ViewControllable {}

final class SelectTagsRouter: ViewableRouter<SelectTagsInteractable, SelectTagsViewControllable>, SelectTagsRouting {
    
    override init(interactor: SelectTagsInteractable, viewController: SelectTagsViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
