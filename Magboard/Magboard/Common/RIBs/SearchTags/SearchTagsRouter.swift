//
//  SearchTagsRouter.swift
//  Magboard
//
//  Created by Yeojin Yoon on 2022/02/12.
//

import RIBs

protocol SearchTagsInteractable: Interactable {
    var router: SearchTagsRouting? { get set }
    var listener: SearchTagsListener? { get set }
}

protocol SearchTagsViewControllable: ViewControllable {}

final class SearchTagsRouter: ViewableRouter<SearchTagsInteractable, SearchTagsViewControllable>, SearchTagsRouting {
    
    override init(interactor: SearchTagsInteractable, viewController: SearchTagsViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
