//
//  EditTagsRouter.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/15.
//

import RIBs

protocol EditTagsInteractable: Interactable {
    var router: EditTagsRouting? { get set }
    var listener: EditTagsListener? { get set }
}

protocol EditTagsViewControllable: ViewControllable {}

final class EditTagsRouter: ViewableRouter<EditTagsInteractable, EditTagsViewControllable>, EditTagsRouting {
    
    override init(interactor: EditTagsInteractable, viewController: EditTagsViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
